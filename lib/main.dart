import 'package:flutter/material.dart';
import 'package:simple_video_player/duration.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: VideoPlayerWidget(),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  static const _hudPadding = 5.0;
  static const _hudTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/i/pgDnuusXODJxAA',
      ),
    );

    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(false);

    _videoPlayerController.addListener(() {
      setState(() {});
    });

    setState(() {
      _videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: InkWell(
              onTap: () {
                _playAndPauseVideo();
              },
              child: Stack(
                children: [
                  VideoPlayer(_videoPlayerController),
                  Positioned(
                    bottom: _hudPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: 5,
                          child: VideoProgressIndicator(
                            _videoPlayerController,
                            allowScrubbing: true,
                            padding: const EdgeInsets.symmetric(horizontal: _hudPadding * 3),
                            colors: VideoProgressColors(
                              playedColor: Colors.white,
                              bufferedColor: Colors.white.withOpacity(0.5),
                              backgroundColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _playAndPauseVideo();
                              },
                              icon: Icon(
                                _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                            Text(_videoPlayerController.value.position.prettyFormat(), style: _hudTextStyle),
                            const Text(' / ', style: _hudTextStyle),
                            Text(_videoPlayerController.value.duration.prettyFormat(), style: _hudTextStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _playAndPauseVideo() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
    });
  }
}
