import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// @author : Jibin K John
/// @date   : 28/10/2024
/// @time   : 19:37:32

class DocumentView extends StatefulWidget {
  final XFile image;

  const DocumentView({super.key, required this.image});

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  Uint8List? _image;

  @override
  void initState() {
    _initImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          )
        : Image.memory(
            width: 100.0,
            height: 100.0,
            _image!,
            fit: BoxFit.cover,
          );
  }

  void _initImage() async {
    final image = await widget.image.readAsBytes();
    setState(() {
      _image = image;
    });
  }
}
