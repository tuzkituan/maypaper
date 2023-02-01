import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maypaper/components/photo_card.dart';
import 'package:maypaper/models/photo_model.dart';
import 'package:maypaper/providers/home_page_provider.dart';
import 'package:maypaper/utils/custom_snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.fetchImages,
      required this.page,
      required this.onIncPage});

  late Function() fetchImages;
  late Function() onIncPage;
  num? page;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController scrollController;
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      widget.onIncPage();
      widget.fetchImages();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  String getExt(String url) {
    if (url.contains('jpg')) return 'jpg';
    if (url.contains('jpeg')) return 'jpeg';
    if (url.contains('png')) return 'png';
    if (url.contains('gif')) return 'gif';
    return 'jpg';
  }

  void onDownload(Photos photo) async {
    if (photo.src!.original!.isEmpty) return;

    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
      showSnackBar("Downloading...", 'info');
      try {
        await Dio().download(photo.src!.original!,
            "$_localPath/${photo.id}.${getExt(photo.src!.original!)}");
        showSnackBar("Downloaded", 'success');
      } catch (e) {
        showSnackBar("Download failed", 'error');
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var homePageProvider = Provider.of<HomePageProvider>(context);
    List<Photos>? photos = homePageProvider.photos;
    bool? isLoadingFetch = homePageProvider.isLoadingFetch;

    if (isLoadingFetch == true && photos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.separated(
      // physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0),
      itemCount: photos.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        return PhotoCard(photo: photos[index], onDownload: onDownload);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 0.5,
        color: Colors.black12,
      ),
    );
  }
}
