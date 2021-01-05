import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/User.dart';

class VideoPlayerSlide extends StatefulWidget {
  final Map<String, String> videoUrls;
  final User user;
  const VideoPlayerSlide({
    Key key,
    @required this.user,
    @required this.videoUrls,
  }) : super(key: key);
  @override
  _VideoPlayerSlideState createState() => _VideoPlayerSlideState();
}

class _VideoPlayerSlideState extends State<VideoPlayerSlide> {
  @override
  Widget build(BuildContext context) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.videoUrls.values.first,
        resolutions: widget.videoUrls,
        headers: {
          "Cookie": "stay_login=0; PHPSESSID=" + widget.user.photoSessionId
        });
    BetterPlayerController _betterPlayerController;
    ThemeData theme = Theme.of(context);
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          controlsConfiguration: BetterPlayerControlsConfiguration(
              enableSkips: false,
              enableSubtitles: false,
              enableQualities: true,
              enableOverflowMenu: true,
              iconsColor: theme.iconTheme.color,
              controlBarColor: theme.backgroundColor),
          autoDetectFullscreenDeviceOrientation: true,
          fit: BoxFit.contain,
        ),
        betterPlayerDataSource: betterPlayerDataSource);

    return WillPopScope(
      child: BetterPlayer(controller: _betterPlayerController),
      onWillPop: () {
        _betterPlayerController.pause();
        return Future.value(true);
      },
    );
  }
}
