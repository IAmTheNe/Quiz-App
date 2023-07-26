import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/profile/data/bloc/profile_cubit.dart';
import 'package:whizz/src/features/profile/presentation/widgets/quiz_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildTop(context, state),
              _buildDisplayInformation(state),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              _buildListQuiz(state),
            ],
          );
          // return _buildTop(state);
        },
      ),
    );
  }

  Padding _buildListQuiz(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.isLoading
              ? Text(
                  '0 Quiz',
                  style: AppConstant.textHeading,
                )
              : Text(
                  '${state.quizzies.length} Quizz',
                  style: AppConstant.textHeading,
                ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuizCard(quiz: state.quizzies[index]),
                  const SizedBox(
                    height: AppConstant.kPadding / 2,
                  ),
                ],
              );
            },
            itemCount: state.quizzies.length,
          ),
        ],
      ),
    );
  }

  Column _buildDisplayInformation(ProfileState state) {
    return Column(
      children: [
        Text(
          state.user.name ?? 'Nameless',
          style: AppConstant.textTitle700,
        ),
        Text(
          '@${state.user.id}',
          style: AppConstant.textSubtitle,
        ),
      ],
    );
  }

  Stack _buildTop(BuildContext context, ProfileState state) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _buildCoverImage(context),
        _buildAvatar(state),
      ],
    );
  }

  Positioned _buildAvatar(ProfileState state) {
    return Positioned(
      top: 150 - 35,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: state.user.avatar != null
              ? CachedNetworkImageProvider(state.user.avatar!)
              : null,
        ),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 35),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF22C1C3),
                Color(0xFFFDBB2D),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppConstant.kPadding * 2),
              bottomRight: Radius.circular(AppConstant.kPadding * 2),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
