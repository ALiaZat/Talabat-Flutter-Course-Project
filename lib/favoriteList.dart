import 'package:talabat_project_app/ListOfRestaurants.dart';
import 'menuDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menuList.dart';
import 'model.dart';
import 'orderedList.dart';

class FavoriteList extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(title: Text("Favorite List",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.amber[300],
          actions: [
            IconButton(
              tooltip: 'OrderedList',
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderedList(Restaurants())),
                );
              },
            ),
          ],
        ),
        body: Consumer<MenuDatabase>(
          builder: (context, favList, child){
            return Favorite(menuFuture: MenuDatabase.mdb.getAllMenus(),);
          },
        )
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final MenuList menu;
  FavoriteItem({@required this.menu});
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
                              IconButton(
                                  icon: Icon(Icons.favorite),
                                  onPressed: () {
                                    MenuDatabase.mdb.removeMenu(this.menu.mID);
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

class Favorite extends StatelessWidget{
  final Future<List<MenuList>> menuFuture;
  Favorite({this.menuFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuList>>(
      future: this.menuFuture,
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<MenuList> m=snapshot.data;
          return ListView.builder(
            itemCount: m.length,
            itemBuilder: (BuildContext context, int index){
              return FavoriteItem(menu: m[index],);
            },
          );
        }
        else if(snapshot.hasError){
          return Text('Error:${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

}
