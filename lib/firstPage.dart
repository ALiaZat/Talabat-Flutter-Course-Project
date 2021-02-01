import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:talabat_project_app/ListOfRestaurants.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-pizza-express-delivery-creative-vector-illustration-background-template-image_137402.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: 500,
                margin: EdgeInsets.fromLTRB(0, 200, 0,0),
                child: ScaleAnimatedTextKit(
                  duration: Duration(milliseconds:900),
                  totalRepeatCount: 14,
                  repeatForever: false, //this will ignore [totalRepeatCount]
                  pause: Duration(milliseconds:  500),
                  text: ["  Order", "  FOOD","  FROM"," Talabat"],
                  textStyle: TextStyle(fontSize: 60, fontWeight: FontWeight.bold,color: Colors.amber),
                  displayFullTextOnTap: true,
                  onTap: (){
                    Navigator.pushReplacement(context , MaterialPageRoute(builder: (context) => ListOfRestaurants(),));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(200, 200, 0, 50),
                child: Text('Tap to Continue', style:
                TextStyle(color: Colors.black26),),
              )
            ],


          ),

        )
    );
  }
}
