import 'dart:io';


import 'package:chatat/Models/MessageModel.dart';
import 'package:chatat/Models/PostModel.dart';
import 'package:chatat/Models/UserModel.dart';
import 'package:chatat/Modules/Screens/ChatScreen/ChatScreen.dart';
import 'package:chatat/Modules/Screens/FeedScreen.dart';
import 'package:chatat/Modules/Screens/PostScreen.dart';
import 'package:chatat/Modules/Screens/SettingScreen.dart';
import 'package:chatat/Modules/Screens/UsersScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Models/CommentsModel.dart';
import '../../../Models/LikeModel.dart';
import '../../../Models/StoryModel.dart';
import '../../Network/Local/CacheHelper.dart';
import 'ChatatState.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatCubit extends Cubit<ChatState>{
  
  ChatCubit():super(ChatInitialStat());
  
  static ChatCubit get(context)=>BlocProvider.of(context);
  
  UserModel? userModel;
  //======================GetUserData=====================================
  void getUserData()
  {
    emit(ChatGetUserLoadingStat());
    var uid = CacheHelper.getData(key: 'uid');
    FirebaseFirestore.instance
        .collection('ChatatUser')
        .doc(uid)
        .get()
        .then((value)
          {
            print(value.data());
            userModel = UserModel.formJson(value.data()!);

            emit(ChatGetUserSuccessStat());
          })
        .catchError((error)
          {
            print(error.toString());
            emit(ChatGetUserErrorStat(error.toString()));
          });
  }

  int currentIndex= 0;
  List<Widget>screens =
  [
    FeedScreen(),
    ChatScreen(),
    PostScreen(),
    UsersScreen(),
    SettingScreen(),
  ];
//======================ChangeBottomNav=====================================
  void ChangeBottomNav(int index)
  {
    if(index==0)
      {
        //getPosts();

      }

    if(index==1)
      getUsers();
    if(index==2)
      emit(ChatPostStat());

    else
      {
        currentIndex = index;
        emit(ChatChangeBottomNavStat());
      }

  }

  File? profileImage;
  var picker = ImagePicker();
//======================GetProfileImage=====================================
  Future<void> getProfileImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      emit(ChatProfileImagePickedSuccessState());
    }
    else
    {
      print('NO image selected');
      emit(ChatProfileImagePickedErrorState());
    }
  }

  File? coverImage;
//======================GetCoverImage=====================================
  Future<void> getCoverImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(ChatCoverImagePickedSuccessState());
    }
    else
    {
      print('NO image selected');
      emit(ChatCoverImagePickedErrorState());
    }
  }


//======================UploadProfileImage=====================================
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(ChatUpdateUserLoadingStat());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        //emit(ChatUploadProfileImageSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio,image: value);
        updateImageProfileInPostsAndComments(value.toString());
        profileImage = null;
      })
          .catchError((error)
      {
        emit(ChatUploadProfileImageErrorState(error));
      });
    })
        .catchError((error)
    {

      emit(ChatUploadProfileImageErrorState(error));
    });
  }


//======================UploadCoverImage=====================================
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(ChatUpdateUserLoadingStat());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        //emit(ChatUploadCoverImageSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio,coverImage: value);

        coverImage = null;
      })
          .catchError((error)
      {
        emit(ChatUploadCoverImageErrorState());
      });
    })
        .catchError((error)
    {
      emit(ChatUploadCoverImageErrorState());
    });
  }

//======================updateUser=====================================
  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String ? image,
    String ? coverImage,
  })
  {

    UserModel model =UserModel
      (
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      image: image?? userModel!.image,
      coverImage: coverImage?? userModel!.coverImage,
      uid: userModel!.uid,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('ChatatUser')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value)
    {
      getUserData();

    })
        .catchError((error)
    {
      emit(ChatUpdateUserErrorStat(error));
    });
  }

  File? postImage;
