import 'package:flutter/material.dart';
import 'package:mushtaq_notes/Screens/homeScreen.dart';




void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomeScreen(),
));


//void main() {
//  runApp(MaterialApp(
//    theme: ThemeData.light(),
//    title: "Notes App",
//    home: NotesList(),
//  ));
//}
//
//class NotesList extends StatefulWidget {
//  @override
//  _NotesListState createState() => _NotesListState();
//}
//
//class _NotesListState extends State<NotesList> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(),
//    );
//  }
//}