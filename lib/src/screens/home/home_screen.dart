import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';

import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/cubit/top_quiz_cubit.dart';
import 'package:whizz/src/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: Column(
            children: [
              _buildPlayQuiz(context),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Collection',
                    style: AppConstant.textHeading,
                  ),
                  Text(
                    'Show all',
                    style: AppConstant.textSubtitle,
                  ),
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              _buildTopCollection(),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Quizz',
                    style: AppConstant.textHeading,
                  ),
                  Text(
                    'Show all',
                    style: AppConstant.textSubtitle,
                  ),
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              SizedBox(
                height: .18.sh,
                child: BlocBuilder<TopQuizCubit, TopQuizState>(
                  builder: (context, state) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: !state.isLoading ? state.quiz.length : 10,
                      itemBuilder: (context, index) {
                        return !state.isLoading
                            ? Container(
                                margin: const EdgeInsets.only(
                                    right: AppConstant.kPadding / 2),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      RouterPath.quizDetail.name,
                                      pathParameters: {
                                        'id': state.quiz[index].id
                                      },
                                      extra: state.quiz[index],
                                    );
                                  },
                                  child: _buildTopQuiz(state, index),
                                ),
                              )
                            : Container();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AspectRatio _buildTopQuiz(TopQuizState state, int index) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ImageCover(media: state.quiz[index].media),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstant.kPadding / 4,
                      horizontal: AppConstant.kPadding,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppConstant.kPadding),
                        bottomLeft: Radius.circular(AppConstant.kPadding),
                      ),
                    ),
                    child: Text(
                      '${state.quiz[index].questions.length} questions',
                      style: AppConstant.textSubtitle.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppConstant.kPadding / 2,
          ),
          Text(
            state.quiz[index].title,
            style: AppConstant.textTitle700,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  SizedBox _buildTopCollection() {
    return SizedBox(
      height: .15.sh,
      child: BlocBuilder<QuizCollectionCubit, QuizCollectionState>(
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                state is QuizCollectionSuccess ? state.collections.length : 10,
            itemBuilder: (context, index) {
              if (state is QuizCollectionSuccess) {
                return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        RouterPath.discoveryDetail.name,
                        extra: state.collections[index],
                      );
                      context
                          .read<QuizCollectionCubit>()
                          .onGetQuizByCollectionId(state.collections[index].id);
                    },
                    child:
                        CollectionCard(collection: state.collections[index]));
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Stack _buildPlayQuiz(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
            child: Assets.images.homeIntroduce.image(
              height: .35.sh,
              width: 1.sw,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: .35.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.black26,
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Center(
            child: Text(
              'Play quiz together with your friend now!',
              style: AppConstant.textTitle700.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: CustomButton(
            onPressed: () => context.pushNamed(RouterPath.play.name),
            label: 'Let\'s start!',
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Quizwhizz'),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearch(),
            );
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        // CircleAvatar(
        //   backgroundColor: Colors.grey.shade300,
        //   backgroundImage: const CachedNetworkImageProvider(
        //       'https://scontent.fdad1-4.fna.fbcdn.net/v/t39.30808-6/362222624_1482954875782698_4218631403666751824_n.jpg?_nc_cat=103&cb=99be929b-3346023f&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=65Zhcu4XNhcAX-IJfoL&_nc_ht=scontent.fdad1-4.fna&oh=00_AfDwLV7-VHVWFJiJmz0SNSJUM6JfMj1d8gbB6enGwXXglw&oe=64C13E9A'),
        // ),
        // SizedBox(
        //   width: AppConstant.kPadding.w / 2,
        // ),
      ],
    );
  }
}

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.collection,
  });

  final QuizCollection collection;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            margin: const EdgeInsets.only(right: AppConstant.kPadding / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstant.kPadding),
              image: DecorationImage(
                image: CachedNetworkImageProvider(collection.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            margin: const EdgeInsets.only(right: AppConstant.kPadding / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstant.kPadding),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black26,
                  Colors.black12,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
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

class CustomSearch extends SearchDelegate {
  List<String> examples = [
    'Cấu trúc dữ liệu và giải thuật',
    'Vợ nhặt',
    'English 10 - Unit 6',
    'Ai là người hiểu Thương nhất?',
    'Christmas',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = <String>[];
    for (final item in examples) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = <String>[];
    for (final item in examples) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
