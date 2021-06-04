import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:signin/camera/cameras.dart';
import 'package:signin/camera/testing.dart';
import 'package:signin/main.dart';
import 'package:signin/services/googlesignin.dart';
import 'package:provider/provider.dart';
import 'package:signin/services/googlesignin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signin/services/Restaurants.dart';

class GoogleMaps extends StatefulWidget {

  
  var cameras;

  GoogleMaps(this.cameras);
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  String userid;



  void inputData() async {
    final User user = auth.currentUser;
    final uid = await user.getIdToken();
  }

  Future<String> httpsomething() async {
    //const id = {idToken: "EvoH2COxCYURMefC1PxMH6GOIis2"};
    final User user = auth.currentUser;
    final uid = await user.getIdToken();
    final String url = 'http://54.76.178.98:8080/service/v1/profile';
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
        'idToken': uid,
        }
        ));
    if (response.statusCode == 200) {
      print("Yes");
      return "tread";
    } else if (response.statusCode == 400) {
      print("No");
      return "tread";
    } else if (response.statusCode == 401) {
      print("Ha, wrong");
      return "tread";
    } else {
      print("I want to die");
      return "tread";
    }
  }

  Future<Object> grabLocation(long, lat) async {
    final String url = "http://54.76.178.98:8080/service/v1/restaurants";
    final User user = auth.currentUser;
    final uid = await user.getIdToken();
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          "idToken": uid,
          "command": "get",
          "point": {
            "x": -73.93414657,
            "y": 40.82302903,
          }
        }
        ));
    return response;
  }

  Future loadinformation() async {
    var jsonString = await grabLocation(3, 3);
    final jsonResponse = json.decode(jsonString);
    Location location = new Location.fromJson(jsonResponse);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final test = httpsomething();
    print(test);
  }

  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24.0),
                        bottomLeft: Radius.circular(24.0)
                    ),
                  ),
                  height: 180.0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(45.0, 35.0, 0, 0),
                      child: Text(
                        'SAMPLE MAP',
                        style: TextStyle(
                          fontSize: 40.0,
                          letterSpacing: 6.0,
                          color: Colors.white,

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.grey[200],
              ),
              width: 360,
              height: 530,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(51.048615, -114.070847), zoom: 8.0),
                markers: Set.from(myMarker),
                onTap: _handleTap,
              ),
            ),
          ),
          Center(
            child: Row(
              children: [
                FlatButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                  },
                  textColor: Colors.blue,
                  child: Text("Sign Out"),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new TakePictureScreen(camera: cameras.first)));
                    },
                    child: Text("Camera")
                )
              ],
            ),
          ),
        ],
      ),
    );

  }
  _handleTap(LatLng tappedPoint) async {
    print(tappedPoint);
    Response test = await grabLocation(3, 3);
    Map data = jsonDecode(test.body);
    print(data);
    List<dynamic> REEEE = data["restaurants"];

    List<String> oid = [];
    List<String> names = [];
    List<double> Latitude = [];
    List<double> Longitude = [];

    for (int i = 0; i < REEEE.length; i++) {
      final Map<String, dynamic> huh = Map.castFrom<String, dynamic, String, dynamic>(REEEE[i]);
      print(huh["_id"]["\$oid"] as String);
      oid.add(huh["_id"]["\$oid"] as String);
      print(oid);
      print("Latitude: ");
      print(huh["location"]["coordinates"][0] as double);
      Latitude.add(huh["location"]["coordinates"][0] as double);
      print("Longitude: ");
      print(huh["location"]["coordinates"][1] as double);
      Longitude.add(huh["location"]["coordinates"][1] as double);
      print(huh["name"] as String);
      names.add(huh["name"] as String);
    }

    setState(() {
      myMarker = [];
      for (int i = 0; i < oid.length; i++) {
        double lat = Latitude[i] + i;
        double long = Longitude[i] + i;
        tappedPoint = LatLng(lat, long);
        myMarker.add(
            Marker(
                markerId: MarkerId(tappedPoint.toString()),
                position:tappedPoint,
                infoWindow: InfoWindow(
                    title: names[i],
                    snippet: "${tappedPoint.latitude.toString()}, ${tappedPoint.longitude.toString()}"
                )
            )
        );
      }
    });
  }
}

