import 'package:flutter/cupertino.dart';
import 'package:talabat_project_app/ListOfRestaurants.dart';

class RestaurantModel extends ChangeNotifier {
  List<Restaurants> rest ;
  RestaurantModel();
  int selectedIndex = 0;
  void setSelectedIndex(int value) {
    selectedIndex = value;
  }
  Restaurants get selectedRest => rest[selectedIndex];


}