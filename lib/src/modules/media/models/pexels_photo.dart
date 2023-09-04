import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PexelsPhoto {
  const PexelsPhoto({
    required this.id,
    required this.height,
    required this.width,
    required this.url,
  });

  final int id;
  final int height;
  final int width;
  final String url;

  PexelsPhoto copyWith({
    int? id,
    int? height,
    int? width,
    String? url,
  }) {
    return PexelsPhoto(
      id: id ?? this.id,
      height: height ?? this.height,
      width: width ?? this.width,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'height': height,
      'width': width,
      'url': url,
    };
  }

  factory PexelsPhoto.fromMap(Map<String, dynamic> map) {
    return PexelsPhoto(
      id: map['id'] as int,
      height: map['height'] as int,
      width: map['width'] as int,
      url: map['src']['original'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PexelsPhoto.fromJson(String source) =>
      PexelsPhoto.fromMap(json.decode(source) as Map<String, dynamic>);
}
