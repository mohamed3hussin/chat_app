import 'package:chatat/Shared/Cubits/ChatatCubit/ChatatState.dart';
import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Shared/Cubits/ChatatCubit/ChatatCubit.dart';


class AddStory extends StatelessWidget {
  const AddStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is SocialCreateStorySuccessState)
        {
          Navigator.pop(context);
        }

      },
      builder: (context, state) {
        var model = ChatCubit.get(context).userModel;
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                if(state is SocialCreateStoryLoadingState)
                  LinearProgressIndicator(),
                if (ChatCubit.get(context).storyImage != null)
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            ChatCubit.get(context).storyImage!,
                          ),
                        )),
                  ),
                if ((ChatCubit.get(context).storyImage == null))
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                if (ChatCubit.get(context).storyImage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20,right: 20),
                    child: IconButton(onPressed: () {
                      ChatCubit.get(context).uploadStorylImage(name: model!.name!, uId: model.uid!, datetime: DateTime.now().toString(), image: model.image!);


                    }, icon: Icon(IconBroken.Arrow___Right,color: Colors.blue,size: 40,)),
                  ),
                if(state is SocialuploadingLoadingState)
                  Transform.translate(offset: Offset(0, -700),
                      child: LinearProgressIndicator(minHeight: 8,)),
              ],
            ),
          ),
        );
      },
    );
  }
}