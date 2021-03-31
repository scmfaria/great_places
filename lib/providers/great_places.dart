import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_util.dart';

class GreatePlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items]; // retorna um clone da lista 
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList.map((item) => 
      Place(
        id: item['id'],
        title: item['title'],
        image: File(item['image']),
        location: null,
      ),
    ).toList();
    notifyListeners();
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: Random().nextDouble().toString(), 
      title: title, 
      location: null, 
      image: image,
    );

    _items.add(newPlace);

    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image,
    });

    notifyListeners();
  }
}