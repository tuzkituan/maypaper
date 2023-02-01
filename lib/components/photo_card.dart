import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maypaper/models/photo_model.dart';

class PhotoCard extends StatefulWidget {
  PhotoCard({super.key, required this.photo, required this.onDownload});

  late Photos photo;
  late Function(Photos) onDownload;

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    Photos photo = widget.photo;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showPreviewImage(context, widget.photo);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: photo.src!.large ?? "",
              placeholder: (context, url) => Center(
                child: Container(),
              ),
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            photo.photographer!,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        Positioned(
          bottom: 3,
          right: 3,
          child: IconButton(
            onPressed: () => widget.onDownload(photo),
            iconSize: 20,
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void showPreviewImage(BuildContext context, Photos photo) {
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
            child: Wrap(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: photo.src!.large ?? "",
                    placeholder: (context, url) => Center(
                      child: Container(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Material(
                  color: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          photo.photographer!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () => widget.onDownload(photo),
                          iconSize: 20,
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
