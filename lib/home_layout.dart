import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maypaper/views/home.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white.withOpacity(0.9),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: HomePage(),
    );
  }
}

class MyKeys {
  static final first = GlobalKey(debugLabel: 'home_page');
  static final second = GlobalKey(debugLabel: 'settings');
  static List<GlobalKey> getKeys() => [first, second];
}
