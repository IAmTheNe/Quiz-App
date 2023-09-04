import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:whizz/src/env/env.dart';
import 'package:whizz/src/modules/media/models/pexels_photo.dart';

class PexelsRepository {
  const PexelsRepository();

  Future<List<PexelsPhoto>> loadImages() async {
    final List<PexelsPhoto> list = [];
    final responds = await http.get(
      Uri.parse('https://api.pexels.com/v1/curated?per_page=10'),
      headers: {
        HttpHeaders.authorizationHeader: Env.pexelsApiKey,
      },
    );

    final result = jsonDecode(responds.body)['photos'];
    for (int i = 0; i < result.length; i++) {
      list.add(PexelsPhoto.fromMap(result[i]));
    }

    return list;
  }
}
