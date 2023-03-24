import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/foodwastepost.dart';

void main() {
  test(
      'Post created from constructor without certain values should just have null as a placeholder',
      () {
    final foodWastePost = FoodWastePost();

    expect(foodWastePost.date, null);
    expect(foodWastePost.imageURL, null);
    expect(foodWastePost.quantity, null);
    expect(foodWastePost.latitude, null);
    expect(foodWastePost.longitude, null);
  });

  test('Post should maintain same values that are added to the constructor',
      () {
    final date = DateTime.now().toString();
    const imageURL = 'really_real.jpg';
    const quantity = 222;
    const latitude = -1.234567;
    const longitude = 9.87654;

    final foodWastePost = FoodWastePost(
        date: date,
        imageURL: imageURL,
        quantity: quantity,
        latitude: latitude,
        longitude: longitude);

    expect(foodWastePost.date, date);
    expect(foodWastePost.imageURL, imageURL);
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);
  });
}
