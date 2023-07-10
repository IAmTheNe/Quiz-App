import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:whizz/src/features/media/data/repositories/unsplash_image_repository.dart';

part 'online_media_event.dart';
part 'online_media_state.dart';

class OnlineMediaBloc extends Bloc<OnlineMediaEvent, OnlineMediaState> {
  OnlineMediaBloc({UnsplashImageRepository? imageRepository})
      : _imageRepository = imageRepository ?? const UnsplashImageRepository(),
        super(const InitialFetchState()) {
    on(_onGetListPhotos);
  }

  final UnsplashImageRepository _imageRepository;

  Future<void> _onGetListPhotos(
    GetListPhotosEvent event,
    Emitter<OnlineMediaState> emit,
  ) async {
    emit(const LoadingFetchState());
    final photos = await _imageRepository.loadImages();
    emit(SuccessFetchState(photos));
  }
}
