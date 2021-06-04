import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Coordinates {
  final List<double> numbers;
  final String type;

  Coordinates({this.numbers, this.type});

  factory Coordinates.fromJson(Map<String, dynamic> parsedJson) {
    var numbersJson = parsedJson["coordinates"];
    List<double> numberList = numbersJson.cast<double>();

    return Coordinates(
      numbers: numberList,
      type: parsedJson["type"],
    );
  }
}

class Restaurants {
  final String id;
  final Coordinates coordinates;
  final String name;

  Restaurants({this.id, this.coordinates, this.name});

  factory Restaurants.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurants(
      id: parsedJson["_id"],
      coordinates: Coordinates.fromJson(parsedJson["coordinates"]),
      name: parsedJson["name"],
    );
  }
}

class Location {
  final String status;
  final List<Map<String, dynamic>> restaurants;

  Location({
    this.status, this.restaurants
  });

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
      status: parsedJson["status"],
      restaurants: List<Map<String, dynamic>>.from(parsedJson["restaurants"]),
    );
  }
}

class dead {
  Location location;
  
  dead({this.location});
  
  factory dead.fromJson(Map<String, dynamic> parsedJson) {
    return dead(
      location: Location.fromJson(parsedJson)
    );
  }
}

