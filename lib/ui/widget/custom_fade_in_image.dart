import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:arbyuser/util/app_constant.dart';

class CustomFadeInImage extends StatelessWidget {
  String url;
  String? placeHolder;
  BoxFit? fit;
  Color? color;
  double? width;
  double? height;
  Widget? placeHolderWidget;
  Function? imageLoaded;

  CustomFadeInImage(
      {required this.url,
      this.placeHolder,
      this.fit,
      this.color,
      this.width,
      this.height,
      this.placeHolderWidget,
      this.imageLoaded});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: url,
      color: color,
      fadeInDuration: Duration(milliseconds: 0),
      imageBuilder: (context, ImageProvider<Object> imageProvider) {
        if (imageLoaded != null) {
          imageLoaded!();
        }
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          color: color,
          fit: fit,
        );
      },
      placeholder: (_, __) {
        if (placeHolderWidget != null) {
          return placeHolderWidget!;
        }
        return Image.asset(
          placeHolder ?? AppImage.logo1,
          width: width,
          height: height,
          fit: fit,
        );
      },
      errorWidget: (_, __, ___) {
        return Image.file(
          File(
            url,
          ),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) {
            if (placeHolderWidget != null) {
              return placeHolderWidget!;
            }
            return Image.asset(
              placeHolder ?? AppImage.logo1,
              width: width,
              height: height,
              fit: fit,
            );
          },
        );
      },
    );
  }
}
