import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Play'),
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
              child: TabBarView(
                children: [
                  //! Tab 1
                  Center(
                    child: Text('Tab 1'),
                  ),

                  //! Tab 2
                  Center(
                    child: Text('Tab 2'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
