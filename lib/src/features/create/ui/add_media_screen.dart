import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/create/data/bloc/create_quiz/create_quiz_cubit.dart';
import 'package:whizz/src/features/create/data/bloc/fetch_unsplash/fetch_unsplash_bloc.dart';

class AddMediaScreen extends StatelessWidget {
  const AddMediaScreen({super.key});

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
                    context
                        .read<CreateQuizCubit>()
                        .onPickImage()
                        .then((_) => context.pop());
                  },
                  title: 'Gallery',
                  icon: Icons.image_outlined,
                ),
                CustomSquareButton(
                  onTap: () {
                    context
                        .read<CreateQuizCubit>()
                        .onTakePhoto()
                        .then((_) => context.pop());
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
            BlocBuilder<FetchUnsplashBloc, FetchUnsplashState>(
              builder: (context, state) {
                if (state is LoadingFetchState) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state is SuccessFetchState) {
                  return Expanded(
                    child: MasonryGridView.builder(
                      itemCount: state.photos.length,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      mainAxisSpacing: Constants.kPadding / 4,
                      crossAxisSpacing: Constants.kPadding / 4,
                      itemBuilder: (context, index) {
                        final url = state.photos[index].urls.raw.toString();
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<CreateQuizCubit>()
                                .onSelectedOnlineImage(url)
                                .then((_) => context.pop());
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Constants.kPadding / 4),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              filterQuality: FilterQuality.high,
                              progressIndicatorBuilder:
                                  (context, url, download) {
                                if (download.progress != null) {
                                  final percent = download.progress! * 100;
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 200,
                                    color: Colors.grey.shade300,
                                    child: Text('${percent.toInt()}%'),
                                  );
                                }
                                return Container(
                                  height: 200,
                                  color: Colors.grey.shade300,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container(
                  height: 220,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSquareButton extends StatelessWidget {
  const CustomSquareButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.indigo.shade400,
        child: Container(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: Constants.kPadding / 4),
              Text(
                title,
                style: Constants.textSubtitle.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
