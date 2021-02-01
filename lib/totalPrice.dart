import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menuList.dart';
import 'model.dart';

class TotalPrice extends StatelessWidget{

  double price=0;
  void totalPrice (List<MenuList> m){
    m.forEach((element) {
      price += element.price;
    });
  }
  @override
  Widget build(BuildContext context) {
    totalPrice(Provider.of<OrderedModel>(context,listen: false).menu);

    return Scaffold(
        appBar: AppBar(
          title: Text('Total Price',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.amber[300],
        ),
        body:Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 150, 5, 10),
            child: Column(
              children: [
                Text('The Total price of your Orders is :',style: TextStyle(fontSize: 24),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${price}',style: TextStyle(fontSize: 20),),
                    Icon(Icons.attach_money)

                  ],
                ),
              ],
            ),
          ),
        )
    );

  }

}