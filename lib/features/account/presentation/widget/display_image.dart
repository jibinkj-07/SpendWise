import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 21/11/2024
/// @time   : 16:47:00

class DisplayImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const DisplayImage({
    super.key,
    required this.imageUrl,
    this.height = 100,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: .5),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl.isEmpty
          ? Image.asset(AssetMapper.profileImage)
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (
                context,
                url,
                downloadProgress,
              ) =>
                  Center(
                child: SizedBox(
                  height: height * .1,
                  width: height * .1,
                  child: CircularProgressIndicator(
                    color: AppConfig.primaryColor,
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
    );
  }
}
