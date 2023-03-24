import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:wasteagram/models/foodwastepost.dart';

// ignore: must_be_immutable
class CameraWidget extends StatefulWidget {
  File? image;
  CameraWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  final picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  var url;
  LocationData? locationData;
  var locationService = Location();
  FoodWastePost? foodWastePost;

  @override
  void initState() {
    super.initState();
    getImage();
    getLocation();
  }

  void getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);

    var fileName = '${DateTime.now()}.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    url = await storageReference.getDownloadURL();
    setState(() {});
  }

  void getLocation() async {
    try {
      var serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          if (kDebugMode) {
            print('Failed to enable service.');
          }
          return;
        }
      }

      var permissionGranted = await locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          if (kDebugMode) {
            print('Location service permission not granted');
          }
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}, code: ${e.code}');
      }
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: Image.file(image!)),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Semantics(
              enabled: true,
              textField: true,
              label: 'Type in the quantity of food items that were wasted',
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Number of Wasted Items'),
                onSaved: (newValue) {
                  String date =
                      '${DateFormat('EEEE').format(DateTime.now())}, ${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().day}, ${DateTime.now().year}';
                  foodWastePost = FoodWastePost(
                      date: date,
                      imageURL: url,
                      quantity: int.parse(newValue!),
                      latitude: locationData!.latitude,
                      longitude: locationData!.longitude);
                  foodWastePost?.uploadData();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a number';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          Expanded(
            child: Semantics(
              enabled: true,
              button: true,
              label: 'Save the wasted food items to the database',
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    // throw Exception();
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.cloud_upload)),
            ),
          )
        ]),
      );
    }
  }
}
