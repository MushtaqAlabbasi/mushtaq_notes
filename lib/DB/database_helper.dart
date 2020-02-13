import 'dart:async';
import 'dart:io';
import 'package:mushtaq_notes/Models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:mushtaq_notes/Utils/util.dart';

class DatabaseHelper {
  String dbPath;

  Database _db;

  Future<Database> get connectDB async {
    if (_db != null) return _db;
    // if _database is null we instantiate it
    _db = await initDB();
    return _db;
  }

  initDB() async {
//    first way to get DB directory
//    Directory directory = await getApplicationDocumentsDirectory();

//    other way to get DB directory

    String dbDirectory = await getDatabasesPath();
    dbPath = join(dbDirectory, ConsNames.DBNAME);
    var myDb = openDatabase(dbPath,
        version: ConsNames.DB_VERSION, onCreate: _onCreate);
    return myDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(""" 
                        CREATE TABLE ${ConsNames.TABLE_NAME} (
                        ${ConsNames.COLUM_ID} INTEGER PRIMARY KEY,
                        ${ConsNames.TITLE} TEXT,
                        ${ConsNames.COLUM_CONTENT} TEXT, 
                        ${ConsNames.COLUM_DATE} TEXT ,
                        ${ConsNames.IS_IMPORTANT} INTEGER )
                        
                     """);
    print('New table created at $dbPath');
  }


  Future<int> AddNewNote(NotesModel newNote) async {
    var dbClient = await connectDB;
    var result = await dbClient.insert(ConsNames.TABLE_NAME, newNote.toMap());
    print('Note added: ${newNote.title} ${newNote.content}');
    return result;
  }

//  Future<List<Map<String,dynamic>>> getAllNotes()async{
//    Database selectDB = await connectDB;
//    return selectDB.query("${ConsNames.TABLE_NAME}");
//  }


  Future<List<NotesModel>> getNotesFromDB() async {
    final dbClient = await connectDB;
    List<NotesModel> notesList = [];
//    List<Map> maps = await db.query('Notes',
//        columns: ['_id', 'title', 'content', 'date', 'isImportant']);
    List<Map> maps = await dbClient.query(ConsNames.TABLE_NAME);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    return notesList;
  }


  Future<NotesModel> getSpecificNote(int id) async {
    var dbClient = await connectDB;
    List<Map> result = await dbClient.query(ConsNames.TABLE_NAME,
        columns: [ ConsNames.TITLE, ConsNames.COLUM_CONTENT, ConsNames.IS_IMPORTANT, ConsNames.COLUM_DATE],
        where: '${ConsNames.COLUM_ID} = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return new NotesModel.fromMap(result.first);
    }

    return null;
  }


  deleteNoteInDB(NotesModel noteToDelete) async {
    var dbClient = await connectDB;
    await dbClient.delete(ConsNames.TABLE_NAME, where: '${ConsNames.COLUM_ID} = ?' , whereArgs: [noteToDelete.id]);
    print('Note deleted');
  }



//  Future<int> deleteNote(int id) async {
//    var dbClient = await connectDB;
//    return await dbClient.delete(ConsNames.TABLE_NAME, where: '${ConsNames.COLUM_ID} = ?', whereArgs: [id]);
//
//  }


  updateNoteInDB(NotesModel updatedNote) async {
    final dbClient = await connectDB;
    await dbClient.update(ConsNames.TABLE_NAME, updatedNote.toMap(),
        where: '${ConsNames.COLUM_ID} = ?', whereArgs: [updatedNote.id]);
    print('Note updated: ${updatedNote.title} ${updatedNote.content}');
  }


//  Future<int> updateNote(NotesModel notesModel) async {
//    var dbClient = await connectDB;
//    return await dbClient.update(
//        ConsNames.TABLE_NAME, notesModel.toMap(), where: "${ConsNames.COLUM_ID} = ?", whereArgs: [notesModel.id]
//    );
//  }

  Future close() async {
    var dbClient = await connectDB;
    return dbClient.close();
  }


}

//********************************************************************