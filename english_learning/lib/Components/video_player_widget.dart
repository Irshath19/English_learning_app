import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoName;

  VideoPlayerScreen({required this.videoName});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideo();
  }

  Future<void> fetchVideo() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/video/${widget.videoName}'),
      );

      if (response.statusCode == 200) {
        final videoData = jsonDecode(response.body)['videoData'];
        _initializeVideoPlayer(videoData);
      } else {
        print('Failed to fetch video: ${response.statusCode}');
        // Handle error, show error message, retry mechanism, etc.
      }
    } catch (e) {
      print('Error fetching video: $e');
      // Handle error, show error message, retry mechanism, etc.
    }
  }

  void _initializeVideoPlayer(String videoData) {
    _videoPlayerController = VideoPlayerController.network(
      'data:video/mp4;base64,$videoData',
    );

    _videoPlayerController.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
      _videoPlayerController.play();
    });

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.hasError) {
        print(
            'Video Player Error: ${_videoPlayerController.value.errorDescription}');
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : Text('Video not found'),
      ),
    );
  }
}
