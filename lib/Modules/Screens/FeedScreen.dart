import 'package:chatat/Models/StoryModel.dart';
import 'package:chatat/Modules/Screens/CommentScreen.dart';
import 'package:chatat/Modules/Screens/story/addStory.dart';
import 'package:chatat/Modules/Screens/story/story.dart';
import 'package:chatat/Modules/Screens/storyScreen.dart';
import 'package:chatat/Shared/Components/components.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Models/PostModel.dart';
import '../../Models/UserModel.dart';
import 'PostScreen.dart';

class FeedScreen extends StatefulWidget {


  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('online');
  }
  void setStatus(String status)async
  {
    await FirebaseFirestore.instance.collection('ChatatUser').doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status':status});
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed)
    {
      setStatus('online');
    }
    else
      {
        setStatus('offline');
      }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatState>(
      listener: (context,state)
      {
        if (state is SocialStoryImagePickedSuccessState) {
          NavigationTo(context, AddStory());
        }
      },
      builder: (context,state)
      {
       // ChatCubit.get(context).getPosts();
        return ConditionalBuilder(
         condition: ChatCubit.get(context).posts.length > 0 && ChatCubit.get(context).userModel != null,
         builder: (context)=>SingleChildScrollView(
           physics: BouncingScrollPhysics(),
           child: Column(

             children:
             [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     width: 50,
                     child: InkWell(
                       onTap: () {
                         ChatCubit.get(context).getStoryImage();
                       },
                       child: Container(
                         width: 50,
                         height: 50,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Stack(
                               alignment: AlignmentDirectional.bottomCenter,
                               children: [
                                 CircleAvatar(
                                   radius: 25,
                                   backgroundImage: NetworkImage(
                                       ChatCubit.get(context)
                                           .userModel!
                                           .image!),
                                 ),
                                 Transform.translate(
                                   offset: Offset(0, 10),
                                   child: CircleAvatar(
                                     backgroundColor: Colors.blue[800],
                                     child: Icon(
                                       Icons.add,
                                       color: Colors.white,
                                       size: 15,
                                     ),
                                     radius: 10,
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                   Expanded(
                     child: Container(
                       height: 70,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 10),
                         child: ListView.separated(
                           scrollDirection: Axis.horizontal,
                           itemBuilder: (context, index) => buildstoryitem(
                             context,
                             ChatCubit.get(context).sotriesedited[index],
                           ),
                           itemCount:
                           ChatCubit.get(context).sotriesedited.length,
                           separatorBuilder: (context, index) => SizedBox(
                             width: 20,
                           ),
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 5,),
               ListView.separated(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (context,index)=>buildPostItem(ChatCubit.get(context).posts[index],context,index,state),
                 separatorBuilder: (context,index)=>SizedBox(height: 5,),
                 itemCount: ChatCubit.get(context).posts.length,),
               SizedBox(height: 4,),
             ],
           ),
         ),
         fallback: (context)=>Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(PostModel model,context,index,ChatState state)=>Card(
    margin: EdgeInsets.symmetric(horizontal: 8),
    elevation: 5.0,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Row(
            children:
            [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('${model.profilePicture}'),
              ),
              SizedBox(width: 15,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Row(
                      children: [
                        Text('${model.name}',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              height: 1.4
                          ),
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                    ),
                    Text('${model.date}',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          height: 1.4
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15,),
              IconButton(
                  onPressed: (){},
                  icon: Icon(
                    IconBroken.More_Circle,
                    size: 20,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Text(
            '${model.postText}',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.3,fontSize: 13),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       children:
          //       [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end: 5),
          //           child: Container(
          //             child: MaterialButton(
          //               onPressed: (){},
          //               height: 25,
          //               minWidth: 1,
          //               padding: EdgeInsets.zero,
          //               child: Text('#software_development',style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.blue),),
          //             ),
          //             height: 25,
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end: 5),
          //           child: Container(
          //             child: MaterialButton(
          //               onPressed: (){},
          //               height: 25,
          //               minWidth: 1,
          //               padding: EdgeInsets.zero,
          //               child: Text('#flutter_development',style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.blue),),
          //             ),
          //             height: 25,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if(model.postImage != '')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: NetworkImage('${model.postImage}'),
                    fit: BoxFit.fitHeight,

                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children:
              [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children:
                      [
                        Icon(
                          Icons.favorite_border_outlined,
                          size: 18,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5,),
                        if(model.likes !=  0)
                          Text(
                          '${model.likes}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                        [
                          Icon(
                            IconBroken.Chat,
                            size: 18,
                            color: Colors.black,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            '${model.comments}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: ()
                    {
                      print(DateFormat.jm().format(DateTime.now())) ;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children:
            [
              Expanded(
                child: InkWell(
                  child: Row(
                    children:
                    [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('${ChatCubit.get(context).userModel!.image}'),
                      ),
                      SizedBox(width: 10,),
                      Text('write a comment...',
                        style: Theme.of(context).textTheme.caption!.copyWith(

                        ),
                      ),
                    ],
                  ),
                  onTap: ()
                  {
                    ChatCubit.get(context).getComments(model.postId!);
                    NavigationTo(context, CommentScreen(postId: model.postId!,));
                  },
                ),
              ),
              InkWell(
                child: Container(
                  width: 70,
                  height: 35,
                  child: Row(
                    children:
                    [

                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('posts')
                                  .doc(model.postId!).collection('likes').doc(FirebaseAuth.instance.currentUser!.uid)
                                      .snapshots(),
                        builder: (context,snapshot)
                        {
                          if(!snapshot.hasData)
                          {
                            return Icon(
                              Icons.favorite_border ,
                              size: 25,
                              color: Colors.black,
                            );
                          }
                          if(snapshot.data!.exists)
                          {
                            return Icon(
                              Icons.favorite ,
                              size: 25,
                              color: Colors.black,
                            );
                          }
                          else
                            {
                              return Icon(
                                Icons.favorite_border ,
                                size: 25,
                                color: Colors.black,
                              );
                            }
                        },
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                onTap: ()
                async {
                  UserModel? postUser = ChatCubit.get(context).userModel;
                  await ChatCubit.get(context).likedByMe(
                      postUser: postUser,
                      context: context,
                      postModel: model,
                      postId: model.postId
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
  Widget buildStoryItem(int index)=>InkWell(
    onTap: ()
    {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => storyScreen()));
    },
    child: Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.black,
            ),
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('${ChatCubit.get(context).userModel!.image}'),
            ),
          ],
        ),
        if(index ==0)
          InkWell(
            onTap: ()
            {
              NavigationTo(context, PostScreen());
            },
            child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
        ),
          ),
        if(index ==0)
          InkWell(
            onTap: ()
            {
              NavigationTo(context, PostScreen());
            },
            child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.black,
            child: Icon(Icons.add,color: Colors.white,),
        ),
          ),
      ],
    ),
  );
  Widget buildstoryitem(context, StoryModel model) => Container(
    width: 40,
    child: InkWell(
      onTap: () {
        NavigationTo(
            context,
            Story(
              id: model.uId,
            ));
        print(model.uId);
      },
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(model.storyimage!),
              ),
              CircleAvatar(
                radius: 6.0,
                backgroundColor: Colors.white,
              ),
              CircleAvatar(
                radius: 5.0,
                backgroundColor: Colors.green,
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            model.name!,
            maxLines: 2,
            style: TextStyle(
              height: 1,
              fontSize: 8,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}