//======================getPostImage=====================================
  Future<void> getPostImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(ChatPostImagePickedSuccessState());
    }
    else
    {
      print('NO image selected');
      emit(ChatPostImagePickedErrorState());
    }
  }
//======================uploadPostImage=====================================
  void uploadPostImage(
  {
    required BuildContext context,
    required String date,
    required String time,
    required String postText,

})
  {
      emit(ChatCreatePostLoadingStat());
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!)
          .then((value)
      {
        value.ref.getDownloadURL()
            .then((value)
        {
          //emit(ChatUploadCoverImageSuccessState());
          print(value);
          CreatePost(
              date: date,
              time:  time,
              postText: postText,
              postImage: value,
              context : context,
          );


        })
            .catchError((error)
        {
          emit(ChatCreatePostErrorState());
        });
      })
          .catchError((error)
      {
        emit(ChatCreatePostErrorState());
      });

  }
//======================CreatePost=====================================
  void CreatePost({
    required String date,
    required String time,
    required String postText,
    required BuildContext context,
    String? postImage,
  })
  {
    emit(ChatCreatePostLoadingStat());
    PostModel model =PostModel
      (
      name:  userModel!.name,
      profilePicture: userModel!.image,
      uId:   userModel!.uid,
      date:date,
      postText: postText,
      postImage: postImage??'',
      time: time,

    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(ChatCreatePostSuccessState());
      getPosts();
      if(postImage != null)
        removePostImage();


    })
        .catchError((error)
    {
      emit(ChatCreatePostErrorState());
    });
  }
//======================removePostImage=====================================
  void removePostImage()
  {
    postImage = null;
    emit(ChatRemovePostImageState());
  }
//======================getPosts=====================================
  List<PostModel> posts = [];
  //Map<String,bool> isLike = {};
  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots()
        .listen((event) async {
      posts = [];
      //isLike = {};
      event.docs.forEach((element) async{
        posts.add(PostModel.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('posts').doc(element.id)
            .update({
          'likes' : likes.docs.length,
          'comments' : comments.docs.length,
          'postId' : element.id,
        });
      });
      emit(GetPostSuccessState());
    });
  }
