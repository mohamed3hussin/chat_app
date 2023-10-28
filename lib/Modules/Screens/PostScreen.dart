import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Shared/Components/components.dart';





class PostScreen extends StatelessWidget {

  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatState>(
      listener: (context,state){},
      builder: (context,state)
      {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            action:
            [
              TextButton(
                onPressed: ()
                {
                  String now = DateFormat("MMM, EEE, yyyy").format(DateTime.now());
                  if(ChatCubit.get(context).postImage ==null)
                  {
                    ChatCubit.get(context).CreatePost(
                        context: context,
                        date: now.toString(),
                        time: DateTime.now().millisecondsSinceEpoch.toString(),
                        postText: textController.text);
                    textController.text='';
                  }
                  else
                    {
                      ChatCubit.get(context).uploadPostImage(
                          context: context,
                          date: now.toString(),
                          time: DateTime.now().millisecondsSinceEpoch.toString(),
                          postText: textController.text);
                      textController.text='';
                    }
                },
                child: Text('POST',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children:
              [
                if(state is ChatCreatePostLoadingStat)
                  LinearProgressIndicator(),
                if(state is ChatCreatePostLoadingStat)
                  SizedBox(
                    height: 5,
                  ),

                Row(
                  children:
                  [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('${ChatCubit.get(context).userModel!.image}'),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Text('${ChatCubit.get(context).userModel!.name}',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            height: 1.4
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'what is on your mind...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if(ChatCubit.get(context).postImage !=null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 190,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(ChatCubit.get(context).postImage!) as ImageProvider ,
                            //fit: BoxFit.cover,

                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      IconButton(
                        onPressed: ()
                        {
                          ChatCubit.get(context).removePostImage();
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  children:
                  [
                    Expanded(
                      child: TextButton(
                          onPressed: ()
                          {
                            ChatCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              Icon(IconBroken.Image,color: Colors.black,),
                              SizedBox(width: 5,),
                              Text('add photo',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: (){},
                        child: Text('# tags',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        );
      },
    );
  }
}
