import 'package:flutter/material.dart';
import 'package:mushtaq_notes/DB/database_helper.dart';
import 'package:mushtaq_notes/Models/note_model.dart';
import 'package:mushtaq_notes/Screens/homeScreen.dart';
import 'package:share/share.dart';

class EditingScreen extends StatefulWidget {
  final NotesModel existingNote;

  EditingScreen({this.existingNote});

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  bool isChanged = false;
  bool isNoteNew = true;

  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel currentNote;
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote == null) {
      currentNote = NotesModel(
          content: '', title: '', date: DateTime.now(), isImportant: false);
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    _titleController.text = currentNote.title;
    _contentController.text = currentNote.content;
    _dateController.text = currentNote.date.toString().substring(1, 10);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Note Edit')),
      body: Container( 
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            TextField(
                controller: _titleController,
                focusNode: titleFocus,
                autofocus: true,
                onChanged: (value) {
                  titleValueIsChange(value);
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(contentFocus);
                },
                decoration: InputDecoration(
                  //labelText: 'Title',
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                )),

            Padding(padding: new EdgeInsets.all(5.0)),

            //--------------------------------end of title------------

            TextField(
              controller: _contentController,
              focusNode: contentFocus,
              onChanged: (value) {
                contentValueIsChange(value);
              },
//              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                //labelText: 'Title',
                hintText: 'Start Typing',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
                border: InputBorder.none,
              ),
            ),

            Padding(padding: new EdgeInsets.all(5.0)),
            //-------------end of content-------------

            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'date'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),

            //-------------end of date-------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    tooltip: 'Mark note as important',
                    icon: Icon(currentNote.isImportant
                        ? Icons.flag
                        : Icons.outlined_flag),
                    onPressed: () {
                      currentNote.isImportant = !currentNote.isImportant;
                      saveData();
                    },
                  ),
                ),
                RaisedButton(
                  child: (widget.existingNote != null)
                      ? Text('Update')
                      : Text('Add'),
                  color: Colors.blueAccent,
                  onPressed: () {
                    saveData();
                    Route route = MaterialPageRoute(
                        builder: (context) => HomeScreen());
                    Navigator.push(context, route);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),

                ),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    tooltip: 'share note',
                    icon: Icon(Icons.share),
                    onPressed: () {
                      handleShare();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveData() async {
    setState(() {
      currentNote.title = _titleController.text;
      currentNote.content = _contentController.text;
      print('${currentNote.content}');
    });
    if (isNoteNew) {
      await db.AddNewNote(currentNote);
    } else {
      await db.updateNoteInDB(currentNote);
    }
    setState(() {
      isNoteNew = false;
      isChanged = false;
    });
  }

  void titleValueIsChange(String title) {
    setState(() {
      isChanged = true;
    });
  }

  void contentValueIsChange(String content) {
    setState(() {
      isChanged = true;
    });
  }

  void handleShare() {
    Share.share(
        '${currentNote.title.trim()}\n\n(On: ${currentNote.date
            .toIso8601String().substring(0, 10)})\n\n${currentNote.content}');
  }
}
