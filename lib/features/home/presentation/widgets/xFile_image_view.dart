import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// @author : Jibin K John
/// @date   : 26/12/2024
/// @time   : 22:21:07

class XFileImageView extends StatefulWidget {
  final XFile image;

  const XFileImageView({super.key, required this.image});

  @override
  State<XFileImageView> createState() => _XFileImageViewState();
}

class _XFileImageViewState extends State<XFileImageView> {
  Uint8List? _image;

  @override
  void initState() {
    _initImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: _image == null
          ? Center(
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            )
          : Image.memory(
              width: 150.0,
              height: 150.0,
              _image!,
              fit: BoxFit.cover,
            ),
    );
  }

  void _initImage() async {
    final image = await widget.image.readAsBytes();
    setState(() {
      _image = image;
    });
  }
}
