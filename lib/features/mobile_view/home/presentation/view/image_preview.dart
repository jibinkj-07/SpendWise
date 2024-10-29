import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_budget/core/constants/app_constants.dart';

class ImagePreview extends StatelessWidget {
  final String name;
  final String url;

  const ImagePreview({
    super.key,
    required this.name,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor:  Colors.black,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.5),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          splashRadius: 20.0,
        ),
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          child: Center(
            child: SizedBox(
              height: size.height * .5,
              width: size.width,
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (
                  context,
                  url,
                  downloadProgress,
                ) =>
                    Center(
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: CircularProgressIndicator(
                      color: AppConstants.kAppColor,
                      value: downloadProgress.progress,
                    ),
                  ),
                ),
                errorWidget: (
                  context,
                  url,
                  error,
                ) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
