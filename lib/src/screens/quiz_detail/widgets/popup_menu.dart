import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/modules/profile/cubit/profile_cubit.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class CreateOptionsPopupMenu extends StatelessWidget {
  const CreateOptionsPopupMenu({
    super.key,
    required this.quiz,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text(l10n.share_social_media),
          ),
          PopupMenuItem(
            child: Text(l10n.copy_quiz_link),
          ),
          PopupMenuItem(
            onTap: () {
              context.read<ProfileCubit>().onSaveQuiz(quiz).then((_) {
                context
                    .showSuccessSnackBar(l10n.bookmark_save_quiz_successfully);
              });
            },
            child: Text(l10n.bookmark_save_quiz),
          ),
        ];
      },
    );
  }
}
