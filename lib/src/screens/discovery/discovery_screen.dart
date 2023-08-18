import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';

import 'package:whizz/src/modules/collection/model/quiz_collection.dart';

import 'package:whizz/src/router/app_router.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery'),
      ),
      body: BlocBuilder<QuizCollectionCubit, QuizCollectionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppConstant.kPadding),
            child: GridView.custom(
              gridDelegate: SliverWovenGridDelegate.count(
                pattern: [
                  const WovenGridTile(1),
                  const WovenGridTile(
                    5 / 7,
                    crossAxisRatio: 0.9,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ],
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 2,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: state is QuizCollectionSuccess
                    ? state.collections.length
                    : 50,
                (context, index) {
                  return switch (state) {
                    QuizCollectionLoading() => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    QuizCollectionSuccess() => GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            RouterPath.discoveryDetail.name,
                            extra: state.collections[index],
                          );
                          context
                              .read<QuizCollectionCubit>()
                              .onGetQuizByCollectionId(
                                  state.collections[index].id);
                        },
                        child: DiscoveryCard(
                          collection: state.collections[index],
                        ),
                      ),
                    _ => Container(
                        color: Colors.grey.shade300,
                      ),
                  };
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          right: AppConstant.kPadding,
          bottom: AppConstant.kPadding,
        ),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class DiscoveryCard extends StatelessWidget {
  const DiscoveryCard({
    super.key,
    required this.collection,
  });

  final QuizCollection collection;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
            image: DecorationImage(
              image: CachedNetworkImageProvider(collection.imageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(AppConstant.kPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [.6, .7],
              colors: [
                Colors.black26,
                Colors.black54,
              ],
            ),
          ),
          child: Text(
            collection.name,
            style: AppConstant.textSubtitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
