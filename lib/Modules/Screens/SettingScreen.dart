import 'package:chatat/Modules/Screens/editProfileScreen.dart';
import 'package:chatat/Shared/Components/components.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatState>(
      listener: (context,state){},
      builder: (context,state)
      {
        var userModel = ChatCubit.get(context).userModel!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:
            [
              Container(
                height: 240,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 190,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('${userModel.coverImage!}'),
                            fit: BoxFit.cover,

                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ),

                    ),
                    CircleAvatar(
                      radius: 74,
                      backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
                        backgroundImage: NetworkImage('${userModel.image!}'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${userModel.name!}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${userModel.bio!}',
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Row(
                  children:
                  [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children:
                          [
                            Text(
                              '100',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'post',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children:
                          [
                            Text(
                              '265',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'photos',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children:
                          [
                            Text(
                              '1.5K',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'followers',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children:
                          [
                            Text(
                              '156',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'followings',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children:
                [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: ()
                      {

                      },
                      child: Text(
                          'Add Photos',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                    onPressed: ()
                    {
                      NavigationTo(context,EditProfileScreen());
                    },
                    child: Icon(
                        IconBroken.Edit,
                        color: Colors.black,
                        size: 18,
                    )
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}