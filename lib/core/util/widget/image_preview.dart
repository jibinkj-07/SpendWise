import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../config/app_config.dart';
import '../helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 03/01/2025
/// @time   : 19:32:48

class ImagePreview extends StatelessWidget {
  final String name;
  final String? tag;
  final String url;
  final String? profileImage;

  const ImagePreview({
    super.key,
    required this.name,
    this.tag,
    this.profileImage,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F).withOpacity(.8),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Iconsax.arrow_left_2),
          color: Colors.white,
          splashRadius: 20.0,
        ),
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          child: Center(
            child: Hero(
              tag: tag ?? 'profileAvatar',
              child: SizedBox(
                height: size.height * .5,
                width: size.width,
                child: profileImage != null
                    ? Image(
                        image: AssetImage(
                            AssetMapper.getProfileImage(profileImage!)),
                      )
                    : CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (
                          context,
                          url,
                          downloadProgress,
                        ) =>
                            CircularProgressIndicator(
                          color: AppConfig.primaryColor,
                          value: downloadProgress.progress,
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
      ),
    );
  }
}
