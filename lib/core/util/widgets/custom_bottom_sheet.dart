import 'package:flutter/material.dart';

class CustomBottomSheet {
  static showImagePickerDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Function onTakePhoto,
    required Function onChoosePhoto,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      elevation: 0.0,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -- heading --
                ListTile(
                  title: Text(title),
                  subtitle: Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: IconButton.styleFrom(foregroundColor: Colors.grey),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(.3),
                  height: 0.0,
                  thickness: .5,
                ),
                // -- options --

                ListTile(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    onTakePhoto();
                  },
                  leading: Icon(Icons.camera_alt_rounded,
                      color: Theme.of(context).primaryColor),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15.0,
                    color: Colors.grey,
                  ),
                  title: const Text('Take Photo'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    onChoosePhoto();
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20.0),
                    ),
                  ),
                  leading: Icon(Icons.photo_library_rounded,
                      color: Theme.of(context).primaryColor),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15.0,
                    color: Colors.grey,
                  ),
                  title: const Text('Choose Photo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
