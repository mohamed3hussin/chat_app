

import 'package:chatat/Models/MessageModel.dart';
import 'package:chatat/Models/UserModel.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Shared/Cubits/ChatatCubit/ChatatState.dart';

class ChatDetailsScreen extends StatelessWidget {

  UserModel userModel;
  ChatDetailsScreen({super.key, required this.userModel});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(

      builder: (BuildContext context)
      {
        ChatCubit.get(context).getMessages(receiverId: userModel.uid!);
        return BlocConsumer<ChatCubit,ChatState>(
          listener: (context,state){},
          builder: (context,state)
          {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children:
                  [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel.image}'),

                    ),
                    SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${userModel.name}'),
                        SizedBox(height: 5,),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('ChatatUser').doc(userModel.uid).snapshots(),
                          builder: (context,snapshot)
                          {
                            if(snapshot.data != null)
                            {
                              return Text(snapshot.data!['status'],style: TextStyle(color: Colors.grey,fontSize: 12));
                            }
                            else
                            {
                              return Container();
                            }
                          },

                        ),
                      ],
                    )
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: ChatCubit.get(context).messages.length > 0 ,
                builder: (context)=>Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                            itemBuilder: (context,index)
                            {
                              var message = ChatCubit.get(context).messages[index];
                              if(ChatCubit.get(context).userModel!.uid == message.senderId)
                                return buildMessageByMe(message,context);

                              return buildMessageByReceiver(message,context);
                            },
                            separatorBuilder: (context,index)=>SizedBox(height: 7,),
                            itemCount: ChatCubit.get(context).messages.length),
                      ),
                      if(ChatCubit.get(context).chatImage !=null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: 220,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(ChatCubit.get(context).chatImage!) as ImageProvider ,
                                  fit: BoxFit.fill,

                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            IconButton(
                              onPressed: ()
                              {
                                ChatCubit.get(context).removeChatImage();
                              },
                              icon: CircleAvatar
                                (
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    IconBroken.Close_Square,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                      if(ChatCubit.get(context).chatImage !=null)
                        SizedBox(height: 5,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,

                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(start: 7),
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'send your message her...',
                                  ),
                                ),
                              ),
                            ),
                            IconButton(onPressed: ()
                            {
                              ChatCubit.get(context).getChatImage();
                            },
                                icon: Icon(Icons.image)),
                            Container(
                              height: 50,
                              color: Colors.black,
                              child: MaterialButton(
                                onPressed: ()
                                {
                                  if(ChatCubit.get(context).chatImage == null)
                                    {
                                      ChatCubit.get(context).SendMessage(
                                        receiverId: userModel.uid!,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                      );
                                      messageController.text='';
                                    }
                                  else
                                    {
                                      ChatCubit.get(context).uploadChatImage(
                                          dateTime: DateTime.now().toString(),
                                          receiverId: userModel.uid!,
                                          text: messageController.text,
                                      );
                                      messageController.text='';
                                    }

                                },
                                minWidth: 1,
                                child: Icon(
                                  IconBroken.Send,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context)=> Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(child: Center(child: CircularProgressIndicator())),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,

                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(start: 7),
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'send your message her...',
                                  ),
                                ),
                              ),
                            ),
                            IconButton(onPressed: ()
                            {
                              ChatCubit.get(context).getChatImage();
                            },
                                icon: Icon(Icons.image)),
                            Container(
                              height: 50,
                              color: Colors.black,
                              child: MaterialButton(
                                onPressed: ()
                                {
                                  ChatCubit.get(context).SendMessage(
                                    receiverId: userModel.uid!,
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text,
                                  );
                                  messageController.text='';
                                },
                                minWidth: 1,
                                child: Icon(
                                  IconBroken.Send,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              ),
            );
          },
        );
      },

    );
  }
  Widget buildMessageByMe(MessageModel messageModel,context)=>Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
        ),
      ),

      padding:EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 2,
      ) ,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(messageModel.chatImage != '')
            InkWell(
              onTap: ()
              {
                showDialog(context: context,
                    builder: (context)
                    {
                      return Dialog(
                        child: Image(image: NetworkImage(messageModel.chatImage!),),
                      );
                    });
              },
              child: Container(
                  width: 220,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(
                    image: NetworkImage(messageModel.chatImage!),
                    fit: BoxFit.fill,
                  )),
            ),
          SizedBox(height: 4,),
          if(messageModel.text != '')
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('${messageModel.text}',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    ),
  );
 Widget buildMessageByReceiver(MessageModel messageModel,context)=>Align(
   alignment: AlignmentDirectional.centerStart,
   child: Container(
     decoration: BoxDecoration(
       color: Colors.grey[300],
       borderRadius: BorderRadiusDirectional.only(
         bottomEnd: Radius.circular(10),
         topEnd: Radius.circular(10),
         topStart: Radius.circular(10),
       ),
     ),
     padding:EdgeInsets.symmetric(
       vertical: 2,
       horizontal: 2,
     ) ,
     child:
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         if(messageModel.chatImage != '')
           InkWell(
             onTap: ()
             {
               showDialog(context: context,
                   builder: (context)
                   {
                     return Dialog(
                       child: Image(image: NetworkImage(messageModel.chatImage!),),
                     );
                   });
             },
             child: Container(
                 width: 220,
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
                 clipBehavior: Clip.antiAliasWithSaveLayer,
                 child: Image(
                   image: NetworkImage(messageModel.chatImage!),
                   fit: BoxFit.fill,
                 )),
           ),
         SizedBox(height: 4,),
         if(messageModel.text != '')
           Padding(
             padding: const EdgeInsets.all(5.0),
             child: Text('${messageModel.text}',
             ),
           ),
       ],
     ),
   ),
 );
}
