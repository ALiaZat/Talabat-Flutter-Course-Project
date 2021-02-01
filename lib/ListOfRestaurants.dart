import 'googleMap.dart';
import 'menuList.dart';
import 'restDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'favoriteList.dart';
import 'firstPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'googleMap.dart';
import 'restDatabase.dart';

class Restaurants {
  int id;
  String name;
  String city;
  String lat;
  String lng;
  String phone;
  String image;
  int rate;

  Restaurants({this.id, this.name, this.city, this.lat, this.lng, this.phone,this.image, this.rate});
  static final columns =['id','name','city','lat','lng','phone','image','rate'];

  factory Restaurants.fromJson(dynamic json){
    String str1=json['image'];
    return Restaurants(
      id: json['id'] as int ,
      name: json['name'] as String ,
      city: json['city'] as String ,
      lat: json['lat'] as String  ,
      lng:json['lng'] as String ,
      phone:json['name'] as String ,
      image:'http://appback.ppu.edu/static/$str1' ,
      rate: json['rating'] as int ,
    );
  }
  factory Restaurants.fromMap(Map<String, dynamic> data){
    return Restaurants(
        id: data['id'],
        name: data['name'],
        city: data['city'],
        lat :data['lat'],
        lng:data['lng'] ,
        phone: data['phone'],
        image:data['image'] ,
        rate:data['rate']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "city": city,
      "lat":lat,
      "lng":lng,
      "phone":phone,
      "image":image,
      "rate":rate
    };
  }

}
class FromService{
  static Future<List<Restaurants>> fetchRestaurants() async{
    try{
      final http.Response response = await http.get('http://appback.ppu.edu/restaurants');
      if(response.statusCode == 200){
        List<Restaurants> _rest= parseRest(response.body);
        return _rest;
      }
      else {
        throw Exception ('Failed to load data');
      }
    }
    catch(e){
      throw Exception (e.toString());
    }
  }
  static List<Restaurants> parseRest (String responseBody){
    final parsed= json.decode(responseBody).cast<Map<String,dynamic>>();
    return parsed.map<Restaurants>((json) => Restaurants.fromJson(json)).toList();

  }
}

class ListOfRestaurants extends StatefulWidget {
  @override
  _ListOfRestaurantsState createState() => _ListOfRestaurantsState();
}

class _ListOfRestaurantsState extends State<ListOfRestaurants> {

  Future<List<Restaurants>> futureRest ;
  List<Restaurants> restPal=List() ;
  List<Restaurants> filterRest=List();

  @override
  void initState() {
    super.initState();
    this.futureRest=FromService.fetchRestaurants();
    FromService.fetchRestaurants().then((value) {
      setState(() {
        restPal=value;
        filterRest=restPal;

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber[300],
        title: Text('Restaurants',style:TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily:FontStyle.italic.toString() )),
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
        ],),
      body:Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Filter by city or rate',
                hintStyle: TextStyle(fontSize: 18.0,color: Colors.black26),
                icon: Icon(Icons.search,color: Colors.amber[400],),
              ),
              onChanged: (string){
                setState(() {
                  filterRest = restPal.where((element) =>
                  element.city.toLowerCase().contains(string.toLowerCase()) ||
                      element.rate.toString().toLowerCase().contains(string.toLowerCase())).toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filterRest.length,
                itemBuilder:(BuildContext context , int index){

                  return Container(
                    height: 160,
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child:Image.network(filterRest[index].image,width: 130,height:120,fit: BoxFit.cover,),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      child: Column(
                                        children: [
                                          Text(filterRest[index].name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,size: 17.5,color: Colors.black54,),
                                              SizedBox(width: 10,),
                                              Text(filterRest[index].city, style: TextStyle(fontSize: 18),),
                                            ],
                                          ),
                                          Container(
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10, 10, 0,0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: 3,
                                                    minRating: 1,
                                                    itemSize: 15,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                    itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                  Container(
                                                      padding: EdgeInsets.fromLTRB(12, 0, 0,0),
                                                      child: Text('${filterRest[index].rate}')),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                key: Key(filterRest[index].name),
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfMenu(filterRest[index]),));
                                                },
                                                child: FlatButton(
                                                  child: Icon(Icons.menu,color: Colors.black,size:20,),
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(Icons.add_location,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RestMap(filterRest),));
        },
      ),
    );
  }
}
