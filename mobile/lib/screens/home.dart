import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../Helpers/global.dart';
import 'imageView.dart';
import 'synchronization.dart';

class HomeState extends StatefulWidget{
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomeState();
}

class _HomeState extends State<HomeState> {
  late List<File> images ;
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    setState(() {_isLoading = true ;});
    Future.microtask(() async {
      images = (await Directory((await getApplicationDocumentsDirectory()).path)
          .list(recursive: false)
          .where((event) => event.path.endsWith("jpg") || event.path.endsWith("png"))
          .map((event) => event as File)
          .toList()).cast<File>();
      setState(() {_isLoading = false;});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(MyGlobal.appName)),
        body: AnimationLimiter(
          child: _isLoading ? const Center(child: CircularProgressIndicator()) :
          images.isNotEmpty ?

          ListView.builder(
              itemCount: images.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (BuildContext context, int index) {
                File img = images[index];
                String filename = basename(img.path);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1000),
                  child: FadeInAnimation(
                    child: FadeInAnimation(
                      child: Card(
                        child: ListTile(
                            title:Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Text("$filename :",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                  CloseButton(onPressed: () async {
                                    await img.delete();
                                    images.removeAt(index);
                                    setState(() {
                                      images = images;
                                    });
                                  })
                                ],
                              ),
                            ),
                            subtitle: Image.file(File(img.path)),
                        ),
                      ),
                    ),
                  ),
                );
              }
          ):

          const Center(child: Text('Pas de données')),
        ),
        //gallery button and picture button
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                getImage(context, ImageSource.camera);
              },
              heroTag: 'image_picker_from_picture',
              tooltip: 'Caméra',
              child: const Icon(Icons.camera_alt),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                getImage(context, ImageSource.gallery);
              },
              heroTag: 'choice',
              tooltip: 'Choisir une image',
              child: const Icon(Icons.photo_library),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => SynchronizeState(images)));
              },
              heroTag: 'sync',
              tooltip: 'Synchroniser',
              child: const Icon(Icons.sync),
            )
          ],
        )
    );
  }

  Future<XFile?> getImage(BuildContext context, ImageSource source) async {
    XFile? image = await Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => ImageView(source))) as XFile?;
    if(image != null){
      final String path = (await getApplicationDocumentsDirectory()).path;
      await image.saveTo('$path/${image.name}');
      images.add(File(image.path));
      setState(() {
        images = images;
      });
    }
    return null;
  }

}