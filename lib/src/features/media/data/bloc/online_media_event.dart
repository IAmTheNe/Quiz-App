part of 'online_media_bloc.dart';

sealed class OnlineMediaEvent {
  const OnlineMediaEvent();
}

base class GetListPhotosEvent implements OnlineMediaEvent {
  const GetListPhotosEvent();
}
