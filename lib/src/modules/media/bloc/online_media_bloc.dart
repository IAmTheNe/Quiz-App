import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:whizz/src/features/quiz/data/models/media.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/modules/media/repository/unsplash_image_repository.dart';

part 'online_media_event.dart';
part 'online_media_state.dart';

class OnlineMediaBloc extends Bloc<OnlineMediaEvent, OnlineMediaState> {
  OnlineMediaBloc({UnsplashImageRepository? imageRepository})
      : _imageRepository = imageRepository ?? const UnsplashImageRepository(),
        super(const InitialFetchState()) {
    on(_onGetListPhotos);
    on(_onPop);
  }

  final UnsplashImageRepository _imageRepository;

  void _onGetListPhotos(
    GetListPhotosEvent event,
    Emitter<OnlineMediaState> emit,
  ) async {
    emit(const LoadingFetchState());
    final photos = await _imageRepository.loadImages();
    emit(SuccessFetchState(photos));
  }

  void _onPop(
    PopEvent event,
    Emitter<OnlineMediaState> emit,
  ) {
    final context = event.context;
    final callback = event.callback;

    callback.then(
      (file) {
        if (file != null) {
          context.pop(
            Media(
              imageUrl: file.path,
              type: AttachType.local,
            ),
          );
        }
      },
    );
  }
}
