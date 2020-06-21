import 'package:flutter/material.dart';

class Carta {
  int id;
  int group;
  bool visible;
  Color color;
  String image;

  Carta({this.id, this.group, this.visible = false, this.color, this.image});
}
