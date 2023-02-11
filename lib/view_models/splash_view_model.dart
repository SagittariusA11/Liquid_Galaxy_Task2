

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../views/loginView.dart';

class SplashViewModel{


  initiateApp(BuildContext context)async{

    await Future.delayed(const Duration(seconds: 4));

    Navigator.of(context).pop();
    Get.to(()=>LoginView());
  }

}