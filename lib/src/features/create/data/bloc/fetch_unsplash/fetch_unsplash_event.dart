part of 'fetch_unsplash_bloc.dart';

sealed class FetchUnsplashEvent {
  const FetchUnsplashEvent();
}

base class GetListPhotosEvent implements FetchUnsplashEvent {
  const GetListPhotosEvent();
}
