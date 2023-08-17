import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';

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
        body: Column(
          children: [
            const TabBar(
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
                padding: const EdgeInsets.all(AppConstant.kPadding),
                child: TabBarView(
                  children: [
                    //! Tab 1
                    Column(
                      children: [
                        const Spacer(),
                        const Align(
                          alignment: Alignment.center,
                          child: Pinput(
                            autofocus: true,
                            length: 6,
                          ),
                        ),
                        const Spacer(),
                        CustomButton(onPressed: () {}, label: 'Join'),
                        const Spacer(),
                      ],
                    ),

                    //! Tab 2
                    const Center(
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
