import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinput/pinput.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join quiz'),
        ),
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.numbers),
                ),
                Tab(
                  icon: Icon(Icons.qr_code),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppConstant.kPadding),
                child: TabBarView(
                  children: [
                    //! Tab 1
                    InputCodeScreen(),

                    //! Tab 2
                    Center(
                      child: Text('Tab 2'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputCodeScreen extends HookWidget {
  const InputCodeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController();
    return Column(
      children: [
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Pinput(
            controller: pinController,
            autofocus: true,
            length: 6,
          ),
        ),
        const Spacer(),
        CustomButton(
            onPressed: () {
              context.read<LobbyCubit>().enterRoom(context, pinController.text);
            },
            label: 'Join'),
        const Spacer(),
      ],
    );
  }
}
