import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh2/ssh2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../utils/orbit.dart';
import '../utils/utils.dart';
import 'loginView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {

  bool isOrbiting = false;
  double latvalue = 28.55665656297236;
  double longvalue = -17.885454520583153;
  late AnimationController _rotationiconcontroller;

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _rotationiconcontroller = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotationiconcontroller.dispose();
    super.dispose();
  }

  playOrbit() async {
    // await LGConnection()
    //     .buildOrbit(Orbit.buildOrbit(Orbit.generateOrbitTag(
    //     LookAt(longvalue, latvalue, "6341.7995674", "0", "0"))))
    //     .then((value) async {
    //   await LGConnection().startOrbit();
    // });
    await LGConnection().startOrbit();
    setState(() {
      isOrbiting = true;
    });
  }

  stopOrbit() async {
    await LGConnection().stopOrbit();
    setState(() {
      isOrbiting = false;
    });
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
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    elevatedButton(
                      text: "Play Orbit",
                      onpress: () => {
                        isOrbiting = !isOrbiting,
                        if (isOrbiting == true)
                        {
                        _rotationiconcontroller.forward(),
                        LGConnection().cleanOrbit().then((value) {
                        playOrbit();
                        }),
                        }
                      },
                    ),
                    elevatedButton(
                      text: "Stop Orbit",
                      onpress: () => {
                        isOrbiting = !isOrbiting,
                        if (isOrbiting == true)
                        {
                        _rotationiconcontroller.reset(),
                        stopOrbit().then((value) {
                        LGConnection().cleanOrbit();
                        }),
                        }
                      },
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

class LGConnection {
  Future sendToLG(String kml, String projectname) async {
    if (kml.isNotEmpty) {
      return _createLocalFile(kml, projectname);
    }
    return Future.error('nogeodata');
  }

  _createLocalFile(String kml, String projectname) async {
    String localPath = await _localPath;
    File localFile = File('$localPath/$projectname.kml');
    localFile.writeAsString(kml);
    File localFile2 = File('$localPath/kmls.txt');
    localFile2.writeAsString(kml);
    return _uploadToLG('$localPath/$projectname.kml', projectname);
  }

  _uploadToLG(String localPath, String projectname) async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    LookAt flyto = LookAt(
      -17.895486,
      28.610478,
      '${91708.9978371 / int.parse(credencials['numberofrigs'])}',
      '45',
      '0',
    );
    try {
      await client.connect();
      await client.execute('> /var/www/html/kmls.txt');

      // upload kml
      await client.connectSFTP();
      await client.sftpUpload(
        path: localPath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );

      // for (int k = 0; k < localimages.length; k++) {
      //   String imgPath = await _createLocalImage(
      //       localimages[k], "assets/icons/${localimages[k]}");
      //   await client.sftpUpload(path: imgPath, toPath: '/var/www/html');
      // }
      await client.execute(
          'echo "http://lg1:81/$projectname.kml" > /var/www/html/kmls.txt');

      return await client.execute(
          'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  _getCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ipAddress = preferences.getString('master_ip') ?? '';
    String password = preferences.getString('master_password') ?? '';
    String portNumber = preferences.getString('master_portNumber') ?? '';
    String username = preferences.getString('master_username') ?? '';
    String numberofrigs = preferences.getString('numberofrigs') ?? '';

    return {
      "ip": ipAddress,
      "pass": password,
      "port": portNumber,
      "username": username,
      "numberofrigs": numberofrigs
    };
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // buildOrbit(String content) async {
  //   dynamic credencials = await _getCredentials();
  //
  //   String localPath = await _localPath;
  //   File localFile = File('$localPath/Orbit.kml');
  //   localFile.writeAsString(content);
  //
  //   String filePath = '$localPath/Orbit.kml';
  //
  //   SSHClient client = SSHClient(
  //     host: '${credencials['ip']}',
  //     port: int.parse('${credencials['port']}'),
  //     username: '${credencials['username']}',
  //     passwordOrKey: '${credencials['pass']}',
  //   );
  //
  //   try {
  //     await client.connect();
  //     await client.connectSFTP();
  //     await client.sftpUpload(
  //       path: filePath,
  //       toPath: '/var/www/html',
  //       callback: (progress) {
  //         print('Sent $progress');
  //       },
  //     );
  //     return await client.execute(
  //         "echo '\nhttp://lg1:81/Orbit.kml' >> /var/www/html/kmls.txt");
  //   } catch (e) {
  //     print('Could not connect to host LG');
  //     return Future.error(e);
  //   }
  // }

  startOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  stopOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  cleanOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }
}