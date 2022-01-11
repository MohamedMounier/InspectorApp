import 'package:flutter/material.dart';
import 'package:noteee_apps/database/database_helper.dart';
import 'package:noteee_apps/models/items_model.dart';
import 'package:sqflite/sqflite.dart';

class NotesProvider extends ChangeNotifier{
  NotesDataBase db=NotesDataBase();
  List<ItemsModel>? items;
  Set<ItemsModel> openCases={};
  Set<ItemsModel> closedCases={};
  getItems({required bool init})async{
   await db.getItemsDb().then((value) => items=value);
   init==true?openAndClosed():null;
    notifyListeners();
  }
  addItem(ItemsModel itemsModel)async{

   await db.addItemDb(itemsModel).then((value) {
     items!.add(itemsModel);
     itemsModel.status=='open'?openCases.add(itemsModel):closedCases.add(itemsModel);
   } );


    notifyListeners();
  }
  editItem({required ItemsModel model,required String? statusNew})async{

    await db.editItemDb(model).then((value) {
      items!.add(model);
      openCases.clear();
      closedCases.clear();



    } );


    notifyListeners();
  }

  deleteItem(int? id){
    items!.where((element) => id==element.id).single.status=='open'?openCases.remove(items!.where((element) => id==element.id).single):
    closedCases.remove(items!.where((element) => id==element.id).single);
    db.deleteItemDB(id!);
    items!.removeWhere((element) => id==element.id);

   // openAndClosed();
    notifyListeners();
  }

  openAndClosed(){
    items!.forEach((element) {
      if(element.status=='open'){
        openCases.add(element);
      }else{
        closedCases.add(element);
      }
    });
    notifyListeners();
  }

}