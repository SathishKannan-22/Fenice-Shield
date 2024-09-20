import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PictureScreen extends StatefulWidget {
  final String imageUrl;

  const PictureScreen({super.key, required this.imageUrl});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: widget.imageUrl,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 30,
                    ),
                  );
                },
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
          Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.grey,
                    size: 42,
                  ))),
        ],
      ),
    );
  }
}
