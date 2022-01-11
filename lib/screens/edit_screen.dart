import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteee_apps/database/database_helper.dart';
import 'package:noteee_apps/models/items_model.dart';
import 'package:noteee_apps/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import 'data_screen.dart';

class EditScreen extends StatefulWidget {


  @override
  _EditScreenState createState() => _EditScreenState();

  EditScreen(this.model);
  ItemsModel model;
}

class _EditScreenState extends State<EditScreen> {
  File? _file;
  String? imageCode;
  TextEditingController titleCtrl=TextEditingController();
  TextEditingController descCtrl=TextEditingController();

  GlobalKey<FormState> keyForm=GlobalKey<FormState>();
  NotesDataBase db=NotesDataBase();
  String? openOrClosed;

  Future pickUpImage()async{
    final myFile= await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _file=File(myFile!.path);
      imageCode=base64Encode(_file!.readAsBytesSync());
    });
    print('file is $_file');
    String base64=base64Encode(_file!.readAsBytesSync());
    print('base 64 name is ${base64}');
    String imageName= _file!.path.split('/').last;
    print('image name is $imageName');
  }
  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }
  @override
  void initState() {
    openOrClosed=widget.model.status;
    titleCtrl.text=widget.model.title!;
    descCtrl.text=widget.model.description!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Orientation orientation=MediaQuery.of(context).orientation;
    double screenHeight=orientation==Orientation.portrait?MediaQuery.of(context).size.height:MediaQuery.of(context).size.width;
    double screenWidth=orientation==Orientation.portrait?MediaQuery.of(context).size.width:MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(),));
          }, icon: Icon(Icons.forward))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: keyForm,
          child: ListView(
            children: [
              ElevatedButton(onPressed: pickUpImage,
                  child: Text('Pick up image')),
              SizedBox(height: 30,),
              Container(
                  height:screenHeight*.2,
                  width:120.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green)
                  ),
                  child: Image.memory(base64Decode('${widget.model.picture}'),fit: BoxFit.cover,)),
              SizedBox(height: 30,),
              TextFormField(
                validator: (val){
                  if(val!.length<1){
                    return 'This Field can\'t be empty !';
                  }else if(val.length>30){
                    return 'title can\'t be more than 30 letters';
                  }else{}
                },
                textInputAction: TextInputAction.next,
                controller: titleCtrl,
                decoration: InputDecoration(
                    hintText: 'Title'
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                validator: (val){
                  if(val!.length<1||val.isEmpty){
                    return 'This Field can\'t be empty !';
                  }
                },
                textInputAction: TextInputAction.done,

                controller: descCtrl,
                decoration: InputDecoration(
                    hintText: 'Description'
                ),
              ),
              SizedBox(height: 15,),

              // TextFormField(
              //   controller: statusCtrl,
              //   decoration: InputDecoration(
              //       hintText: 'Title'
              //   ),
              // ),
              const SizedBox(height: 30.0,),
              Row(
                children: [
                  Text('Status :',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 20.0,),
                  ChoiceChip(
                      label: Text('open'),
                      selected:openOrClosed=='open'? true:false,
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                          color: openOrClosed=='open'?Colors.white:Colors.black.withOpacity(.4)
                      ),
                      onSelected: (val){
                        if(val==true){
                          setState(() {
                            openOrClosed='open';
                          });
                        }
                      }
                  ),
                  const SizedBox(width: 10.0,),
                  ChoiceChip(
                    label: Text('closed'),
                    selected: openOrClosed=='closed'? true:false,
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                        color: openOrClosed=='closed'?Colors.white:Colors.black.withOpacity(.4)
                    ),
                    onSelected: (val){
                      if(val==true){
                        setState(() {
                          openOrClosed='closed';
                        });
                      }
                    },

                  )
                ],
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                child: Text('Edit'),
                onPressed: ()async{
                  if(keyForm.currentState!.validate()){
                    await  Provider.of<NotesProvider>(context,listen: false).editItem(model: ItemsModel(
                      id: widget.model.id,
                        title: titleCtrl.text,
                        date: DateTime.now().toString(),
                        description: descCtrl.text,
                        picture: imageCode==null?widget.model.picture:imageCode,
                        status: openOrClosed
                    ),
                        statusNew: openOrClosed
                    );

                    print('new status ');

                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edited Successfully !')));
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                  }
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
