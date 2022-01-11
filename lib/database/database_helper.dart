import 'package:noteee_apps/models/items_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDataBase{
  static final NotesDataBase instance=NotesDataBase._init();
  NotesDataBase._init();
  static Database? _database;
  factory NotesDataBase()=>instance;

Future<Database?> createDataBase()async{
  if(_database!=null)
  {return _database;}
  String path=join(await getDatabasesPath(),'items.db');
  _database=await openDatabase(path,version: 1,onCreate:onCreateDb );
  return _database;
}
onCreateDb(Database db,int v){
  db.execute('create table items(id integer primary key autoincrement, title varchar(50), picture varchar(255), description varchar(255), date varchar(50), status varchar(50))');
}

  Future<int> addItemDb(ItemsModel itemsModel)async{
  Database? database=await createDataBase();
  return database!.insert('items',itemsModel.toMap());
}
  Future<List<ItemsModel>> getItemsDb()async{
  List<ItemsModel> itemsList=[];
    Database? database=await createDataBase();
    var fullList=await database!.query('items');
    fullList.forEach((element) {
      itemsList.add(ItemsModel.fromMap(element));
    });
  return itemsList;
   // fullList.add( ItemsModel.fromMap());

  }
  Future<int> editItemDb(ItemsModel model)async{
  Database? database=await createDataBase();
  return await _database!.update('items', model.toMap(),where:'id = ?',whereArgs: [model.id]);
  }
  Future<int> deleteItemDB(int id)async{
    Database? database=await createDataBase();
    return _database!.delete('items',where: 'id = ?',whereArgs: [id]);
  }
}