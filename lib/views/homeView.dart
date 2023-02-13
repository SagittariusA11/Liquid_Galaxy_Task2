import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/utils.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    elevatedButton(
                      text: "New York",
                      onpress: () {},
                    ),
                    SizedBox(height: 16.0),
                    elevatedButton(
                      text: "London",
                      onpress: () {},
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    elevatedButton(
                      text: "Tokyo",
                      onpress: () {},
                    ),
                    SizedBox(height: 16.0),
                    elevatedButton(
                      text: "Sydney",
                      onpress: () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            FloatingActionButton.extended(
              onPressed: () {
                final snackBar = SnackBar(
                  content: const Text('View has started'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              label: Text(
                'View in Liquid Galaxy',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
