import 'package:talabat_project_app/ListOfRestaurants.dart';
import 'totalPrice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menuList.dart';
import 'model.dart';

class OrderedList extends StatelessWidget{
  Restaurants rest;
  OrderedList(this.rest);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(title: Text("Ordered List",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.amber[300],
          actions: [
            Consumer<OrderedModel>(
                builder: (context,value,child) {
                  return IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    tooltip: 'submit your order',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                          new AlertDialog(
                            title: Text(
                              "Order Confirmation", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[500],),),
                            content: new Text(
                              "Do you want to confirm your order ? ",
                              textAlign: TextAlign.center, style: TextStyle(
                                fontSize: 16, color: Colors.black54),),
                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 40, 12),
                                child: Row(
                                  children: [
                                    FlatButton.icon(
                                      label: Text('Yes', style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),),
                                      icon: Icon(
                                        Icons.done, color: Colors.amber[400],),
                                      color: Colors.black12,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                            new AlertDialog(
                                              content: Container(
                                                height: 300,
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(Icons.restaurant,
                                                          color: Colors.orange[900],
                                                          size: 30,),
                                                        Image.network(
                                                          'https://www.deliveryhero.com/wp-content/uploads/2017/08/talabat-logo-1.png',
                                                          width: 140,
                                                          height: 120,),
                                                      ],
                                                    ),
                                                    new Text(
                                                      "Your order on its way",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          fontSize: 22,
                                                          color: Colors.black87),),
                                                    Image.network(
                                                      'https://miro.medium.com/max/919/0*4_6SlM3lVujkzBJo.gif',
                                                      width: 160,
                                                      height: 145,),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(10, 0, 100, 65),
                                                  child: FlatButton(
                                                    child: Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 18),),
                                                    color: Colors.deepOrange[300],
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    highlightColor: Colors
                                                        .orange[50],
                                                  ),
                                                ),
                                              ],
                                            ));
                                        value.removeAll();
                                      },
                                    ),
                                    SizedBox(width: 60,),
                                    FlatButton.icon(
                                      label: Text('No', style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),),
                                      icon: Icon(
                                        Icons.close, color: Colors.amber[400],),
                                      color: Colors.black12,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  );
                }
            ),
            IconButton(
              icon: Icon(Icons.monetization_on),
              tooltip: 'Total Price',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TotalPrice(),));

              },
            ),
          ],),
        body: Consumer<OrderedModel>(
          builder: (context, ordList, child){
            return GestureDetector(
              key: Key(rest.id.toString()),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) =>
                    new AlertDialog(
                      content: new Text("This meal from \n ( ${rest.name} ) restaurant",
                        textAlign:TextAlign.center,style: TextStyle(fontSize:20),),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Close',style: TextStyle(color: Colors.amber[400],fontSize: 16,fontWeight: FontWeight.bold),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
              },
              child: ListView.builder(
                itemCount: ordList.numItems,
                itemBuilder: (BuildContext context, int index){
                  return MenuItem(menu: ordList.getItem(index),);
                },
              ),
            );
          },
        )
    );
  }
}
