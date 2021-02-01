import 'menuDatabase.dart';
import 'restDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:talabat_project_app/ListOfRestaurants.dart';
import 'model.dart';
import 'orderedList.dart';
import 'favoriteList.dart';

class MenuList {
  int mID;
  int restID;
  String mealName;
  String description;
  double price;
  String mealImage;
  int mealRate;

  MenuList({this.mID, this.restID, this.mealName, this.description, this.price, this.mealImage, this.mealRate});
  static final columns =['id','rest_id','name','descr','price','image','rating'];

  factory MenuList.fromJson(dynamic menuJson){
    String str = menuJson['image'];

    return MenuList(
      mID: menuJson['id'] as int ,
      restID: menuJson['rest_id'] as int ,
      mealName: menuJson['name'] as String ,
      description : menuJson['descr'] as String ,
      price: double.parse(menuJson['price'].toString()) ,
      mealImage : 'http://appback.ppu.edu/static/$str' ,
      mealRate: menuJson['rating'] as int ,
    );
  }

  factory MenuList.fromMap(Map<String,dynamic>data){
    return MenuList(
        mID: data['id'],
        restID: data['rest_id'],
        mealName: data['name'],
        description: data['descr'],
        price: data['price'],
        mealImage: data['image'],
        mealRate: data['rating']
    );
  }
  Map < String ,dynamic> toMap(){
    return{
      "id":mID,
      "rest_id":restID,
      "name":mealName,
      "descr":description,
      "price":price,
      "image":mealImage,
      "rating":mealRate
    };
  }
}
class ListOfMenu extends StatefulWidget {
  final Restaurants restaurant;
  ListOfMenu(this.restaurant);
  @override
  _ListOfMenuState createState() => _ListOfMenuState(restaurant);
}

class _ListOfMenuState extends State<ListOfMenu> {
  final Restaurants rest;
  _ListOfMenuState(this.rest);

  Future<List<MenuList>> futureMenu;
  Future<List<MenuList>> fetchMenu() async{
    final http.Response response = await http.get('http://appback.ppu.edu/menus/${rest.id}');
    List<MenuList> _menu=[];
    if(response.statusCode == 200){
      var jsonArray = jsonDecode(response.body) as List;
      _menu = jsonArray.map((e) => MenuList.fromJson(e)).toList();
      return _menu;
    }
    else {
      throw Exception ('Failed to load data');
    }

  }
  @override
  void initState() {
    super.initState();
    this.futureMenu =fetchMenu();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text('Menu of ${rest.name}',style: TextStyle(fontSize: 20),),
        backgroundColor: Colors.amber[300],
        actions: [
          IconButton(
            iconSize: 25,
            tooltip: 'FavoriteList',
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteList()),
              );
            },
          ),
          IconButton(
            tooltip: 'OrderedList',
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderedList(rest)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MenuList>>(
          future: this.futureMenu,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MenuList> m = snapshot.data;
              return ListView.builder(
                itemCount: m.length,
                itemBuilder: (BuildContext context, int index){
                  return MenuItem(menu: m[index],
                  );
                },
              );
            }
            else if (snapshot.hasError) {
              return Text("error ${snapshot.error}");
            }
            return Center(
                child:CircularProgressIndicator()
            );
          }
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final MenuList menu;
  MenuItem({@required this.menu});


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160,
        child: Card(
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Image.network(this.menu.mealImage,width:160,height:110,fit: BoxFit.fill,)),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 20, 5, 0),
                      child: Column(
                        children: [
                          Text(this.menu.mealName , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                          Container(
                            width: 180,
                            child: Text(this.menu.description ,
                              style: TextStyle(fontSize: 10,),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,),
                          ),
                          Row(

                            children: [
                              Text('Price: '+this.menu.price.toString() , style: TextStyle(fontSize: 18),),
                              SizedBox(width: 10,),
                              Text('Quantity:'),
                            ],
                          ),
                          Text('Rate: '+this.menu.mealRate.toString(), style: TextStyle(fontSize: 15),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Consumer<FavModel>(
                                  builder: (context,favList,child){
                                    bool addedToFavList = favList.itemExists(menu);
                                    return IconButton(
                                      iconSize: 20,
                                      icon: Icon(
                                        addedToFavList? Icons.favorite : Icons.favorite_border,
                                      ),
                                      onPressed: (){
                                        favList.itemExists(menu)?
                                        { Provider.of<FavModel>(context,listen: false).remove(menu),
                                          MenuDatabase.mdb.removeMenu(menu.mID)}:
                                        {Provider.of<FavModel>(context,listen: false).add(menu),
                                          MenuDatabase.mdb.addMenu(menu) };
                                      },
                                    );
                                  }
                              ),
                              Consumer<OrderedModel>(
                                builder: (context, value, child) {
                                  bool addedToOrderedList = value.itemExists(menu);

                                  return IconButton(
                                    iconSize: 20,
                                    icon:Icon(
                                      addedToOrderedList? Icons.done : Icons.add_shopping_cart,
                                    ),
                                    onPressed: (){
                                      value.itemExists(menu)?
                                      Provider.of<OrderedModel>(context,listen:false).remove(menu):
                                      Provider.of<OrderedModel>(context,listen:false).add(menu);

                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ),
            ],
          ),
        )
    );
  }

}
