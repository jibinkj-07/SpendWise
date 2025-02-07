import 'package:flutter/material.dart';

import '../../../auth/domain/model/user_model.dart';
import 'bottom_profile_selector.dart';
import 'display_image.dart';

/// @author : Jibin K John
/// @date   : 13/01/2025
/// @time   : 13:17:39

class ProfileInfo extends StatelessWidget {
  final Size size;
  final UserModel user;

  const ProfileInfo({
    super.key,
    required this.size,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DisplayImage(
          imageUrl: user.profileUrl,
          height: size.height * .15,
          width: size.height * .15,
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BottomProfileSelector(
                  currentImage: user.profileUrl,
                  userId: user.uid,
                  size: size,
                ),
              ),
            );
          },
          child: Text("Change"),
        ),
        Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          user.email,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
