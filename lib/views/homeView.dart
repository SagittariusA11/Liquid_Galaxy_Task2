import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh2/ssh2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../kmlfiles/kml_files.dart';
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

  bool iitbhu = true;
  bool iitb = false;
  bool harvard = false;
  bool mit = false;


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
                      text: "IIT (BHU) - Varanasi",
                      onpress: () {
                        if(iitbhu) {
                          LGConnection().sendToLG(KML().iitbhu(), "iitbhu").then((value) async {
                            await LGConnection().cleanOrbit();
                            playOrbit();
                          });
                        } else {
                          LGConnection().cleanVisualization();
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    elevatedButton(
                      text: "IIT Bombay",
                      onpress: () {
                        if(iitb) {
                          LGConnection().sendToLG(KML().iitb(), "iitb").then((value) async {
                            await LGConnection().cleanOrbit();
                            playOrbit();
                          });
                        } else {
                          LGConnection().cleanVisualization();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    elevatedButton(
                      text: "MIT",
                      onpress: () {
                        if(mit) {
                          LGConnection().sendToLG(KML().mit(), "mit").then((value) async {
                            await LGConnection().cleanOrbit();
                            playOrbit();
                          });
                        } else {
                          LGConnection().cleanVisualization();
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    elevatedButton(
                      text: "Harvard",
                      onpress: () {
                        if(harvard) {
                          LGConnection().sendToLG(KML().harvard(), "harvard").then((value) async {
                            await LGConnection().cleanOrbit();
                            playOrbit();
                          });
                        } else {
                          LGConnection().cleanVisualization();
                        }
                      },
                    ),
                  ],
                ),
              ],
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

  Future cleanVisualization() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      stopOrbit();
      return await client.execute('> /var/www/html/kmls.txt');
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
      83.00123279485558,
      25.2781681151048,
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

      await client.execute(
          'echo "http://lg1:81/$projectname.kml" > /var/www/html/kmls.txt');

      return await client.execute(
          'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  buildOrbit(String content) async {
    dynamic credencials = await _getCredentials();

    String localPath = await _localPath;
    File localFile = File('$localPath/Orbit.kml');
    localFile.writeAsString(content);

    String filePath = '$localPath/Orbit.kml';

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      await client.connectSFTP();
      await client.sftpUpload(
        path: filePath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );
      return await client.execute(
          "echo '\nhttp://lg1:81/Orbit.kml' >> /var/www/html/kmls.txt");
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

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
}