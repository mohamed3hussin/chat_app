class MessageModel
{
  String? text;
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? chatImage;




  MessageModel(
      { this.text,
        this.senderId,
        this.receiverId,
        this.dateTime,
        this.chatImage,

      });
  MessageModel.formJson(Map<String,dynamic> json)
  {
    text = json['text'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    chatImage = json['chatImage'];

  }
  Map<String,dynamic> toMap()
  {
    return
      {
        'text':text,
        'senderId':senderId,
        'receiverId':receiverId,
        'dateTime':dateTime,
        'chatImage':chatImage,

      };
  }
}