import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/models/media.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/rainbow_container.dart';

class ImageCover extends StatelessWidget {
  const ImageCover({
    super.key,
    required this.media,
  });

  final Media media;

  @override
  Widget build(BuildContext context) {
    return switch (media.type) {
      AttachType.online => AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.black26,
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.kPadding),
              ),
              gradient: Constants.sunsetGradient,
              image: DecorationImage(
                image: CachedNetworkImageProvider(media.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      AttachType.local => AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.black26,
              borderRadius: const BorderRadius.all(
                Radius.circular(Constants.kPadding),
              ),
              gradient: Constants.sunsetGradient,
              image: DecorationImage(
                image: FileImage(File(media.imageUrl!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      _ => const RainbowContainer(),
    };
  }
}
