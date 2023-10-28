class UserModel
{
  String? name;
  String? email;
  String? phone;
  String? image;
  String? coverImage;
  String? bio;
  String? uid;
  bool? isEmailVerified;
  String? status;

  UserModel(
      { this.name,
        this.email,
        this.phone,
        this.image,
        this.coverImage,
        this.bio,
        this.uid,
        this.isEmailVerified,
        this.status,
      });
  UserModel.formJson(Map<String,dynamic> json)
  {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    uid = json['uid'];
    isEmailVerified= json['isEmailVerified'];
    status = json['status'];
  }
  Map<String,dynamic> toMap()
  {
    return
      {
        'name':name,
        'email':email,
        'phone':phone,
        'image':image,
        'coverImage':coverImage,
        'bio':bio,
        'uid':uid,
        'isEmailVerified':isEmailVerified,
        'status':status,
      };
  }
}