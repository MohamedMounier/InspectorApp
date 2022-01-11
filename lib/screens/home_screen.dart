import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteee_apps/database/database_helper.dart';
import 'package:noteee_apps/models/items_model.dart';
import 'package:noteee_apps/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import 'data_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _file;
  String? imageCode;
  TextEditingController titleCtrl=TextEditingController();
  TextEditingController descCtrl=TextEditingController();

  GlobalKey<FormState> keyForm=GlobalKey<FormState>();
  NotesDataBase db=NotesDataBase();
  String openOrClosed='open';

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

    descCtrl.dispose();
    titleCtrl.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
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
              _file!=null?Container(
                  height:screenHeight*.2,
                  width:120.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green)
                  ),
                  child: Image.file(_file!,fit: BoxFit.fill,)):Center(
                    child: Container(
                        height:screenHeight*.2,
                        width:screenWidth*.5,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green)
                        ),
                    child: Text('No image selected')),
                  ),
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
                child: Text('Add to DataBase'),
                onPressed: ()async{
                  if(keyForm.currentState!.validate()&&imageCode!=null){
                  await  Provider.of<NotesProvider>(context,listen: false).addItem(ItemsModel(
                        title: titleCtrl.text,
                      date: DateTime.now().toString(),
                      description: descCtrl.text,
                      picture: imageCode,
                      status: openOrClosed
                    ));
                 // Provider.of<NotesProvider>(context,listen: false).getItems(init: false);
                 //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                    Navigator.pop(context);
                  }else if (imageCode==null||imageCode!.isEmpty){
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       backgroundColor: Colors.red,
                         content: Text('Image can\'t be empty',style: TextStyle(color: Colors.white),)));
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
