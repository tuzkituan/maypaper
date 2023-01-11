import 'dart:ui';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        // toolbarHeight: 0,
        title: const Text(
          'MAYPAPER',
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.8),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.transparent,
            ),
          ),
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
