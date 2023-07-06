import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:whizz/src/features/create/data/repositories/unsplash_image_repository.dart';

part 'fetch_unsplash_event.dart';
part 'fetch_unsplash_state.dart';

class FetchUnsplashBloc extends Bloc<FetchUnsplashEvent, FetchUnsplashState> {
  FetchUnsplashBloc({UnsplashImageRepository? imageRepository})
      : _imageRepository = imageRepository ?? UnsplashImageRepository(),
        super(const InitialFetchState()) {
    on(_onGetListPhotos);
  }

  final UnsplashImageRepository _imageRepository;

  Future<void> _onGetListPhotos(
    GetListPhotosEvent event,
    Emitter<FetchUnsplashState> emit,
  ) async {
    emit(const LoadingFetchState());
    final photos = await _imageRepository.loadImages();
    emit(SuccessFetchState(photos));
  }
}
