import 'dart:async';

import 'package:flutter/material.dart';

import 'gallery.dart';
import 'synchronization.dart';

class HomeState extends StatefulWidget{
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomeState();
}

class _HomeState extends State<HomeState> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>() ;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {_isLoading = true ;});
    Future.microtask(() async {

      setState(() {_isLoading = false;});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.photo_album)),
              Tab(icon: Icon(Icons.sync)),
            ],
          ),
          title: const Text('kImages'),
        ),
        body: const TabBarView(
          children: [
            GalleryState(),
            SynchronizeState(),
          ],
        ),
      ),
    );
  }

}