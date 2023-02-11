import 'package:flutter/material.dart';
import 'package:lg_app/config/app_theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
