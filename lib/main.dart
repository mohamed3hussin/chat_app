import 'package:bloc/bloc.dart';
import 'package:chatat/Modules/Chatat_Login_Screen/LoginScreen.dart';
import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatCubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Layout/MyHomePage.dart';
import 'Shared/Components/constant.dart';
import 'Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'Shared/Cubits/observed/observe.dart';
import 'Shared/Network/Local/CacheHelper.dart';
import 'Shared/styles/themes.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print('ON Backgorung message');
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print('token '+token!);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    print('on message');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    print('on messages opend');
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  Widget? widget;
  var uid = CacheHelper.getData(key: 'uid');

  if(uid != null)
  {
    widget = MyHomePage();
  }
  else
    {
      widget = LoginScreen();
    }
  runApp(MyApp(startScreen: widget));
}

class MyApp extends StatelessWidget {

  final Widget? startScreen;
  MyApp({this.startScreen});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>ChatCubit()..getUserData()..getPosts()..getStories()),
      ],
      child: BlocConsumer<ChatCubit,ChatState>(
        listener: (context,state){},
        builder: (context,state)
        {
          return MaterialApp(

            debugShowCheckedModeBanner: false,

            theme: lightMode,
            darkTheme: darkMode,
            themeMode: ThemeMode.light,
            home: startScreen,
          );
        },
      ),
    );
  }
}


