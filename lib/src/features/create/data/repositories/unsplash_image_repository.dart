import 'package:unsplash_client/unsplash_client.dart';
import 'package:whizz/src/env/env.dart';

class UnsplashImageRepository {
  final _client = UnsplashClient(
    settings: ClientSettings(
      credentials: AppCredentials(
        accessKey: Env.unsplashAccessKey,
        secretKey: Env.unsplashSecretKey,
      ),
    ),
  );

  Future<List<Photo>> loadImages({
    int count = 100,
  }) async {
    return await _client.photos
        .random(
          count: 30,
          orientation: PhotoOrientation.landscape,
        )
        .goAndGet();
  }

  void close() {
    _client.close();
  }
}
