import 'package:unsplash_client/unsplash_client.dart';
import 'package:whizz/src/env/env.dart';

class UnsplashImageRepository {
  Future<List<Photo>> loadImages() async {
    final client = UnsplashClient(
      settings: ClientSettings(
        credentials: AppCredentials(
          accessKey: Env.unsplashAccessKey,
          secretKey: Env.unsplashSecretKey,
        ),
      ),
    );
    final photos = await client.photos
        .list(
          page: 1,
          perPage: 10,
        )
        .goAndGet();
    client.close();
    return photos;
  }
}
