import 'package:chatat/Layout/MyHomePage.dart';
import 'package:chatat/Modules/Chatat_Login_Screen/LoginCubit/LoginCubit.dart';
import 'package:chatat/Modules/Chatat_Login_Screen/LoginCubit/LoginStates.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../Shared/Components/components.dart';
import '../../Shared/Network/Local/CacheHelper.dart';
import '../Chatat_Register_Screen/RegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> LoginCubit() ,
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state)
        {
          if(state is LoginErrorState)
          {
            makeToast('${state.error}');
          }
          else if(state is LoginSuccessState)
          {
            CacheHelper.saveData(key: 'uid', value: state.uid).
            then((value)
            {
              ChatCubit.get(context).getUserData();
              NavigationAndFinish(context, MyHomePage());
            });

          }
        },
        builder: (context,state)
        {
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
                        Container(
                            height: 200,
                            child: Image(
                                image: AssetImage('assets/images/chat.png'))),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'LOGIN',
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
                          'Login now to communication with friends',
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
                          controller: emailController,
                          labelText: 'email',
                          preIcon: Icons.email,
                          inputType: TextInputType.emailAddress,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {

                              return 'Email most not empty';
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
                          sufIcon: LoginCubit.get(context).isPasswordShow? Icons.visibility:Icons.visibility_off,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {

                              return 'Password most not empty';
                            }
                            else{
                              return null;}
                          },
                          suffixOnPressed: ()
                          {
                            LoginCubit.get(context).PasswordShowed();
                          },
                          onSubmitted: (value)
                          {
                            if(formKey.currentState!.validate())
                            {
                              LoginCubit.get(context).UserLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          isPassword: LoginCubit.get(context).isPasswordShow,

                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder:(context)=>defaultButton(
                            text: 'login',
                            function: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                LoginCubit.get(context).UserLogin(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text('Don\'t have account?'),
                            TextButton(
                              onPressed: ()
                              {
                                NavigationTo(context, RegisterScreen());
                              },
                              child: Text(
                                'Register Now',
                              ),
                            ),
                          ],
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
