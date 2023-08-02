import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';

class Carrusel extends StatelessWidget {
  const Carrusel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BannerCarousel(
        banners: listBanners,
        customizedIndicators: const IndicatorModel.animation(
            width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
        //height: 120,
        activeColor: const Color.fromARGB(255, 7, 73, 21),
        disableColor: Colors.white,
        animation: true,
        //borderRadius: 10,
        width: double.infinity,
        indicatorBottom: false,
      ),
    );
  }
}

List<BannerModel> listBanners = [
  BannerModel(
      imagePath:
          "https://www.elfinanciero.com.mx/resizer/tG1QwGcirkO6QXmSOrqDZ9QAops=/1440x810/filters:format(jpg):quality(70)/cloudfront-us-east-1.images.arcpublishing.com/elfinanciero/66FDFZT3F35ZMDP2B7KMRFWXZI.jpg",
      id: "1"),
  BannerModel(
      imagePath:
          "https://www.cfe.mx/distribucion/PublishingImages/Distribucion.jpg",
      id: "2"),
  BannerModel(
      imagePath:
          "https://elcapitalino.mx/wp-content/uploads/2022/07/FXPVOV_XkAAT8Lc-1080x608.jpg",
      id: "3"),
  BannerModel(
      imagePath:
          "https://enviromx.com/wp-content/uploads/2019/05/PSeguridad2.jpg",
      id: "4"),
];
