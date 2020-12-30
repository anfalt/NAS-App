import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';

import "../../globals.dart" as globals;

class PhotoSlider extends StatelessWidget {
  const PhotoSlider({
    Key key,
    @required this.currentAssetIndex,
    @required this.imagesForSlider,
  }) : super(key: key);

  final int currentAssetIndex;
  final List<Asset> imagesForSlider;

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
              itemBuilder: (BuildContext context, int itemIndex) => Container(
                child: photoSliderItem(context, imagesForSlider[itemIndex]),
              ),
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

  Widget photoSliderItem(BuildContext context, Asset asset) {
    var imageUrl = getImageURL(asset);
    var downloadUrl = getDownloadUrl(asset);
    return CachedNetworkImage(
        httpHeaders: {
          "Cookie": "stay_login=0; PHPSESSID=" + globals.user.photoSessionId
        },
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
              value: downloadProgress.progress,
            )),
        errorWidget: (context, url, error) => Icon(Icons.error));
  }

  String getImageURL(Asset asset) {
    return "https://anfalt.de/photo/webapi/thumb.php?api=SYNO.PhotoStation.Thumb&method=get&version=1&size=large&id=" +
        asset.id +
        "&thumb_sig=" +
        asset.additional.thumbSize.sig +
        "&mtime=" +
        asset.additional.thumbSize.large.mtime.toString() +
        "&SynoToken=" +
        globals.user.photoSessionId;
  }

  String getDownloadUrl(Asset asset) {
    return "https://anfalt.de/photo/webapi/download.php1.mp4?api=SYNO.PhotoStation.Download&method=getvideo&version=1&id=" +
        asset.id +
        "&quality_id=" +
        asset.additional.thumbSize.sig +
        "&SynoToken=" +
        globals.user.photoSessionId;
  }
}
