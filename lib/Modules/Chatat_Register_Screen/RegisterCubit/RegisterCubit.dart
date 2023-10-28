
import 'package:chatat/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterStates.dart';

class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit():super(RegisterInitialState());
  static RegisterCubit get(context)=>BlocProvider.of(context);
  // ShopUserModel? model;
  void UserRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
})
   {
    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      UserCreate(
        name: name,
        email: email,
        phone: phone,
        uid: value.user!.uid,
      );

    }).catchError((error)
    {
      emit(RegisterErrorState(error.toString()));
    });
   }

   void UserCreate(
  {
    required String name,
    required String phone,
    required String email,
    required String uid,
})
   {
     UserModel model =UserModel
       (
          name: name,
          email: email,
          phone: phone,
          uid: uid,
          bio: 'write you bio...',
          image: 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg',
          coverImage: 'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
          isEmailVerified: false,
          status: '',
     );
     FirebaseFirestore.instance
         .collection('ChatatUser')
         .doc(uid)
         .set(model.toMap())
         .then((value)
          {

            emit(CreateSuccessState(uid));
          })
         .catchError((error)
          {
            emit(CreateErrorState(error.toString()));
          });
   }

  bool isPasswordShow = true;
  void PasswordShowed()
  {
    isPasswordShow=!isPasswordShow;
    emit(RegisterShowPasswordState());
  }
}