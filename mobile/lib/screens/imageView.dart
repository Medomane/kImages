import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../Helpers/func.dart';

class ImageView extends StatefulWidget {
  final ImageSource source;
  const ImageView(this.source, {super.key});
  @override
  State<ImageView> createState() => _ImageViewState();
}
class _ImageViewState extends State<ImageView>{
  late ImageSource source;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    source = widget.source;
    Future.microtask(() async {
      try {
        final pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _imageFile = pickedFile;
        });
      }
      catch (e) {
        Func.showError(e.toString());
        if (mounted) Navigator.of(context).pop("error");
      }
    });
  }

  dynamic getImage(){
    return _imageFile == null ? const AssetImage('images/icon.png') : FileImage(File(_imageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PhotoView(
        imageProvider: getImage(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () async {
                if(_imageFile == null) {
                  if (mounted) Navigator.of(context).pop(null);
                } else {
                  var size = ((await File(_imageFile!.path).length())/1024)/1024;
                  if(size >= 1){
                    await Func.showError("La taille de cette image est supérieure à 1mb, cela peut causer des problèmes au niveau de l'affichage !!!");
                    return ;
                  }
                  if (mounted) Navigator.of(context).pop(_imageFile);
                }
              },
              heroTag: 'validate',
              tooltip: 'Valider',
              child: const Icon(Icons.check),
            ),
          ),
          _imageFile != null ? Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              onPressed: () async {
                final croppedFile = await ImageCropper().cropImage(
                    sourcePath: _imageFile!.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Redimensionner',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        minimumAspectRatio: 1.0,
                        title: 'Cropper',
                      ),
                    ]
                ) ;
                if(croppedFile != null){
                  var pf = XFile(croppedFile.path);
                  setState(() {
                    _imageFile = pf;
                  });
                }
              },
              heroTag: 'crop',
              tooltip: 'Redimensionner',
              child: const Icon(Icons.crop),
            ),
          ):const SizedBox.shrink(),
        ],
      ),
    );
  }
}