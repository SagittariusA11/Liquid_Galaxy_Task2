import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home View',
        style: AppTheme().headText1,
      ),
    );
  }
}
