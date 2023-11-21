import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final dynamic data;
  const VideoScreen({Key? key, this.data}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Videos"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.data.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Get the video array from the document snapshot
                      List<dynamic> videoArray = snapshot.data!.get('p_video');

                      // Pass the video array to the VideoSlider component
                      return VideoSlider(videoArray: videoArray);
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error fetching video data',
                        style: TextStyle(color: Colors.black),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoSlider extends StatefulWidget {
  final List<dynamic> videoArray;

  VideoSlider({required this.videoArray});

  @override
  _VideoSliderState createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  int currentIndex = 0;
  int? currentPlayingIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: widget.videoArray.asMap().entries.map((entry) {
            final index = entry.key;
            final videoUrl = entry.value;
            return VideoPlayerWidget(
              videoUrl: videoUrl,
              isPlaying: currentPlayingIndex == index,
              onPlayPausePressed: () {
                setState(() {
                  if (currentPlayingIndex == index) {
                    currentPlayingIndex = null;
                  } else {
                    currentPlayingIndex = index;
                  }
                });
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 300,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
                currentPlayingIndex = null; // Stop playing when changing slide
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Video ${currentIndex + 1} of ${widget.videoArray.length}',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isPlaying;
  final VoidCallback onPlayPausePressed;

  VideoPlayerWidget({
    required this.videoUrl,
    required this.isPlaying,
    required this.onPlayPausePressed,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          if (_isPlaying) {
            _controller.play();
          } else {
            _controller.pause();
          }
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()),
          GestureDetector(
            onTap: _togglePlayPause,
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }
}
