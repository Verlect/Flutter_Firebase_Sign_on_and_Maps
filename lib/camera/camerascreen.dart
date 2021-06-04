import 'package:flutter/material.dart';
import 'dart:io';

import 'package:camera/camera.dart';
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display The Picture')
      ),
      body: Image.file(File(imagePath)),
    );

  }
}
