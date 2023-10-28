import 'package:chatat/Models/UserModel.dart';
import 'package:chatat/Modules/Screens/ChatScreen/ChatDetailsScreen.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Shared/Components/components.dart';
import '../../../Shared/styles/icon_broken.dart';

class ChatScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatState>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition:ChatCubit.get(context).users.length>0 ,
          builder: (context){return  ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index){return buildChatItem(context,ChatCubit.get(context).users[index]);},
              separatorBuilder: (context,index)=>myDivider(),
              itemCount: ChatCubit.get(context).users.length);},
          fallback: (context){return Center(child: CircularProgressIndicator());},
        );
      },
    ) ;
  }

  Widget buildChatItem(context,UserModel model)=>InkWell(
    onTap: ()
    {

      NavigationTo(context, ChatDetailsScreen(userModel: model));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('${model.image}'),
          ),
          SizedBox(width: 15,),
          Text('${model.name}',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                height: 1.4
            ),
          ),
          Spacer(),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('ChatatUser').doc(model.uid).snapshots(),
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
      ),
    ),
  );
}
