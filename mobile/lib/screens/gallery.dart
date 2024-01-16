import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../Helpers/data.dart';
import '../Helpers/func.dart';

class GalleryState extends StatefulWidget {
  const GalleryState({super.key});
  @override
  State<GalleryState> createState() => _GalleryState();
}

class _GalleryState extends State<GalleryState>{
  final TextEditingController _serverUrlField = TextEditingController();
  bool _isLoading = true;
  @override
  void initState(){
    super.initState();
    _initUrl();
  }
  _initUrl() {
    setState(() {_isLoading = true ;});
    Future.microtask(() async {
      _serverUrlField.text = await MyData.getCurrentServerUrl() ?? '';
      setState(() {_isLoading = false ;});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading ? const Center(child: CircularProgressIndicator()) : const AnimationLimiter(
          child: Text("test"),
        ),
        //gallery button and picture button
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try{
              var val = await Navigator.push(context, MaterialPageRoute(builder:(context)=>ImageView()));
              if(!Func.isNull(val) && val == "edited"){
                id = currentItem!.id;
                await _initData();
              }
            }
            catch(er){

            }
          },
          child: const Icon(Icons.add_circle),
        )
    );
  }
}

class ImageView extends StatefulWidget {
  //final String path;
  const ImageView(/*this.path, */{super.key});
  @override
  State<ImageView> createState() => _ImageViewState();
}
class _ImageViewState extends State<ImageView>{
  //late String path;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  void _onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
      });
    }
    catch (e) {
      Func.showError(e.toString());
    }
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
                /*if(_imageFile == null) {
                  await item.removeImage();
                } else {
                  var size = ((await File(_imageFile!.path).length())/1024)/1024;
                  if(size >= 1){
                    await Func.showError("La taille de cette image est supérieure à 1mb, cela peut causer des problèmes au niveau de l'affichage !!!");
                    return ;
                  }
                  await item.updateImage(base64Encode(await _imageFile!.readAsBytes()));
                }*/
                if (!mounted) return;
                Navigator.of(context).pop("edited");
              },
              heroTag: 'done',
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
          Semantics(
            label: 'image_picker_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery);
              },
              heroTag: 'choice',
              tooltip: 'Choisir une image',
              child: const Icon(Icons.photo_library),
            ),
          )
        ],
      ),
    );
  }
}