//======================updateImageProfileInPostsAndComments=====================================
  void updateImageProfileInPostsAndComments(String image)
  {
    FirebaseFirestore.instance.collection('posts')
        .where('uid', isEqualTo: userModel!.uid)
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference.update(
            {
              'image': image
            }).then((value)
        {
          element.reference.collection('comments').where('uid',isEqualTo: userModel!.uid)
          .get()
          .then((value)
          {
            value.docs.forEach((element)
            {
              element.reference.update(
                  {
                    'image': image
                  }
              ).then((value) {}).catchError((error){});
            });
          })
          .catchError((error){});
          emit(ChatUpdateProfileImageInPostsSuccessState());
        }).catchError((error){});
      });

    })
        .catchError((error){ChatUpdateProfileImageInPostsErrorState();});

  }
  //======================likePosts=====================================

  Future<bool> likedByMe ({
    context,
    String? postId,
    PostModel? postModel,
    UserModel? postUser
  }) async{
    emit(LikedByMeCheckedLoadingState());

    bool isLikedByMe = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((event) async {
      var likes = await event.reference.collection('likes').get();
      likes.docs.forEach((element) {
        if(element.id == userModel!.uid) {
          isLikedByMe = true;
          disLikePost(postId);
        }
      });
      if(isLikedByMe == false)
        likePost(
            postId : postId,
            context: context,
            postModel: postModel,
            postUser: postUser
        );
      print(isLikedByMe);

      emit(LikedByMeCheckedSuccessState());
    });

    return isLikedByMe;
  }

  void disLikePost(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .delete()
        .then((value) {
      getPosts();
      emit(DisLikePostSuccessState());
    }).catchError((error) {
      emit(DisLikePostErrorState());
      print(error.toString());
    });
  }
  void likePost({
    context,
    String? postId,
    PostModel? postModel,
    UserModel? postUser
  }) {
    LikesModel likesModel = LikesModel(
        uId: userModel!.uid,
        name: userModel!.name,
        profilePicture: userModel!.image,
        dateTime: FieldValue.serverTimestamp(),
        state: true
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .set(likesModel.toMap())
        .then((value) {
      getPosts();
      // if(postModel!.uid != userModel!.uid) {
      //   ChatCubit.get(context).sendInAppNotification(
      //       receiverName: postModel.name,
      //       receiverId: postModel.uId,
      //       contentId: postModel.postId,
      //       contentKey: 'likePost'
      //   );
      //   SocialCubit.get(context).sendFCMNotification(
      //     token: postUser!.token,
      //     senderName: SocialCubit.get(context).model!.name,
      //     messageText: '${SocialCubit.get(context).model!.name}' + ' likes a post you shared',
      //   );
      // }
      emit(LikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LikePostErrorState());
    });
  }
  List<LikesModel> peopleReacted = [];

  void getLikes(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .listen((value) {
      peopleReacted = [];
      value.docs.forEach((element) {
        peopleReacted.add(LikesModel.fromJson(element.data()));
      });
      emit(GetLikesSuccessState());
    });
  }

  //======================getComments=====================================
  List<CommentsModel> comments = [];
  void getComments(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
        comments.add(CommentsModel.formJson(element.data()));
        getPosts();

      });
      emit(ChatGetCommentSuccessStat());
    });
  }
  //============================LikeInToComment===========================

  //======================CreateComment=====================================
  void CreateComment({
    required String dateTime,
    required String text,
    required BuildContext context,
    required String postId
  })
  {
    emit(ChatCreateCommentLoadingStat());
    CommentsModel model =CommentsModel
      (
      name:  userModel!.name,
      image: userModel!.image,
      uid:   userModel!.uid,
      dateTime:dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value)
    {
      getComments(postId);
      emit(ChatCreateCommentSuccessStat());

    })
        .catchError((error)
    {
      emit(ChatCreateCommentErrorStat(error));
    });
  }

  List<UserModel> users =[];
  //======================getUsers=====================================
  void getUsers()
  {
     users =[];
     FirebaseFirestore.instance
         .collection('ChatatUser')
         .get()
         .then((value)
     {
       value.docs.forEach((element)
       {
         if(element.data()['uid'] != userModel!.uid)
            users.add(UserModel.formJson(element.data()));

       });
       emit(ChatGetAllUserSuccessStat());
     })
        .catchError((error)
     {
       emit(ChatGetAllUserErrorStat(error.toString()));
     });
  }

  File? chatImage;

  Future<void> getChatImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      chatImage = File(pickedFile.path);
      emit(ChatImagePickedSuccessState());
    }
    else
    {
      print('NO image selected');
      emit(ChatImagePickedErrorState());
    }
  }
  void removeChatImage()
  {
    chatImage = null;
    emit(ChatRemoveChatImageState());
  }

  void uploadChatImage(
      {
        required String dateTime,
        required String receiverId,
        required String text,

      })
  {
    emit(ChatSendMessageLoadingStat());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/${Uri.file(chatImage!.path).pathSegments.last}')
        .putFile(chatImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        //emit(ChatUploadCoverImageSuccessState());
        print(value);
        SendMessage(receiverId: receiverId, dateTime: dateTime, text: text, chatImage: value);
        removeChatImage();

      })
          .catchError((error)
      {
        emit(ChatSendMessageErrorState());
      });
    })
        .catchError((error)
    {
      emit(ChatSendMessageErrorState());
    });

  }

  void SendMessage(
  {
    required String receiverId,
    required String dateTime,
    required String text,
    String? chatImage,
})
  {
    MessageModel messageModel = MessageModel(
      text: text,
      senderId: userModel!.uid,
      receiverId: receiverId,
      dateTime: dateTime,
      chatImage: chatImage??'',
    );
    // set my chats
    FirebaseFirestore.instance
        .collection('ChatatUser')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value)
        {
          emit(ChatSendMessageSuccessState());
        })
        .catchError((error)
        {
          emit(ChatSendMessageErrorState());
        });
    // set receiver chats
    FirebaseFirestore.instance
        .collection('ChatatUser')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uid)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value)
    {
      emit(ChatSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(ChatSendMessageErrorState());
    });
  }
  
  List<MessageModel> messages = [];
  void getMessages(
  {
  required String receiverId,
})
  {
    FirebaseFirestore.instance
        .collection('ChatatUser')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages = [];
      event.docs.forEach((element)
      {
        messages.add(MessageModel.formJson(element.data()));
      });
      emit(ChatGetMessagesSuccessState());
    });
  }

  File? storyImage;
  bool storyimageSelected = false;
  Future<void> getStoryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      storyImage = File(pickedFile.path);

      print(' the Storyimage path is  $storyImage');
      emit(SocialStoryImagePickedSuccessState());
      storyimageSelected = true;
    } else {
      print('No image selected.');
      emit(SocialStoryImagePickedErrorState());
    }
  }
  void uploadStorylImage({
    required String name,
    required String uId,
    required String datetime,
    required String image,
  }) {
    emit(SocialuploadingLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('stories/${Uri.file(storyImage!.path).pathSegments.last}')
        .putFile(storyImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialStoryImageUploadSuccessState());
        createStory(
          name: name,
          uId: uId,
          image: image,
          datetime: datetime,
          storyimage: value,
        );

        storyimageSelected = false;
      }).catchError((error) {
        emit(SocialStoryImageUploadErrorState());
      });
    }).catchError((error) {
      emit(SocialStoryImageUploadErrorState());
    });
  }
  void createStory({
    required String datetime,
    required String name,
    required String storyimage,
    required String image,
    required String uId,
  }) {
    emit(SocialCreateStoryLoadingState());
    StoryModel model = StoryModel(
      name: userModel!.name,
      uId: userModel!.uid,
      image: userModel!.image,
      datetime: datetime,
      storyimage: storyimage,
    );
    FirebaseFirestore.instance
        .collection('stories')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreateStorySuccessState());
    }).catchError((error) {
      emit(SocialCreateStoryErrorState());
    });
  }
  List<StoryModel> stories = [];
  List<StoryModel> storiesPerPerson = [];
  List<StoryModel> sotriesedited = [];
  void getStoriesperperson(String id) {
    storiesPerPerson = [];
    emit(SocialGetStoriesperpersonLoadingState());
    FirebaseFirestore.instance.collection('stories').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == id) {
          storiesPerPerson.add(StoryModel.fromJson(element.data()));
        }

        emit(SocialGetStoriesperpersonSuccessState());
      });
    }).catchError((e) {
      emit(SocialGetStoriesperpersonErrorState());
      print(e.toString());
    });
  }

  void sumstoriesOfSamePerson() {
    sotriesedited = [];
    stories.forEach((element) {
      if (sotriesedited.every((e) => e.uId != element.uId)) {
        sotriesedited.add(element);
      }
    });
  }

  Future<void> checkstorytimefordelete() async {
    FirebaseFirestore.instance.collection('stories').get().then((value) {
      var now = Timestamp.now().toDate();

      value.docs.forEach((element) {
        Timestamp storydate = element.data()['time'];
        var diffrece = now.difference(storydate.toDate());
        if (diffrece.inMinutes >= 1440) element.reference.delete();
      });
    }).catchError(onError);
  }

  void getStories() {
    stories = [];
    emit(SocialGetStoriesLoadingState());
    FirebaseFirestore.instance.collection('stories').get().then((value) {
      value.docs.forEach((element) {
        stories.add(StoryModel.fromJson(element.data()));
        print(element);
        emit(SocialGetStoriesSuccessState());
      });
    }).then((_) {
      sumstoriesOfSamePerson();
    }).catchError((e) {
      emit(SocialGetStoriesErrorState());
      print(e.toString());
    });
  }
}