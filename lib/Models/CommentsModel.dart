class CommentsModel
{
  String? name;
  String? image;
  String? uid;
  String? dateTime;
  String? text;
  String? postId;

  CommentsModel(
      { this.name,
        this.image,
        this.uid,
        this.dateTime,
        this.text,
        this.postId,
      });
  CommentsModel.formJson(Map<String,dynamic> json)
  {
    name = json['name'];
    image = json['image'];
    uid = json['uid'];
    dateTime = json['dateTime'];
    text = json['text'];
    postId = json['postId'];
  }
  Map<String,dynamic> toMap()
  {
    return
      {
        'name':name,
        'image':image,
        'uid':uid,
        'dateTime':dateTime,
        'text':text,
        'postId':postId,
      };
  }
}