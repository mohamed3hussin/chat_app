

import 'package:chatat/Shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double   width = double.infinity,
  double   height = 40.0,
  double   radius = 0.0,
  Color    background = Colors.blue ,
  bool     isUpperCase = true,
  required Function() function ,
  required String text,
}
)=>Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radius,),
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text( isUpperCase? text.toUpperCase():text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);
//------------------------------------------------------------------------------
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required String labelText,
  required IconData preIcon,
   IconData? sufIcon,
  Function? onSubmitted,
  Function? onChang,
  Function? onTap,
  Function? suffixOnPressed,
  required Function validate,
  bool isPassword = false,
  bool isClickable = true,
  bool isRead = false,
  required context,


})=>TextFormField(

  controller: controller,
  keyboardType: inputType ,
  obscureText: isPassword,
  enabled: isClickable,
  readOnly: isRead,
  onFieldSubmitted: (s){
    onSubmitted!(s);
  },
  onChanged: (s){
    onChang!(s);
  },
  validator:(s){
    return validate(s);
  },
  onTap: ()
  {
    onTap!();
  },
  decoration: InputDecoration(
    labelText: labelText,
    border: OutlineInputBorder(),

    prefixIcon: Icon(
      preIcon,
    ),
    suffixIcon: IconButton(
      onPressed:(){
        suffixOnPressed!();
      } ,
      icon: Icon(
        sufIcon,
      ),
    ),
  ),
);
//------------------------------------------------------------------------------
Widget buildTaskItem(Map model,context,
    {Color doneColor = Colors.black45,Color archiveColor = Colors.black45})=>
    Dismissible(
  key: Key(model['id'].toString()),
  child: Container(

    padding: EdgeInsets.all(20),

    child: Row(

      children:

      [

        CircleAvatar(
          backgroundColor: Colors.black54,
          radius: 40.0,
          child: Text(
              model['time'],
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),

        SizedBox(width: 20.0,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children:

            [

              Text(

                model['title'],

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                model['date'],

                style: TextStyle(

                    color: Colors.grey

                ),

              ),

            ],

          ),

        ),

        SizedBox(width: 20.0,),

        IconButton(
            onPressed:()
            {
            },

            icon: Icon(Icons.done_all),

            color:doneColor ,

        ),

        IconButton(

          onPressed:()

          {
          },

          icon: Icon(Icons.archive_outlined),

            color:archiveColor,

        ),



      ],

    ),

  ),
  onDismissed: (direction)
  {
  },
);
//------------------------------------------------------------------------------
Widget buildNewsItem(Map model,context)=>InkWell(
  onTap: (){

  },
  child:Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children:

      [

        Container(

          width: 120,

          height: 120,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(15,),

            image: DecorationImage(

              image: NetworkImage('${model['urlToImage']!=null?model['urlToImage']:'https://i.pinimg.com/originals/7c/1c/a4/7c1ca448be31c489fb66214ea3ae6deb.jpg'}'),

              fit: BoxFit.cover,

            ),

          ),),

        SizedBox(width: 20,),

        Expanded(

          child: Container(

            height: 120,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children:

              [

                Expanded(

                  child: Text(

                    '${model['title']}',

                    style: Theme.of(context).textTheme.bodyText1,

                    overflow: TextOverflow.ellipsis,

                    maxLines: 3,

                  ),

                ),

                Text(

                  '${model['publishedAt']}',

                  style: TextStyle(

                    color: Colors.grey,

                    fontWeight: FontWeight.w600,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),

  ),
);
//------------------------------------------------------------------------------
Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
    end: 5.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);
//------------------------------------------------------------------------------
void NavigationTo(context,widget)=>Navigator.push(context,
  MaterialPageRoute(
    builder:(context)=>widget ,
  ),);
//------------------------------------------------------------------------------
Widget ArticleBuilder(List list,context,{isBool = true})=>
    ConditionalBuilder(
  condition: list.length > 0 ,
  builder: (context)=>ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder:(context,index)=> buildNewsItem(list[index],context),
      separatorBuilder:(context,index)=> myDivider(),
      itemCount: list.length > 10? list.length-4:list.length-1
  ),
  fallback:(context)=> isBool? Container(): Center(child: LinearProgressIndicator()),
);
//------------------------------------------------------------------------------
void NavigationAndFinish(context,widget)=>
    Navigator.pushAndRemoveUntil(context,
  MaterialPageRoute(
    builder:(context)=>widget ,
  ),
        (Route<dynamic>route)=>false,
    );
//------------------------------------------------------------------------------
void PrintFullText(String text)
{
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) {print(match.group(0)); });
}
//------------------------------------------------------------------------------
Future<bool?> makeToast (String mssg) async {
  return  Fluttertoast.showToast(
      msg: mssg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:Colors.red[700],
      textColor: Colors.white,
      fontSize: 14.0 );
}
//------------------------------------------------------------------------------
PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? action,
})=>
    AppBar(
      leading: IconButton(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          icon: Icon(IconBroken.Arrow___Left_2)),
      titleSpacing: 0.0,
      title: Text(title!),
      actions: action,
    );