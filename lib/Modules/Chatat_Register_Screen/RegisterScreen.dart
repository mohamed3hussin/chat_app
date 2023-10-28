
import 'package:chatat/Layout/MyHomePage.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Shared/Components/components.dart';
import '../../Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import '../../Shared/Network/Local/CacheHelper.dart';
import 'RegisterCubit/RegisterCubit.dart';
import 'RegisterCubit/RegisterStates.dart';

class RegisterScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context,state)
        {
          if(state is CreateSuccessState)
          {

            CacheHelper.saveData(key: 'uid', value: state.uid).
            then((value)
            {
              ChatCubit.get(context).getUserData();
              NavigationAndFinish(context, MyHomePage());
            });
          }
        },
        builder: (context,state){
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children:
                      [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 50.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Register now to communication with friends',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        defaultFormField(
                          context: context,
                          controller: nameController,
                          labelText: 'name',
                          preIcon: IconBroken.User,
                          inputType: TextInputType.name,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {

                              return 'Name Most Not Empty';
                            }
                            else{
                              return null;}
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          context: context,
                          controller: phoneController,
                          labelText: 'phone',
                          preIcon: IconBroken.Call,
                          inputType: TextInputType.phone,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {

                              return 'Phone Most Not Empty';
                            }
                            else{
                              return null;}
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          context: context,
                          controller: emailController,
                          labelText: 'email',
                          preIcon: Icons.email,
                          inputType: TextInputType.emailAddress,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {

                              return 'Email Most Not Empty';
                            }
                            else{
                              return null;}
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          context: context,
                          controller: passwordController,
                          inputType: TextInputType.visiblePassword,
                          labelText: 'password',
                          preIcon: Icons.lock,
                          sufIcon: cubit.isPasswordShow? Icons.visibility:Icons.visibility_off,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {

                              return 'Password Most Not Empty';
                            }
                            else{
                              return null;}
                          },
                          suffixOnPressed: ()
                          {
                            cubit.PasswordShowed();
                          },
                          onSubmitted: (value)
                          {
                            if(formKey.currentState!.validate())
                            {
                              cubit.UserRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          isPassword: cubit.isPasswordShow,

                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder:(context)=>defaultButton(
                            text: 'Register',
                            function: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                cubit.UserRegister
                                  ( name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            radius: 10.0,
                            isUpperCase: false,
                            height: 50,
                          ),
                          fallback:(context)=>Center(child: CircularProgressIndicator()) ,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
