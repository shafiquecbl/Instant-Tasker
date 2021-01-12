import 'package:flutter/material.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Post%20a%20Task/post_task_form.dart';
import 'package:shop_app/size_config.dart';
class PostTask extends StatefulWidget {
  @override
  _PostTaskState createState() => _PostTaskState();
}

class _PostTaskState extends State<PostTask> {
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post a Task"),
      ),
      body:  SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                PostTaskForm()
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  
}