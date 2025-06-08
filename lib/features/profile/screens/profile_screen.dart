import 'package:diploma_prj/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/profile_photo.dart';
import '../widgets/user_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Profile"),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const ProfilePic(image: "https://i.postimg.cc/cCsYDjvj/user-2.png"),

            const Divider(height: 16.0 * 2),
            const Info(
              infoKey: "Username",
              info: "dummy_user",
            ),
            const Info(
              infoKey: "Email address",
              info: "dummy@email.com",
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF6D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    context.go('/editProfile');
                  },
                  child: const Text("Edit profile"),
                ),
              ),
            ),
            const Divider(height: 16.0 * 2),

            Align(
              alignment: Alignment.centerLeft,
              child: MyButton(
                  contentText: 'LogOut',
                  onPressed: () {
                    context.go('/login');
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}



