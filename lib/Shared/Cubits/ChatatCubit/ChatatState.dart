abstract class ChatState {}

class ChatInitialStat extends ChatState{}

class ChatGetUserSuccessStat extends ChatState{}
class ChatGetUserErrorStat extends ChatState
{
  final String error;

  ChatGetUserErrorStat(this.error);
}
class ChatGetUserLoadingStat extends ChatState{}

class ChatChangeBottomNavStat extends ChatState{}
class ChatPostStat extends ChatState{}

class ChatProfileImagePickedSuccessState extends ChatState{}
class ChatProfileImagePickedErrorState extends ChatState{}

class ChatCoverImagePickedSuccessState extends ChatState{}
class ChatCoverImagePickedErrorState extends ChatState{}

class ChatUploadProfileImageSuccessState extends ChatState{}
class ChatUploadProfileImageErrorState extends ChatState
{
  final String error;

  ChatUploadProfileImageErrorState(this.error);
}

class ChatUploadCoverImageSuccessState extends ChatState{}
class ChatUploadCoverImageErrorState extends ChatState{}

class ChatUpdateUserLoadingStat extends ChatState{}
class ChatUpdateUserErrorStat extends ChatState
{
  final String error;

  ChatUpdateUserErrorStat(this.error);


}

class ChatCreatePostLoadingStat extends ChatState{}
class ChatCreatePostSuccessState extends ChatState{}
class ChatCreatePostErrorState extends ChatState{}

class ChatPostImagePickedSuccessState extends ChatState{}
class ChatPostImagePickedErrorState extends ChatState{}

class ChatRemovePostImageState extends ChatState{}

class ChatCreateCommentSuccessStat extends ChatState{}
class ChatCreateCommentErrorStat extends ChatState
{
  final String error;

  ChatCreateCommentErrorStat(this.error);
}
class ChatCreateCommentLoadingStat extends ChatState{}

class ChatGetCommentSuccessStat extends ChatState{}
class ChatGetCommentErrorStat extends ChatState
{
  final String error;

  ChatGetCommentErrorStat(this.error);
}
class ChatGetCommentLoadingStat extends ChatState{}


class ChatUpdateProfileImageInPostsSuccessState extends ChatState{}
class ChatUpdateProfileImageInPostsErrorState extends ChatState{}

class ChatGetAllUserSuccessStat extends ChatState{}
class ChatGetAllUserErrorStat extends ChatState
{
  final String error;

  ChatGetAllUserErrorStat(this.error);
}
class ChatGetAllUserLoadingStat extends ChatState{}


class LikedByMeCheckedLoadingState extends ChatState{}
class LikedByMeCheckedSuccessState extends ChatState{}

class DisLikePostSuccessState extends ChatState{}
class DisLikePostErrorState extends ChatState{}

class LikePostSuccessState extends ChatState{}
class LikePostErrorState extends ChatState{}
class GetLikesSuccessState extends ChatState{}

class GetPostSuccessState extends ChatState{}

class ChatSendMessageSuccessState extends ChatState{}
class ChatSendMessageErrorState extends ChatState{}

class ChatGetMessagesSuccessState extends ChatState{}
class ChatGetMessagesErrorState extends ChatState{}

class ChatImagePickedSuccessState extends ChatState{}
class ChatImagePickedErrorState extends ChatState{}
class ChatRemoveChatImageState extends ChatState{}
class ChatSendMessageLoadingStat extends ChatState{}

// void signOut(context) {
//   emit(SignOutLoadingState());
//   FirebaseAuth.instance.signOut().then((value) async {
//     CacheHelper.removeData('uId');
//     await FirebaseMessaging.instance.deleteToken();
//     await FirebaseFirestore.instance.collection('users').get().then((value) {
//       value.docs.forEach((element) async {
//         if (element.id == model!.uID)
//           element.reference.update({'token': null});
//       });
//     });
//     navigateAndKill(context, LoginScreen());
//     emit(SignOutSuccessState());
//   }).catchError((error) {
//     print(error.toString());
//     emit(SignOutErrorState());
//   });
// }

//story stats
class SocialStoryImagePickedSuccessState extends ChatState{}
class SocialStoryImagePickedErrorState extends ChatState{}
class SocialCreateStoryLoadingState extends ChatState{}
class SocialCreateStorySuccessState extends ChatState{}
class SocialCreateStoryErrorState extends ChatState{}
class SocialuploadingLoadingState extends ChatState{}
class SocialStoryImageUploadSuccessState extends ChatState{}
class SocialStoryImageUploadErrorState extends ChatState{}
class SocialGetStoriesperpersonLoadingState extends ChatState{}
class SocialGetStoriesperpersonSuccessState extends ChatState{}
class SocialGetStoriesperpersonErrorState extends ChatState{}
class SocialGetStoriesLoadingState extends ChatState{}
class SocialGetStoriesSuccessState extends ChatState{}
class SocialGetStoriesErrorState extends ChatState{}
