import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Model/User.dart';

import "VideoPlayerSlide.dart";

class PhotoSlider extends StatelessWidget {
  const PhotoSlider({
    Key key,
    @required this.currentAssetIndex,
    @required this.imagesForSlider,
    @required this.user,
  }) : super(key: key);

  final int currentAssetIndex;
  final User user;
  final List<AlbumAsset> imagesForSlider;

  @override
  Widget build(BuildContext context) {
    var getScreenHeight = MediaQuery.of(context).size.height;
    var getScreenWidth = MediaQuery.of(context).size.width;
    var carouselOptions = CarouselOptions(
        viewportFraction: 1,
        initialPage: currentAssetIndex,
        enableInfiniteScroll: true,
        height: getScreenHeight,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        scrollPhysics: ClampingScrollPhysics());
    CarouselController carouselController = new CarouselController();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CarouselSlider.builder(
              carouselController: carouselController,
              options: carouselOptions,
              itemCount: imagesForSlider.length,
              itemBuilder: (BuildContext context, int itemIndex) =>
                  Container(child: () {
                if (imagesForSlider[itemIndex].type == "photo") {
                  return photoSliderItem(
                      context, imagesForSlider[itemIndex], user);
                } else if (imagesForSlider[itemIndex].type == "video") {
                  return videoSliderItem(context, imagesForSlider[itemIndex]);
                }
              }()),
            ),
            Container(
              width: getScreenWidth,
              height: getScreenHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                    ),
                    onPressed: () => {carouselController.previousPage()},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    ),
                    onPressed: () => {carouselController.nextPage()},
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget photoSliderItem(BuildContext context, AlbumAsset asset, User user) {
    var imageUrl = asset.getLargeThumbUrl(user);
    return CachedNetworkImage(
        httpHeaders: {
          "Cookie": "stay_login=0; PHPSESSID=" + user.photoSessionId
        },
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
              value: downloadProgress.progress,
            )),
        errorWidget: (context, url, error) => Icon(Icons.error));
  }

  Widget videoSliderItem(BuildContext context, AlbumAsset asset) {
    var downloadUrls = asset.getVideoDownloadUrls(user);
    return VideoPlayerSlide(
      videoUrls: downloadUrls,
      user: user,
    );
  }
}
