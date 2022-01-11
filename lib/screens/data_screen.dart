import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteee_apps/database/database_helper.dart';
import 'package:noteee_apps/models/items_model.dart';
import 'package:noteee_apps/provider/notes_provider.dart';
import 'package:noteee_apps/screens/edit_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {

  NotesDataBase db=NotesDataBase();
  List open=[];
  List closed=[];

  @override
  // void didChangeDependencies() {
  //   Provider.of<NotesProvider>(context,listen: false).getItems(init: false);
  //   super.didChangeDependencies();
  // }
  @override
  void initState() {
    Provider.of<NotesProvider>(context,listen: false).getItems(init: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Orientation orientation=MediaQuery.of(context).orientation;
    double screenHeight=orientation==Orientation.portrait?MediaQuery.of(context).size.height:MediaQuery.of(context).size.width;
    double screenWidth=orientation==Orientation.portrait?MediaQuery.of(context).size.width:MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Data Screen',style: TextStyle(color: Colors.green),),

      actions: [
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context) =>  HomePage()));
        }, icon: Icon(Icons.add,color: Colors.green,))
      ],
      ),

      body: ConditionalBuilder(
          condition: Provider.of<NotesProvider>(context).items!=null,
          builder: (context) {
            List<ItemsModel>? itemsList=Provider.of<NotesProvider>(context).items;

            return orientation==Orientation.portrait?Column(
              children: [
                // Dashoard Item
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                  child: Container(
                    width:screenWidth*.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.greenAccent
                            ]
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text('Total Items',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('${itemsList!=null?itemsList.length:0}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 30,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.done,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  children: [
                                    Text('Closed Cases',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('${Provider.of<NotesProvider>(context).closedCases.length}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  children: [
                                    Text('Open Cases',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('${Provider.of<NotesProvider>(context).openCases.length}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('All Items',
                    style: TextStyle(fontSize: 25,color: Colors.black.withOpacity(.8),fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                itemsList!.isNotEmpty?Expanded(
                  child: Container(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 15.0,),
                      itemCount: itemsList.length,
                      itemBuilder: (context, index) {
                        ItemsModel model=itemsList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shadowColor: Colors.green,
                            child: Row(
                              children: [
                                Container(
                                  height:screenHeight*.2,
                                  width:screenWidth*.35,
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green)
                                  ),
                                    child: Image.memory(base64Decode('${model.picture}'),fit: BoxFit.cover,)),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('ID : ${model.id}',
                                          style:  TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 20
                                          ),
                                          ),
                                          SizedBox(height: 20.0,),
                                          Container(
                                            padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                                            margin:const EdgeInsets.symmetric(horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                color: model.status=='open'?Colors.red:Colors.green,
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Text(' ${model.status}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18
                                              ),
                                              )),
                                        ],
                                      ),
                                      Text('title is ${model.title}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      ),
                                      Text('description is ${model.description}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text('date is ${model.date}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          ElevatedButton(child: Text('View'),
                                              onPressed: (){
                                            showDialog(
                                             context: context, builder:(context) => alertDialog(screenHeight, screenWidth, model, context),
                                            );
                                              }
                                          ),
                                          Spacer(),
                                          IconButton(onPressed: (){
                                            showDialog(context: context, builder:(context) => AlertDialog(
                                              content:Text('Are you sure to delete ${model.title} ?'),
                                              actions: [
                                                ElevatedButton(onPressed: (){
                                                  Provider.of<NotesProvider>(context,listen: false).deleteItem(model.id);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted Successfully')));
                                                }, child: Text('Yes')),
                                                ElevatedButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, child: Text('No'))
                                              ]
                                              ,));
                                          }, icon: Icon(Icons.delete,color:Colors.red)),
                                          IconButton(onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>EditScreen(model) ,));
                                          }, icon: Icon(Icons.edit,color: Colors.green,)),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ):Expanded(child: Center(child: Text('No items yet !'),),),
              ],
            ):ListView(
              shrinkWrap: true,
              children: [
                // Dashoard Item
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                  child: Container(
                    width:screenWidth*.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.greenAccent
                            ]
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text('Total Items',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('${itemsList!=null?itemsList.length:0}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 30,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.done,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  children: [
                                    Text('Closed Cases',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('${Provider.of<NotesProvider>(context).closedCases.length}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  children: [
                                    Text('Open Cases',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('${Provider.of<NotesProvider>(context).openCases.length}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('All Items',
                      style: TextStyle(fontSize: 25,color: Colors.black.withOpacity(.8),fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                itemsList!.isNotEmpty?Expanded(
                  child: Container(
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(height: 15.0,),
                      itemCount: itemsList.length,
                      itemBuilder: (context, index) {
                        ItemsModel model=itemsList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shadowColor: Colors.green,
                            child: Row(
                              children: [
                                Container(
                                    height:screenHeight*.2,
                                    width:screenWidth*.35,
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green)
                                    ),
                                    child: Image.memory(base64Decode('${model.picture}'),fit: BoxFit.cover,)),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('ID : ${model.id}',
                                            style:  TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20
                                            ),
                                          ),
                                          SizedBox(height: 20.0,),
                                          Container(
                                              padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                                              margin:const EdgeInsets.symmetric(horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                  color: model.status=='open'?Colors.red:Colors.green,
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Text(' ${model.status}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18
                                                ),
                                              )),
                                        ],
                                      ),
                                      Text('title is ${model.title}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text('description is ${model.description}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text('date is ${model.date}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          ElevatedButton(child: Text('View'),
                                              onPressed: (){
                                                showDialog(
                                                  context: context, builder:(context) => alertDialog(screenHeight, screenWidth, model, context),
                                                );
                                              }
                                          ),
                                          Spacer(),
                                          IconButton(onPressed: (){
                                            showDialog(context: context, builder:(context) => AlertDialog(
                                              content:Text('Are you sure to delete ${model.title} ?'),
                                              actions: [
                                                ElevatedButton(onPressed: (){
                                                  Provider.of<NotesProvider>(context,listen: false).deleteItem(model.id);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted Successfully')));
                                                }, child: Text('Yes')),
                                                ElevatedButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, child: Text('No'))
                                              ]
                                              ,));
                                          }, icon: Icon(Icons.delete,color:Colors.red)),
                                          IconButton(onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>EditScreen(model) ,));
                                          }, icon: Icon(Icons.edit,color: Colors.green,)),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ):Expanded(child: Center(child: Text('No items yet !'),),),
              ],
            );;

          },
          fallback: (context) {
            return Center(child: CircularProgressIndicator(),);
          }
   )
    );
  }
  AlertDialog alertDialog(screenHeight,screenWidth,model,ctx){
    return AlertDialog(
      content: Container(
        height: screenHeight,
        width: screenWidth,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                height:screenHeight*.2,
                width:screenWidth*.35,
                margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green)
                ),
                child: Image.memory(base64Decode('${model.picture}'),fit: BoxFit.cover,)),
            SizedBox(height:20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ID : ${model.id}',
                  style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                    padding:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                    margin:const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: model.status=='open'?Colors.red:Colors.green,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(' ${model.status}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18
                      ),
                    )),
              ],
            ),
            SizedBox(height:20.0),
            Text('title is ${model.title}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height:20.0),
            Text('description is ${model.description}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height:20.0),
            Text('date is ${model.date}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],

        ),
      ),
      actions: [
        ElevatedButton(
          child: Text('Back',style:TextStyle(color:Colors.white)),
          onPressed:(){
            Navigator.pop(ctx);
          }
        )
      ],
    );
  }
}
/*
 FutureBuilder(
        future: Provider.of<NotesProvider>(context).getItems(),
          builder: (context, snapshot) {

          List<ItemsModel>? itemsList=Provider.of<NotesProvider>(context).items;
          print('items are ${itemsList}');
            if(itemsList==null){
              return Center(child: CircularProgressIndicator(),);
            }else if(itemsList.isNotEmpty){
              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.green,
                                Colors.greenAccent
                              ]
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Text('Total Balance',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('22222',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.arrow_upward_outlined,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Text('Total Income',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('23333',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.arrow_downward_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Text('Total Expanses',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('5}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: itemsList.length,
                          itemBuilder: (context, index) {
                         ItemsModel model=itemsList[index];
                          return Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                    child: Image.memory(base64Decode('${model.picture}'),fit: BoxFit.cover,)),
                                SizedBox(width: 20,),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text('ID is ${model.id}'),
                                      Text('title is ${model.title}'),
                                      Text('description is ${model.description}'),
                                      Text('date is ${model.date}'),
                                      Text('status is ${model.status}'),
                                      ElevatedButton(child: Text('Delete'),
                                        onPressed: (){
                                        showDialog(context: context, builder:(context) => AlertDialog(
                                          content:Text('Are you sure to delete ${model.title} ?'),
                                          actions: [
                                            ElevatedButton(onPressed: (){
                                              Provider.of<NotesProvider>(context,listen: false).deleteItem(model.id);
                                              Navigator.pop(context);
                                            }, child: Text('Yes')),
                                            ElevatedButton(onPressed: (){
                                             Navigator.pop(context);
                                            }, child: Text('No'))
                                          ]
                                          ,));
                                        }
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                          },
                      ),
                    ),
                  ),
                ],
              );
            }else if(snapshot.hasError){
              return Center(child: Text('${snapshot.error}'),);
            }else if(itemsList.isEmpty){
              return Center(child: Text('No items yet !'),);

            }else{
              return  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.green,
                                Colors.greenAccent
                              ]
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Text('Total Balance',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('22222',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.arrow_upward_outlined,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Text('Total Income',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('23333',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.arrow_downward_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Text('Total Expanses',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('5}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(child: Text('else'),),
                ],
              );
            }
          },
      ),
 */