import 'package:flutter/cupertino.dart';
import 'menuList.dart';

class OrderedModel extends ChangeNotifier{
      final List<MenuList> _ordList = [];

      int get numItems => _ordList.length;

      MenuList getItem(int index) => _ordList[index];

      List<MenuList> get menu => _ordList;

      bool itemExists(MenuList m) => _ordList.indexOf(m)>=0 ? true: false;

      void add(MenuList m){
        _ordList.add(m);
        notifyListeners();
      }
      void remove(MenuList m){
          _ordList.remove(m);
          notifyListeners();
      }
      void removeAll(){
          _ordList.clear();
          notifyListeners();
      }
      int quantity(MenuList m){
          int q;
          if(itemExists(m))
            q ++;
          else
            q --;
          notifyListeners();
          return q;
      }
    }
    class FavModel extends ChangeNotifier{
        final List<MenuList> _List = [];
        int get numItems => _List.length;
        MenuList getItem(int index) => _List[index];

        bool itemExists(MenuList m) => _List.indexOf(m)>=0 ? true: false;
        void add(MenuList m){
          _List.add(m);
          notifyListeners();
      }
      void remove(MenuList m){
          _List.remove(m);
          notifyListeners();
      }
      void removeAll(){
          _List.clear();
          notifyListeners();
      }


}