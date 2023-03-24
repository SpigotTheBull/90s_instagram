import 'package:cloud_firestore/cloud_firestore.dart';

class FoodWastePost {
  String? date;
  String? imageURL;
  int? quantity;
  double? latitude;
  double? longitude;

  FoodWastePost(
      {this.date, this.imageURL, this.quantity, this.latitude, this.longitude});

  void uploadData() async {
    FirebaseFirestore.instance.collection('posts').add({
      'date': date,
      'imageURL': imageURL,
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude
    });
  }
}
