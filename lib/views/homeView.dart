// import 'package:flutter/material.dart';
// import 'package:lg_app/config/app_theme.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Home View',
//         style: AppTheme().headText1,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track and Map'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Track'),
            Tab(text: 'Map'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                elevatedButton(
                  text: "New York",
                  onpress: () {},
                ),
                SizedBox(height: 16.0),
                elevatedButton(
                  text: "London",
                  onpress: () {},
                ),
                SizedBox(height: 16.0),
                elevatedButton(
                  text: "Tokyo",
                  onpress: () {},
                ),
                SizedBox(height: 16.0),
                elevatedButton(
                  text: "Sydney",
                  onpress: () {},
                ),
                SizedBox(height: 16.0),
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text('View in Liquid Galaxy'),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'Maps',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
