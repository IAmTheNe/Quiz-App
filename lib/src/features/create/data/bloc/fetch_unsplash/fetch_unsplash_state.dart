part of 'fetch_unsplash_bloc.dart';

sealed class FetchUnsplashState {
  const FetchUnsplashState();
}

base class InitialFetchState implements FetchUnsplashState {
  const InitialFetchState();
}

base class LoadingFetchState implements FetchUnsplashState {
  const LoadingFetchState();
}

base class SuccessFetchState implements FetchUnsplashState {
  const SuccessFetchState(this.photos);

  final List<Photo> photos;
}

base class ErrorFetchState implements FetchUnsplashState {
  const ErrorFetchState();
}
