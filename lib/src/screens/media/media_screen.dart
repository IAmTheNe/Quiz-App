import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/pick_image.dart';

import 'package:whizz/src/modules/media/bloc/online_media_bloc.dart';
import 'package:whizz/src/screens/media/widgets/custom_square_button.dart';
import 'package:whizz/src/screens/media/widgets/masonry_list_photo.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add media'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSquareButton(
                  onTap: () => context
                      .read<OnlineMediaBloc>()
                      .add(PopEvent(context, PickImage.pickImage())),
                  title: 'Gallery',
                  icon: Icons.image_outlined,
                ),
                CustomSquareButton(
                  onTap: () => context
                      .read<OnlineMediaBloc>()
                      .add(PopEvent(context, PickImage.takePhoto())),
                  title: 'Camera',
                  icon: Icons.camera_alt_outlined,
                ),
              ],
            ),
            const SizedBox(
              height: AppConstant.kPadding,
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
              height: AppConstant.kPadding,
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
