import 'package:chatat/Modules/Screens/PostScreen.dart';
import 'package:chatat/Shared/Components/components.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatState>(
      listener: (context,state)
      {
        if(state is ChatPostStat)
        {
          NavigationTo(context, PostScreen());
        }
      },
      builder: (context,state)
      {
        var cubit = ChatCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('ChaTaT'),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(IconBroken.Notification),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(IconBroken.Search),
              ),
              // IconButton(
              //   onPressed: ()
              //   {
              //     cubit.signOut();
              //   },
              //   icon: Icon(IconBroken.Logout),
              // ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.ChangeBottomNav(index);
            },
            items:
            [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat),
                  label: 'Chat'
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Upload),
                  label: 'Post'
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Location),
                  label: 'Users'
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting),
                  label: 'Setting'
              ),

            ],
          ),
        );
      },
    );
  }
}
