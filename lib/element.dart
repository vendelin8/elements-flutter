import 'package:flutter/material.dart';

class Element extends StatelessWidget {
  final String name;
  const Element(this.name, {super.key});

  @override
  Widget build(BuildContext context) => Expanded(
      flex: 1, child: Image(image: AssetImage('images/$name.png'), repeat: ImageRepeat.repeat));
}

final compareDate = DateTime.utc(2016, DateTime.february, 26);
const wood = Element('wood');
const fire = Element('fire');
const earth = Element('earth');
const metal = Element('metal');
const water = Element('water');
final allElements = [wood, fire, earth, metal, water];

Widget getElementJing(int day) {
  switch (day % 12) {
    case 0:
    case 1:
      return wood;
    case 4:
    case 5:
      return fire;
    case 2:
    case 3:
    case 8:
    case 11:
      return earth;
    case 6:
    case 7:
      return metal;
    case 9:
    case 10:
    default:
      return water;
  }
}

Widget getElementQi(int day) {
  switch (((day % 30) / 2).floor()) {
    case 2:
    case 6:
    case 10:
      return wood;
    case 5:
    case 9:
    case 13:
      return fire;
    case 0:
    case 4:
    case 11:
      return earth;
    case 1:
    case 8:
    case 12:
      return metal;
    case 3:
    case 7:
    case 14:
    default:
      return water;
  }
}

Widget getElementShen(int day) => allElements[(((day % 10) / 2) + 2).floor() % 5];

int getDay(DateTime date) => date.difference(compareDate).inDays;
