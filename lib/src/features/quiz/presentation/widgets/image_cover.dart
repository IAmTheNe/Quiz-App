import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';

class ImageCover extends StatelessWidget {
  const ImageCover({
    super.key,
    required this.url,
    required this.attachType,
  });

  final String url;
  final AttachType attachType;

  @override
  Widget build(BuildContext context) {
    return attachType == AttachType.online
        ? Container(
            alignment: Alignment.center,
            height: 200,
            decoration: BoxDecoration(
              // color: Colors.black26,
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.kPadding),
              ),
              gradient: Constants.sunsetGradient,
              image: DecorationImage(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            height: 200,
            decoration: BoxDecoration(
              // color: Colors.black26,
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.kPadding),
              ),
              gradient: Constants.sunsetGradient,
              image: DecorationImage(
                image: FileImage(File(url)),
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
