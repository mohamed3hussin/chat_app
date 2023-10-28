import 'dart:io';

import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../Shared/Components/components.dart';
import '../../Shared/Cubits/ChatatCubit/ChatatCubit.dart';

class EditProfileScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatState>(
      listener: (context,state){},
      builder: (context,state)
      {
        var userModel = ChatCubit.get(context).userModel!;
        var profileImage = ChatCubit.get(context).profileImage;
        var coverImage = ChatCubit.get(context).coverImage;

        nameController.text = userModel.name!;
        bioController.text = userModel.bio!;
        phoneController.text= userModel.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            action:
            [
              TextButton(
                onPressed: ()
                {
                  ChatCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                },
                child: Text('Update',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),),
              SizedBox(width: 15,),
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics() ,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:
                [
                  if(state is ChatUpdateUserLoadingStat)
                    LinearProgressIndicator(),

                  SizedBox(height: 10,),
                  Container(
                    height: 240,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 190,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: coverImage ==null? NetworkImage('${userModel.coverImage!}'):FileImage(coverImage) as ImageProvider ,
                                    fit: BoxFit.cover,

                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: ()
                                  {
                                    ChatCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar
                                    (
                                      radius: 20,
                                      backgroundColor: Colors.black,
                                      child: Icon(
                                          IconBroken.Camera,
                                          color: Colors.white,
                                          size: 20,
                                      )),
                              ),
                            ],
                          ),

                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 74,
                              backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
                                backgroundImage:profileImage !=null?FileImage(profileImage)as ImageProvider :NetworkImage('${userModel.image!}'),


                              ),
                            ),
                            IconButton(
                              onPressed: ()
                              {
                                ChatCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar
                                (
                                  backgroundColor:Colors.black,
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if(ChatCubit.get(context).profileImage != null || ChatCubit.get(context).coverImage != null )
                    Row(
                    children:
                    [
                      if(ChatCubit.get(context).profileImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              function: ()
                              {
                                ChatCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,);

                              },
                              text: 'upload profile',
                              radius: 4,
                              isUpperCase: false,
                            ),
                            if(state is ChatUpdateUserLoadingStat)
                              SizedBox(height: 5,),
                            if(state is ChatUpdateUserLoadingStat)
                              LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      if(ChatCubit.get(context).profileImage != null && ChatCubit.get(context).coverImage != null )
                        SizedBox(width: 5,),
                      if(ChatCubit.get(context).coverImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              function: ()
                              {
                                ChatCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,);
                              },
                              text: 'upload cover',
                              radius: 4,
                              isUpperCase: false,
                            ),
                            if(state is ChatUpdateUserLoadingStat)
                              SizedBox(height: 5,),
                            if(state is ChatUpdateUserLoadingStat)
                              LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(ChatCubit.get(context).profileImage != null || ChatCubit.get(context).coverImage != null )
                    SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      inputType: TextInputType.name,
                      labelText: 'Name',
                      preIcon: IconBroken.User,
                      validate: (String? value)
                      {
                        if(value! .isEmpty)
                        {
                          return 'Name Most Not Be Empty';
                        }
                        return null;
                      },
                      context: context),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: bioController,
                      inputType: TextInputType.text,
                      labelText: 'Bio',
                      preIcon: IconBroken.Info_Square,
                      validate: (String? value)
                      {
                        if(value! .isEmpty)
                        {
                          return 'Bio Most Not Be Empty';
                        }
                        return null;
                      },
                      context: context),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      inputType: TextInputType.phone,
                      labelText: 'Phone',
                      preIcon: IconBroken.Call,
                      validate: (String? value)
                      {
                        if(value! .isEmpty)
                        {
                          return 'Phone Most Not Be Empty';
                        }
                        return null;
                      },
                      context: context),
                ],
              ),
            ),
          ),

        );
      },
    );
  }
}
