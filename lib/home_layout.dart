import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maypaper/providers/home_page_provider.dart';
import 'package:maypaper/views/home.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  final searchController = TextEditingController(text: "");
  num _page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchImages();
    });
  }

  Future<dynamic> _fetchImages() {
    String searchValue = searchController.text;

    final homePageProvider =
        Provider.of<HomePageProvider>(context, listen: false);

    print('search ' + searchValue);

    return homePageProvider.getImages({
      "query": searchValue.isEmpty ? "analog" : searchValue,
      "page": _page.toString()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        title: Text(
          searchController.text.isNotEmpty ? searchController.text : 'maypaper',
          style: const TextStyle(
            letterSpacing: 3,
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
        backgroundColor: Colors.black.withOpacity(1),
        actions: [
          IconButton(
            onPressed: () {
              searchController.clear();
              showSearch(context);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
        // flexibleSpace: ClipRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        //     child: Container(
        //       color: Colors.transparent,
        //     ),
        //   ),
        // ),
      ),
      body: HomePage(
        fetchImages: _fetchImages,
        page: _page,
        onIncPage: () => {
          setState(() {
            _page = _page + 1;
          })
        },
      ),
    );
  }

  void onSearchFinish(context) {
    setState(() {
      _page = 1;
    });
    _fetchImages();
    Navigator.pop(context);
  }

  void showSearch(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Material(
              child: Wrap(
                children: [
                  TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.go,
                    autofocus: true,
                    onSubmitted: (value) => onSearchFinish(context),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      hintText: 'Enter a search term',
                      hintStyle:
                          const TextStyle(color: Colors.white30, fontSize: 14),
                      suffixIcon: IconButton(
                        onPressed: () => {onSearchFinish(context)},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyKeys {
  static final first = GlobalKey(debugLabel: 'home_page');
  static final second = GlobalKey(debugLabel: 'settings');
  static List<GlobalKey> getKeys() => [first, second];
}
