import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maypaper/components/fade_indexed_stack.dart';
import 'package:maypaper/models/theme_model.dart';
import 'package:maypaper/views/home.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> _pages = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _tabController = TabController(length: 3, vsync: this);

    _pages = [
      const HomePage(),
      // This avoid the other pages to be built unnecessarily
      const SizedBox(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeModel>(context).isDark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // toolbarHeight: 0,
        title: const Text(
          'MAYPAPER',
          style: TextStyle(letterSpacing: 3, fontSize: 14),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              // now check if the chosen page has already been built
              // if it hasn't, then it still is a SizedBox
              if (_pages[index] is SizedBox) {
                if (index == 1) {
                  _pages[index] = Container(
                    key: MyKeys.getKeys().elementAt(index),
                  );
                }
              }

              _currentIndex = index;
            });
          },
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.cloud_outlined),
            ),
            Tab(
              icon: Icon(Icons.beach_access_sharp),
            ),
            Tab(
              icon: Icon(Icons.brightness_5_sharp),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return !await Navigator.maybePop(
            MyKeys.getKeys()[_currentIndex].currentState!.context,
          );
        },
        child: FadeIndexedStack(
          duration: const Duration(milliseconds: 200),
          index: _currentIndex,
          children: _pages,
        ),
      ),
    );
  }
}

class MyKeys {
  static final first = GlobalKey(debugLabel: 'home_page');
  static final second = GlobalKey(debugLabel: 'settings');
  static List<GlobalKey> getKeys() => [first, second];
}
