import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:alquranalkareem/shared/widgets/sorah_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import 'juz_page.dart';

class SorahJuzList extends StatefulWidget {
  const SorahJuzList({super.key});

  @override
  _SorahJuzListState createState() => _SorahJuzListState();
}

class _SorahJuzListState extends State<SorahJuzList>
    with SingleTickerProviderStateMixin {
  var dSorahJuzListKey = GlobalKey<ScaffoldState>();
  var controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      key: dSorahJuzListKey,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight:
                    orientation == Orientation.portrait ? 130.0 : 30.0,
                floating: false,
                pinned: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12))),
                leading: IconButton(
                  icon: Icon(Icons.close_outlined,
                      color: ThemeProvider.themeOf(context).id == 'dark'
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColorDark),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                flexibleSpace: FlexibleSpaceBar(
                  title: SvgPicture.asset(
                    'assets/svg/Logo_line2.svg',
                    height: 65,
                    width: MediaQuery.of(context).size.width / 1 / 2,
                  ),
                  centerTitle: true,
                  background: Opacity(
                    opacity: .1,
                    child: SvgPicture.asset('assets/svg/splash_icon.svg'),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        child: Text(
                          AppLocalizations.of(context)!.quran_sorah,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 12,
                              fontFamily: 'kufi'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppLocalizations.of(context)!.allJuz,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 12,
                              fontFamily: 'kufi'),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              SorahList(),
              QuranJuz(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
