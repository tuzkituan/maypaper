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
  Widget _renderDetail(photo, context) {
    return Container(
      decoration: const BoxDecoration(
          // color: Colors.black,
          ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.3,
                imageUrl: photo.src!.medium ?? "",
                placeholder: (context, url) => Center(
                  child: Container(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            photo.photographer,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Author',
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              widget.onDownload(photo);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50), // NEW
              backgroundColor: Colors.teal,
            ),
            child: const Text('DOWNLOAD'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Photos photo = widget.photo;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (context) {
                return _renderDetail(widget.photo, context);
              },
            );
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
}
