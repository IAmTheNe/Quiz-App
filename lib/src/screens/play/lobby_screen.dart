import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({
    super.key,
    this.isSoloMode = true,
  });

  final bool isSoloMode;

  @override
  Widget build(BuildContext context) {
    final title = isSoloMode ? 'Solo Mode' : 'PvP Mode';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<LobbyCubit, Lobby>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppConstant.kPadding * 2),
            child: Column(
              children: [
                Text(
                  state.quiz.title,
                  style: AppConstant.textTitle700.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 4,
                ),
                Text(
                  state.quiz.description ?? '',
                  textAlign: TextAlign.center,
                  style: AppConstant.textSubtitle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.participants.length} participants',
                  style: AppConstant.textTitle700,
                ),
                Wrap(
                  children: state.participants
                      .map((e) => Chip(
                            label: Text(e.participant.name!),
                          ))
                      .toList(),
                ),
                const Spacer(),
                Text(
                  'Game starts in',
                  style: AppConstant.textHeading,
                ),
                Counter(
                  quiz: state.quiz,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Timer? timer;
  int seconds = 5;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer?.cancel();
          context.goNamed(
            RouterPath.playQuiz.name,
            pathParameters: {'id': widget.quiz.id},
            extra: widget.quiz,
          );
        }
      });
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      seconds.toString(),
      style: AppConstant.textHeading.copyWith(
        color: Colors.red,
      ),
    );
  }
}
