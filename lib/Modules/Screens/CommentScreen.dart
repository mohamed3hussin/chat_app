import 'package:chatat/Models/CommentsModel.dart';
import 'package:chatat/Models/PostModel.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Shared/Components/components.dart';

class CommentScreen extends StatelessWidget {
  var textController = TextEditingController();
  final String postId;

   CommentScreen({super.key, required this.postId});
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ChatCubit.get(context).getComments(postId);
        return BlocConsumer<ChatCubit,ChatState>(
          listener: (context,state){},
          builder: (context,state)
          {
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'comments',

              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children:
                  [
                    ConditionalBuilder(
                      condition: ChatCubit.get(context).comments.length >0,
                      builder: (context)=>Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context,index)=>buildCommentItem(ChatCubit.get(context).comments[index],context),
                                  separatorBuilder: (context,index)=>SizedBox(height: 10,),
                                  itemCount: ChatCubit.get(context).comments.length),
                            ],
                          ),
                        ),
                      ),
                      fallback: (context)=> Expanded(child: Center(child: CircularProgressIndicator())),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'write a comment...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            ),
                            onFieldSubmitted: (value)
                            {
                              String now = DateFormat("MMM, EEE, yyyy").format(DateTime.now());
                              ChatCubit.get(context).CreateComment(
                                  dateTime: now,
                                  text: value.toString(),
                                  context: context,
                                  postId: postId,
                              );
                              textController.text='';
                            },
                          ),
                        ),
                        TextButton(onPressed: ()
                        {
                          String now = DateFormat("MMM, EEE, yyyy").format(DateTime.now());
                          ChatCubit.get(context).CreateComment(
                            dateTime: now,
                            text: textController.text,
                            context: context,
                            postId: postId,
                          );
                          textController.text='';
                        },
                            child: Text('POST',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget buildCommentItem(CommentsModel model,context)=>Column(
    children: [
      Row(

        children:
        [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('${model.image}'),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Row(
                    children: [
                      Text('${model.name}',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            height: 1.4,
                            fontSize: 16,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(width: 7,),
                      Text(
                        '${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(height: 1.3,fontSize: 13,color: Colors.black26),
                      ),
                    ],
                  ),
                  SizedBox(height: 7,),
                  Row(

                    children: [
                      Expanded(
                        child: Text(
                          '${model.text}',
                          style: Theme.of(context).textTheme.caption!.copyWith(height: 1.3,fontSize: 15,color: Colors.black87),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 28,
                            child: IconButton(
                                onPressed: ()
                                {

                                },
                                icon: Icon(
                                  Icons.favorite_border_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ) ),
                          ),
                          Text('1',style: TextStyle(fontSize: 11,color: Colors.grey),),

                        ],
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      myDivider(),
    ],
  );

}

