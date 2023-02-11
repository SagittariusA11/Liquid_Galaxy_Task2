import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../config/app_theme.dart';
import '../config/screen_config.dart';
import '../view_models/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  SplashViewModel splashViewModel = SplashViewModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig.init(context);
  }

  @override
  void initState() {
    super.initState();
    splashViewModel.initiateApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.height*0.3,
                width: SizeConfig.height*0.531,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    VideoWidget(),
                  ],
                ),
              ),
              Text(
                'Liquid Galaxy',
                style: AppTheme().headText1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash_video.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: _controller.value.isInitialized
          ? LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width:
                constraints.maxWidth,
                height:
                constraints.maxHeight,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        },
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
