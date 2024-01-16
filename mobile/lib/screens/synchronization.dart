import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../Helpers/data.dart';
import '../Helpers/func.dart';
import '../Helpers/http.dart';

class SynchronizeState extends StatefulWidget {
  const SynchronizeState({super.key});
  @override
  State<SynchronizeState> createState() => _SynchronizeState();
}

class _SynchronizeState extends State<SynchronizeState>{
  final TextEditingController _serverUrlField = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
      body: _isLoading ? const Center(child: CircularProgressIndicator()):AnimationLimiter(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: TextFormField(
                      controller: _serverUrlField,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Url de serveur',
                        suffixIcon: Icon(Icons.link),
                        hintText: 'Url de serveur',
                      ),
                      validator: (value) {
                        if (Func.isNull(value)) return "Vous devez donner l'URl !!!";
                        return null;
                      },
                      keyboardType: TextInputType.url,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RoundedLoadingButton(
        controller: _btnController,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if(await Http.setUrl(_serverUrlField.text)){
              Fluttertoast.showToast(msg: "Upload images",toastLength: Toast.LENGTH_SHORT);
            }
          }
          _btnController.reset();
        },
        child: const Text("Sychroniser", style: TextStyle(color: Colors.white))
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}