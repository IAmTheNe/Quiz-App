import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/modules/pick_image.dart';
import 'package:whizz/src/features/media/data/bloc/online_media_bloc.dart';
import 'package:whizz/src/features/media/presentation/widgets/custom_square_button.dart';
import 'package:whizz/src/features/media/presentation/widgets/masonry_list_photo.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  void pop(
    BuildContext context,
    Future<File?> onPick,
  ) {
    onPick.then(
      (file) {
        if (file != null) {
          context.pop((
            file.path,
            AttachType.local,
          ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add media'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSquareButton(
                  onTap: () {
                    pop(context, PickImage.pickImage());
                  },
                  title: 'Gallery',
                  icon: Icons.image_outlined,
                ),
                CustomSquareButton(
                  onTap: () {
                    pop(context, PickImage.takePhoto());
                  },
                  title: 'Camera',
                  icon: Icons.camera_alt_outlined,
                ),
              ],
            ),
            const SizedBox(
              height: Constants.kPadding,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.clear),
                ),
                border: const OutlineInputBorder(),
                hintText: 'Search image',
              ),
            ),
            const SizedBox(
              height: Constants.kPadding,
            ),
            BlocBuilder<OnlineMediaBloc, OnlineMediaState>(
              builder: (context, state) {
                return switch (state) {
                  LoadingFetchState() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  SuccessFetchState() => Expanded(
                      child: MasonryListPhotos(
                        state: state,
                      ),
                    ),
                  _ => Container(
                      height: 100,
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
