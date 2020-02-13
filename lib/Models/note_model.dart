import 'dart:math';

import 'package:mushtaq_notes/Utils/util.dart';

class NotesModel {
  int id;
  String title;
  String content;
  bool isImportant;
  DateTime date;

//  _id , title  content  date  isImportant

  NotesModel({this.id, this.title, this.content, this.isImportant, this.date});

  //to bring from Db --data wil be return as a map so we pass it a map as parameter
  NotesModel.fromMap(Map<String, dynamic> map) {
    this.id = map['${ConsNames.COLUM_ID}'];
    this.title = map['${ConsNames.TITLE}'];
    this.content = map['${ConsNames.COLUM_CONTENT}'];
    this.date = DateTime.parse(map['${ConsNames.COLUM_DATE}']);
    this.isImportant = map['${ConsNames.IS_IMPORTANT}'] == 1 ? true : false;
  }



  //to store into Db
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if (id != null) {
      map['${ConsNames.COLUM_ID}'] = id;
    }
    if (title == null) {
      map['${ConsNames.TITLE}'] = 'Untitled Note';
    } else map['${ConsNames.TITLE}'] = title;

    map['${ConsNames.COLUM_CONTENT}'] = content;
    map['${ConsNames.IS_IMPORTANT}'] = this.isImportant == true ? 1 : 0;
    map[ConsNames.COLUM_DATE] = this.date.toIso8601String();
//    this._date.toIso8601String()

    return map;
  }

//  NotesModel.random() {
//  this.id = Random(10).nextInt(1000) + 1;
//  this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
//  this.content = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
//  this.isImportant = Random().nextBool();
//  this.date = DateTime.now().add(Duration(hours: Random().nextInt(100)));
//  }

}
