import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/quiz_textfield.dart';
import 'package:whizz/src/features/create/data/bloc/create_quiz/create_quiz_cubit.dart';
import 'package:whizz/src/features/create/data/bloc/fetch_unsplash/fetch_unsplash_bloc.dart';
import 'package:whizz/src/features/create/ui/add_media_screen.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: Column(
            children: [
              BlocBuilder<CreateQuizCubit, CreateQuizState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      navigator(context);
                    },
                    child: state.imagePath != null
                        ? ImageCover(
                            url: state.imagePath!,
                            attachType: state.attach!,
                          )
                        : const RainbowContainer(),
                  );
                },
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizFormField(
                hintText: 'Name',
                maxLength: 50,
                onChanged: context.read<CreateQuizCubit>().nameChanged,
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizFormField(
                hintText: 'Description',
                maxLines: 6,
                maxLength: 500,
                onChanged: context.read<CreateQuizCubit>().descriptionChanged,
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizDropDownField(
                onChanged: (val) {},
                label: const Text('Collection'),
                items: const ['Holiday', 'Games', 'Sports', 'Music'],
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizDropDownField(
                onChanged: (val) {
                  context
                      .read<CreateQuizCubit>()
                      .visibilityChanged(val as String);
                },
                label: const Text('Visibility'),
                items: const ['Public', 'Private'],
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              const QuizFormField(
                hintText: 'Keyword',
                maxLines: 6,
                maxLength: 1000,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Constants.kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  elevation: 4,
                ),
                child: Text(
                  'Add Question',
                  style: Constants.textHeading.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: Constants.kPadding,
            ),
            BlocBuilder<CreateQuizCubit, CreateQuizState>(
              builder: (context, state) {
                return state.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Expanded(
                        child: ElevatedButton(
                          onPressed: state.isValid
                              ? () async {
                                  await context
                                      .read<CreateQuizCubit>()
                                      .createQuiz();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                          ),
                          child: Text(
                            'Save',
                            style: Constants.textHeading.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigator(BuildContext context) {
     Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                  value: context.read<CreateQuizCubit>()),
              BlocProvider(
                  create: (_) => FetchUnsplashBloc()
                    ..add(const GetListPhotosEvent())),
            ],
            child: const AddMediaScreen(),
          );
        },
      ),
    );
  }
}

class RainbowContainer extends StatelessWidget {
  const RainbowContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      decoration: BoxDecoration(
        // color: Colors.black26,
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.kPadding),
        ),
        gradient: Constants.sunsetGradient,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined),
          SizedBox(height: Constants.kPadding / 4),
          Text('Tap to add cover image'),
        ],
      ),
    );
  }
}

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
