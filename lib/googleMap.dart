import 'restDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:talabat_project_app/ListOfRestaurants.dart';


class RestMap extends StatefulWidget{
  List<Restaurants> restMap;
  RestMap(this.restMap);

  @override
  _RestMapState createState() => _RestMapState(restMap);
}

class _RestMapState extends State<RestMap>{
  List<Restaurants> restMap;
  _RestMapState(this.restMap);
  GoogleMapController _controller;
  List<Marker> allRestMarkers = [];

  @override
  void initState() {
    super.initState();
    restMap.forEach((element) {
      allRestMarkers.add(Marker(
        draggable: false,
        markerId: MarkerId(element.name),
        infoWindow:InfoWindow(title: element.name, snippet: element.city),
        position: LatLng(double.parse(element.lat),double.parse(element.lng)),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber[300],
        title:
        Text('Locations of Restaurants',style:TextStyle(
          fontWeight: FontWeight.bold, fontSize: 22,)),
      ),
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(31.5326,35.0998), zoom: 10.0,),
          markers: Set.from(allRestMarkers),
          onMapCreated: mapCreated,
        ),
      ),
    );
  }
  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
