class ItemsModel{
  int? id;
  String? title;
  String? picture;
  String? description;
  String? date;
  String? status;


  ItemsModel(
      {this.id,
      this.title,
      this.picture,
      this.description,
      this.date,
      this.status});

  ItemsModel.fromMap(Map<String,dynamic>db){
    id=db['id'];
    title=db['title'];
    picture=db['picture'];
    description=db['description'];
    date=db['date'];
    status=db['status'];
  }

  Map<String,dynamic> toMap()=>{
 'id':id,'title':title,'picture':picture,'description':description,
   'date':date,'status':status
  };

}