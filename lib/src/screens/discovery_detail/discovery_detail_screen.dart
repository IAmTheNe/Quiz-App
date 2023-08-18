import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class DiscoveryDetailScreen extends StatelessWidget {
  const DiscoveryDetailScreen({
    super.key,
    required this.quizCollection,
  });

  final QuizCollection quizCollection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizCollection.name),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: context
            .read<QuizCollectionCubit>()
            .onGetQuizByCollectionId(quizCollection.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouterPath.quizDetail.name,
                      pathParameters: {'id': snapshot.data![index].id},
                      extra: snapshot.data![index],
                    );
                  },
                  child: ListTile(
                    leading: ImageCover(
                      media: snapshot.data![index].media,
                      isPreview: true,
                    ),
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].author.name ?? ''),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Empty page'),
            );
          }
        },
      ),
    );
  }
}
