import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/play/cubit/play_cubit.dart';
import 'package:whizz/src/modules/quiz/model/question.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';
import 'package:whizz/src/screens/play_quiz/widgets/choose_tile.dart';

class PlayQuizScreen extends StatefulWidget {
  const PlayQuizScreen({
    super.key,
    required this.quiz,
    this.isSoloMode = true,
  });

  final Quiz quiz;
  final bool isSoloMode;

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
          return Scaffold(
            body: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              itemCount: widget.quiz.questions.length * 2 + 1,
              itemBuilder: (context, index) {
                final currentQuestion =
                    widget.quiz.questions[state.currentQuestion];

                if (index.isEven) {
                  if (index == widget.quiz.questions.length * 2) {
                    return widget.isSoloMode
                        ? _buildTotalSoloScorePage()
                        : _buildTotalFriendScorePage();
                  }
                  return _buildQuestionPage(
                      state, currentQuestion, index, context);
                }

                return _buildShowScorePage(index, context);
              },
            ),
          );
        },
      ),
      onWillPop: () async => false,
    );
  }

  Widget _buildTotalFriendScorePage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: BlocBuilder<LobbyCubit, Lobby>(
        builder: (context, state) {
          final rank = context.read<LobbyCubit>().getRank();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: const Text('Leaderboard'),
                automaticallyImplyLeading: false,
              ),
              Center(
                child: Text(
                  'You got rank ${rank + 1}',
                  style: AppConstant.textHeading,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.participants.length > 5
                      ? 5
                      : state.participants.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(state.participants[index].participant.name!),
                      trailing:
                          Text(state.participants[index].score.toString()),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  onPressed: () {
                    context.read<LobbyCubit>().cancel();
                    context.goNamed(RouterPath.home.name);
                  },
                  label: 'Go Back',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalSoloScorePage() {
    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: BlocBuilder<LobbyCubit, Lobby>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: const Text('Leaderboard'),
                automaticallyImplyLeading: false,
              ),
              BlocBuilder<GameCubit, GameState>(
                builder: (context, s) {
                  return Center(
                    child: Text(
                      'You got ${s.score} points',
                      style: AppConstant.textHeading,
                    ),
                  );
                },
              ),
              Expanded(
                child: state.solo.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            state.solo.length > 5 ? 5 : state.solo.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(state.solo[index].participant.name!),
                            subtitle: Text(state.startTime.toString()),
                            trailing: Text(state.solo[index].score.toString()),
                          );
                        },
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Waiting to get leaderboard!'),
                            CircularProgressIndicator.adaptive(),
                          ],
                        ),
                      ),
              ),
              if (state.solo.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onPressed: () {
                      context.goNamed(RouterPath.home.name);
                      context.read<LobbyCubit>().cancel();
                    },
                    label: 'Go Back',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  LeaderboardCountdown _buildShowScorePage(int index, BuildContext context) {
    return LeaderboardCountdown(
      onNextQuestion: () {
        if (index <= (widget.quiz.questions.length - 1) * 2 + 1) {
          if (index <= (widget.quiz.questions.length - 1) * 2) {
            context.read<GameCubit>().nextQuestion();
          } else {
            context.read<LobbyCubit>().soloHistory();
          }
          _controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      },
    );
  }

  Widget _buildQuestionPage(GameState state, Question currentQuestion,
      int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Question ${state.currentQuestion + 1}/${widget.quiz.questions.length}',
            ),
            actions: [
              // Bộ đếm thời gian
              QuestionCountdown(
                duration: currentQuestion.duration ?? 0,
                quiz: widget.quiz,
                onNextQuestion: () {
                  if (index <= (widget.quiz.questions.length - 1) * 2 + 1) {
                    context.read<LobbyCubit>().calculateScore(state.score);
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
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
            padding: const EdgeInsets.all(AppConstant.kPadding / 2),
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: .08.sh,
              minHeight: .05.sh,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF6d5ff6),
              borderRadius: BorderRadius.circular(AppConstant.kPadding),
            ),
            child: Text(
              widget.quiz.questions[state.currentQuestion].name,
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
              question: widget.quiz.questions[state.currentQuestion],
            ),
          ),
          const SizedBox(
            height: AppConstant.kPadding / 2,
          ),
        ],
      ),
    );
  }
}

class LeaderboardCountdown extends StatefulWidget {
  const LeaderboardCountdown({
    super.key,
    required this.onNextQuestion,
  });

  final VoidCallback onNextQuestion;

  @override
  State<LeaderboardCountdown> createState() => _LeaderboardCountdownState();
}

class _LeaderboardCountdownState extends State<LeaderboardCountdown> {
  Timer? timer;
  int seconds = 3;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer?.cancel();
        widget.onNextQuestion();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const Text('Show Score'),
            automaticallyImplyLeading: false,
          ),
          BlocBuilder<LobbyCubit, Lobby>(
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.participants.length > 5
                      ? 5
                      : state.participants.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(state.participants[index].participant.name!),
                      trailing:
                          Text(state.participants[index].score.toString()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuestionCountdown extends StatefulWidget {
  const QuestionCountdown({
    super.key,
    required this.duration,
    required this.quiz,
    required this.onNextQuestion,
  });

  final int duration;
  final Quiz quiz;
  final VoidCallback onNextQuestion;

  @override
  State<QuestionCountdown> createState() => _QuestionCountdownState();
}

class _QuestionCountdownState extends State<QuestionCountdown> {
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

          // Delay 2s để show đáp án
          Future.delayed(const Duration(seconds: 2)).then((_) {
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
