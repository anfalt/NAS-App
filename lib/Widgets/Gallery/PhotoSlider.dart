import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/redux/store.dart';
import 'package:photo_view/photo_view.dart';

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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    imagesForSlider.forEach((element) {
      precacheImage(
          CachedNetworkImageProvider(
            element.getLargeThumbUrl(user),
            headers: {
              "Cookie": "stay_login=0; PHPSESSID=" + user.photoSessionId
            },
          ),
          context);
    });
    var themeData = Theme.of(context);
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
                  GestureDetector(
                      onVerticalDragStart: (details) => {closeSlider(context)},
                      child: Container(child: () {
                        if (imagesForSlider[itemIndex].type == "photo") {
                          return photoSliderItem(
                              context, imagesForSlider[itemIndex], user);
                        } else if (imagesForSlider[itemIndex].type == "video") {
                          return videoSliderItem(
                              context, imagesForSlider[itemIndex], user);
                        }
                      }())),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: themeData.accentColor,
                ),
                onPressed: () => closeSlider(context),
              ),
            ]),
            Container(
              width: getScreenWidth,
              height: getScreenHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_left,
                      color: themeData.accentColor,
                    ),
                    onPressed: () => {carouselController.previousPage()},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_right,
                      color: themeData.accentColor,
                    ),
                    onPressed: () => {carouselController.nextPage()},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

closeSlider(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  Navigator.pop(context);
}

Widget getCarouselForHomePage(
  BuildContext context,
  List<AlbumAsset> imagesForSlider,
  User user,
) {
  imagesForSlider.forEach((element) {
    precacheImage(
        CachedNetworkImageProvider(
          element.getLargeThumbUrl(user),
          headers: {"Cookie": "stay_login=0; PHPSESSID=" + user.photoSessionId},
        ),
        context);
  });
  var getScreenHeight = MediaQuery.of(context).size.height;
  var carouselOptions = CarouselOptions(
      height: getScreenHeight / 3,
      viewportFraction: 1,
      enlargeCenterPage: false,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      scrollDirection: Axis.horizontal,
      scrollPhysics: ClampingScrollPhysics());
  CarouselController carouselController = new CarouselController();

  return CarouselSlider.builder(
    carouselController: carouselController,
    options: carouselOptions,
    itemCount: imagesForSlider.length,
    itemBuilder: (BuildContext context, int itemIndex) => Container(child: () {
      if (imagesForSlider[itemIndex].type == "photo") {
        return Stack(alignment: Alignment.center, children: [
          photoSliderItem(context, imagesForSlider[itemIndex], user,
              getSmallThumb: false),
          getGetOverlayLatestSlider(context, imagesForSlider[itemIndex])
        ]);
      } else if (imagesForSlider[itemIndex].type == "video") {
        return Stack(alignment: Alignment.center, children: [
          videoSliderItem(context, imagesForSlider[itemIndex], user,
              getSmallThumb: false),
          getGetOverlayLatestSlider(context, imagesForSlider[itemIndex])
        ]);
      }
    }()),
  );
}

Widget getGetOverlayLatestSlider(BuildContext context, AlbumAsset asset) {
  return InkWell(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0.9),
              ],
                  stops: [
                0.0,
                0.7,
                1.0
              ])),
          child: Column(verticalDirection: VerticalDirection.up, children: [
            ListTile(
              title: Text(asset.parentAsset.info.title),
              subtitle: Text(getUploadDateAsText(asset)),
            )
          ])),
      onTap: () {
        var store = Redux.store;
        store.dispatch((store) => {
              Navigator.of(context).pushNamed("/images",
                  arguments: {"albumId": asset.parentAsset.id})
            });
      });
}

String getUploadDateAsText(AlbumAsset asset) {
  var diff =
      new DateTime.now().difference(DateTime.parse(asset.info.createdate));
  if (diff.inDays < 2) {
    return "vor " + (diff.inHours - 8).toString() + " Stunden";
  } else {
    return "vor " + diff.inDays.toString() + " Tagen";
  }
}

Widget photoSliderItem(BuildContext context, AlbumAsset asset, User user,
    {bool getSmallThumb = false}) {
  var imageUrl = getSmallThumb
      ? asset.getSmallThumbURL(user)
      : asset.getLargeThumbUrl(user);

  return Container(
      child: PhotoView(
          imageProvider: CachedNetworkImage(
              httpHeaders: {
        "Cookie": "stay_login=0; PHPSESSID=" + user.photoSessionId
      },
              imageUrl: imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    value: downloadProgress.progress,
                  )),
              errorWidget: (context, url, error) => Icon(Icons.error))));
}

Widget videoSliderItem(BuildContext context, AlbumAsset asset, User user,
    {bool getSmallThumb = false}) {
  var downloadUrls = asset.getVideoDownloadUrls(user);
  return VideoPlayerSlide(
    videoUrls: downloadUrls,
    user: user,
  );
}
