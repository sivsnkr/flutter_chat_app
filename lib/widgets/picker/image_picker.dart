import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({Key? key, required this.setFile}) : super(key: key);

  final void Function(PickedFile file) setFile;
  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  PickedFile? _pickedFile;

  Future<void> _pickImage() async {
    final _picker = new ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      widget.setFile(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                _pickedFile != null ? FileImage(File(_pickedFile!.path)) : null,
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Add Image"),
          ),
        ],
      ),
    );
  }
}
