import 'package:flutter/material.dart';
import 'package:mushtaq_notes/DB/database_helper.dart';
import 'package:mushtaq_notes/Models/note_model.dart';
import 'package:mushtaq_notes/Screens/editingScreen.dart';
import 'package:mushtaq_notes/Utils/util.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//---------------------------------------------

class _HomeScreenState extends State<HomeScreen> {

//  bool isFlagOn = false;

  DatabaseHelper dbh = DatabaseHelper();

  Future<List<NotesModel>> getFromDB() {
    return dbh.getNotesFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.flag),
            onPressed: () {

            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getFromDB(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Loding",
              ),
            );
          } else {
            if (snapshot.data.length < 1) {
              return Center(
                child: Text('No Notes, Create New one'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(snapshot.data[i].id.toString()),
                        ),
                        title: Text(snapshot.data[i].title),
                        subtitle: Text(snapshot.data[i].content +
                            "  " +
                            snapshot.data[i].date.toString().substring(0, 10)),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => EditingScreen(
                                  existingNote: snapshot.data[i]));
                          Navigator.push(context, route);
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          tooltip: 'delete Note',
                          onPressed: () {
                            dbh.deleteNoteInDB(snapshot.data[i]);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                );
//                Divider(color: Theme.of(context).accentColor)
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(Icons.add),
        tooltip: 'Add new Note',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => EditingScreen()));
        },
      ),
    );
  }

//  void handleShare() {
//  }

}
