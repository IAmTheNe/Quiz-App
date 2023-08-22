import 'package:flutter/material.dart';

class CreateOptionsPopupMenu extends StatelessWidget {
  const CreateOptionsPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            child: Text('Share to Social Media'),
          ),
          const PopupMenuItem(
            child: Text('Copy Quiz Link'),
          ),
          const PopupMenuItem(
            child: Text('Save quiz'),
          ),
        ];
      },
    );
  }
}
