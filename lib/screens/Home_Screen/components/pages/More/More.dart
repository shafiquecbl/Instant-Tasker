import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Manage%20Tasks/Manage_Tasks.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Manage%20Orders/manage_orders.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Verification/verification.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/user_profile/user_profile.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widgets/customAppBar.dart';
import 'package:shop_app/widgets/snack_bar.dart';
import '../../../../../constants.dart';
import 'Post a Task/post_task.dart';
import 'components/profile_menu.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("More"),
      body: Column(
        children: [
          Container(
            color: kProfileColor,
            padding: EdgeInsets.only(top: 25, bottom: 60),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: kPrimaryColor.withOpacity(0.8),
                      child: user.photoURL != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/load.gif',
                                image: user.photoURL,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                'assets/images/nullUser.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )),
                  title: Text(
                    FirebaseAuth.instance.currentUser.email,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'My Peronal Balance: Rs.10000',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'General',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "My Profile",
                  icon: "assets/icons/User Icon.svg",
                  press: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfile(),
                      ),
                    ),
                  },
                ),
                ProfileMenu(
                  text: "Notifications",
                  icon: "assets/icons/verified.svg",
                  press: () => {},
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'Tasks',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "Post a Task",
                  icon: "assets/icons/posttask.svg",
                  press: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostTask(),
                      ),
                    ),
                  },
                ),
                ProfileMenu(
                  text: "Manage Tasks",
                  icon: "assets/icons/orders.svg",
                  press: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageTasks(),
                      ),
                    ),
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'Orders',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "Manage Orders",
                  icon: "assets/icons/orders.svg",
                  press: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageOrders(),
                      ),
                    ),
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 0),
                  child: Text(
                    'Verifications',
                    style: GoogleFonts.teko(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                ProfileMenu(
                  text: "Verifications",
                  icon: "assets/icons/verified.svg",
                  press: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Verifications(),
                      ),
                    ),
                  },
                ),
                ProfileMenu(
                  text: "Sign Out",
                  icon: "assets/icons/Log out.svg",
                  press: () async {
                    FirebaseAuth.instance.signOut().whenComplete(() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    }).catchError((e) {
                      Snack_Bar.show(context, e.message);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
