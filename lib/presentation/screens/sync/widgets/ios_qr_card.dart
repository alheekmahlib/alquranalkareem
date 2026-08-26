part of '../sync.dart';

/// بطاقة QR بأسلوب iOS Quick Start: هالة تتنفس ببطء خلف رمز ناعم الوحدات
/// يحمل شعار التطبيق، وجسيمات هادئة حولها.
/// تحترم تفضيل «تقليل الحركة» بإسقاط الحركة والجسيمات.
class IosQrCard extends StatefulWidget {
  const IosQrCard({super.key, required this.data, this.size = 210.0});

  final String data;
  final double size;

  @override
  State<IosQrCard> createState() => _IosQrCardState();
}

class _IosQrCardState extends State<IosQrCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;
  final Random _random = Random();

  static const Duration _breathPeriod = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(vsync: this, duration: _breathPeriod);
    _breath.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  List<CircularParticle> _buildParticles(double area, Color color, bool calm) {
    return List.generate(12, (_) {
      final dx = (_random.nextDouble() - 0.5) * (calm ? 0.35 : 0.6);
      final dy = (_random.nextDouble() - 0.5) * (calm ? 0.35 : 0.6);
      return CircularParticle(
        radius: _random.nextDouble() * 1.8 + 1.2,
        color: color,
        velocity: Offset(dx, dy),
        startPosition: Offset(
          _random.nextDouble() * area,
          _random.nextDouble() * area,
        ),
        startOpacity: 0.25,
        endOpacity: 0.7,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) _breath.stop();

    final size = widget.size;
    final area = size + 96;
    final haloColor = theme.primaryColorLight;

    final qrCard = Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: haloColor.withValues(alpha: 0.25),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: PrettyQrView.data(
        data: widget.data,
        errorCorrectLevel: QrErrorCorrectLevel.H,
        decoration: PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(
            roundFactor: 0.5,
            // تباين داكن على سطح فاتح — أولوية قابلية المسح.
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1B1B1F),
          ),
          image: const PrettyQrDecorationImage(
            image: AssetImage('assets/quran_logo_mac.png'),
          ),
        ),
      ),
    );

    final halo = ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: AnimatedBuilder(
        animation: _breath,
        builder: (context, _) {
          final t = Curves.easeInOut.transform(_breath.value);
          return Transform.scale(
            scale: lerpDouble(1.0, 1.08, t)!,
            child: Opacity(
              opacity: lerpDouble(0.45, 0.9, t)!,
              child: Container(
                width: size + 64,
                height: size + 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [haloColor, haloColor.withValues(alpha: 0)],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    return SizedBox(
      width: area,
      height: area,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (!reduceMotion)
            Positioned.fill(
              child: IgnorePointer(
                child: Particles(
                  width: area,
                  height: area,
                  boundType: BoundType.WrapAround,
                  particles: _buildParticles(
                    area,
                    haloColor.withValues(alpha: 0.6),
                    true,
                  ),
                ),
              ),
            ),
          if (!reduceMotion) halo,
          qrCard,
        ],
      ),
    );
  }
}
