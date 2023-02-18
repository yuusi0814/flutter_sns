import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sns/utils/authentication.dart';
import 'package:flutter_sns/utils/firestore/users.dart';

import '../../utils/widget_utils.dart';
import '../screen.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String pass;
  CheckEmailPage({required this.email, required this.pass});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar("メールアドレスを確認"),
      body: Column(
        children: [
          Text(
              "登録いただいたメールアドレス宛に確認のメールを送信しております。そちらに記載されているURLをクリックし認証をお願いします。"),
          ElevatedButton(
            onPressed: () async {
              var result = await Authentication.emailSignIn(
                email: widget.email,
                pass: widget.pass,
              );
              if (result is UserCredential) {
                if (result.user!.emailVerified == true) {
                  while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  await UserFirestore.getUser(result.user!.uid);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Screen(),
                    ),
                  );
                } else {
                  print("メール認証おわっていません。");
                }
              }
            },
            child: Text("認証完了"),
          )
        ],
      ),
    );
  }
}
