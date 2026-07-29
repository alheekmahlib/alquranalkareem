import 'package:flutter/material.dart';

/// A widget that adapts its layout to the current screen width.
///
/// Pick a widget per form factor and [Responsive] will show the most fitting
/// one. The breakpoints used here are **consistent** between [build] and the
/// static helpers ([isMobile], [isMobileLarge], [isTablet], [isDesktop]):
///
/// | Form factor  | Range (width in logical px) |
/// | ------------ | -------------------------- |
/// | mobile       | `width < 500`              |
/// | mobileLarge  | `500 ≤ width < 700`        |
/// | tablet       | `700 ≤ width < 1024`       |
/// | desktop      | `width ≥ 1024`             |
///
/// The ranges are mutually exclusive and cover the whole spectrum, so callers
/// can safely combine the helpers in `if/else if` chains without worrying
/// about gaps or overlaps.
class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    required this.desktop,
  });

  /// Layout for small phones (`width < 500`).
  final Widget mobile;

  /// Layout for large phones / small tablets (`500 ≤ width < 700`).
  /// Falls back to [mobile] when not provided.
  final Widget? mobileLarge;

  /// Layout for tablets (`700 ≤ width < 1024`).
  /// Falls back to [mobileLarge] then [mobile] when not provided.
  final Widget? tablet;

  /// Layout for desktops (`width ≥ 1024`).
  final Widget desktop;

  // ── Breakpoints (single source of truth) ──────────────────────────────
  /// Width at which a phone is considered "large".
  static const double mobileLargeBreakpoint = 500;

  /// Width at which the layout switches to the tablet form factor.
  static const double tabletBreakpoint = 700;

  /// Width at which the layout switches to the desktop form factor.
  static const double desktopBreakpoint = 1024;

  /// The current screen width.
  static double _width(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// `true` when the screen is a small phone (`width < 500`).
  static bool isMobile(BuildContext context) =>
      _width(context) < mobileLargeBreakpoint;

  /// `true` when the screen is a large phone (`500 ≤ width < 700`).
  static bool isMobileLarge(BuildContext context) {
    final width = _width(context);
    return width >= mobileLargeBreakpoint && width < tabletBreakpoint;
  }

  /// `true` when the screen is a tablet (`700 ≤ width < 1024`).
  static bool isTablet(BuildContext context) {
    final width = _width(context);
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  /// `true` when the screen is a desktop (`width ≥ 1024`).
  static bool isDesktop(BuildContext context) =>
      _width(context) >= desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    final width = _width(context);
    if (width >= desktopBreakpoint) {
      return desktop;
    }
    if (width >= tabletBreakpoint && tablet != null) {
      return tablet!;
    }
    if (width >= mobileLargeBreakpoint && mobileLarge != null) {
      return mobileLarge!;
    }
    return mobile;
  }
}
