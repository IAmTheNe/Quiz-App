import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/image_cover.dart';
import 'package:whizz/src/modules/play/cubit/play_cubit.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/screens/play_quiz/widgets/choose_tile.dart';

class PlayQuizScreen extends StatefulWidget {
  const PlayQuizScreen({
    super.key,
    required this.quiz,
  });

  final Quiz quiz;

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          print(state);
          return Scaffold(
            body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                itemCount: widget.quiz.questions.length,
                itemBuilder: (context, index) {
                  final currentQuestion = widget.quiz.questions[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppConstant.kPadding),
                    child: Column(
                      children: [
                        AppBar(
                          title: Text(
                            'Question ${index + 1}/${widget.quiz.questions.length}',
                          ),
                          actions: [
                            // Bộ đếm thời gian
                            Counter(
                              duration: currentQuestion.duration ?? 0,
                              quiz: widget.quiz,
                              onNextQuestion: () {
                                if (index < widget.quiz.questions.length - 1) {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                  context.read<GameCubit>().nextQuestion(index);
                                }
                              },
                            ),
                          ],
                          automaticallyImplyLeading: false,
                        ),
                        ImageCover(
                          media: currentQuestion.media,
                          isPreview: true,
                        ),
                        const SizedBox(
                          height: AppConstant.kPadding / 2,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                              const EdgeInsets.all(AppConstant.kPadding / 2),
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxHeight: .08.sh,
                            minHeight: .05.sh,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6d5ff6),
                            borderRadius:
                                BorderRadius.circular(AppConstant.kPadding),
                          ),
                          child: Text(
                            widget.quiz.questions[index].name,
                            style: AppConstant.textSubtitle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: null,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(
                          height: AppConstant.kPadding / 2,
                        ),
                        Expanded(
                          child: ChooseTile(
                            question: widget.quiz.questions[index],
                          ),
                        ),
                        const SizedBox(
                          height: AppConstant.kPadding / 2,
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
      onWillPop: () async => false,
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({
    super.key,
    required this.duration,
    required this.quiz,
    required this.onNextQuestion,
  });

  final int duration;
  final Quiz quiz;
  final VoidCallback onNextQuestion;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Timer? timer;
  int seconds = 0;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
          context.read<GameCubit>().tick(seconds);
        } else {
          timer?.cancel();

          // Delay 3s để show đáp án
          Future.delayed(const Duration(seconds: 3)).then((_) {
            context.read<GameCubit>().tick(-1);

            widget.onNextQuestion();
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    seconds = widget.duration;
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text('$seconds'),
    );
  }
}
