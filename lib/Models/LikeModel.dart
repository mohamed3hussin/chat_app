import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel
{
  String?uId;
  String? name;
  String? profilePicture;
  FieldValue? dateTime;
  bool? state;


  LikesModel({
    this.uId,
    this.name,
    this.profilePicture,
    this.dateTime,
    this.state,
  });

  LikesModel.fromJson(Map<String, dynamic>? json){
    uId = json!['uId'];
    name = json['name'];
    profilePicture = json['profilePicture'];
    state = json['state'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId' : uId,
      'name':name,
      'profilePicture':profilePicture,
      'dateTime':dateTime,
      'state':state,

    };
  }
}