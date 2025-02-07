import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../bloc/account_bloc.dart';
import 'display_image.dart';

/// @author : Jibin K John
/// @date   : 20/12/2024
/// @time   : 18:56:26

class BottomProfileSelector extends StatefulWidget {
  final String currentImage;
  final String userId;
  final Size size;

  const BottomProfileSelector({
    super.key,
    required this.currentImage,
    required this.userId,
    required this.size,
  });

  @override
  State<BottomProfileSelector> createState() => _BottomProfileSelectorState();
}

class _BottomProfileSelectorState extends State<BottomProfileSelector> {
  final ValueNotifier<String> _selectedImage = ValueNotifier("");
  final ValueNotifier<bool> _isUploading = ValueNotifier(false);

  @override
  void initState() {
    _selectedImage.value = widget.currentImage;
    super.initState();
  }

  @override
  void dispose() {
    _selectedImage.dispose();
    _isUploading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocListener<AccountBloc, AccountState>(
        listener: (BuildContext context, AccountState state) {
          _isUploading.value = state is UpdatingProfileImage;
          if (state is AccountStateError) {
            Navigator.pop(context);
            state.error.showSnackBar(context);
          }
          if (state is UpdatedProfileImage) {
            Navigator.pop(context);
          }
        },
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (
            BuildContext context,
            ScrollController scrollController,
          ) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black54,
                          ),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            context.read<AccountBloc>().add(UpdateProfileImage(
                                userId: widget.userId,
                                profileName: _selectedImage.value));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppConfig.primaryColor,
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: _isUploading,
                    builder: (ctx, uploading, child) {
                      return uploading
                          ? Column(
                              children: [
                                SvgPicture.asset(
                                  AssetMapper.uploadSVG,
                                  height: widget.size.height * .3,
                                ),
                                Text(
                                  "Updating profile image\nPlease wait",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )
                          : child!;
                    },
                    child: Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: _selectedImage,
                          builder: (ctx, image, _) {
                            return GridView.builder(
                              controller: scrollController,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                final imageName = "profile_${index + 1}";
                                return GestureDetector(
                                  onTap: () {
                                    _selectedImage.value = imageName;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: image == imageName
                                          ? AppConfig.primaryColor
                                          : null,
                                    ),
                                    child: DisplayImage(imageUrl: imageName),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 1 / .8,
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
