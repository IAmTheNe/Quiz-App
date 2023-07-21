import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/gen/colors.gen.dart';

class Constants {
  static const primaryColor = Palettes.darkBrown;

  static final sunsetGradient = LinearGradient(
    colors: [
      const Color(0xFFFFAFBD).withOpacity(.35),
      const Color(0xFFffc3a0).withOpacity(.35),
    ],
  );

  static const kPadding = 16.0;

  static TextStyle textTitle700 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
  );

  static final textHeading = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
  );

  static final textSubtitle = TextStyle(
    fontSize: 12.sp,
  );
}

final class FirebaseDocumentConstants {
  static const user = 'User';
  static const quiz = 'Quiz';
}

final class ListEnum {
  static final collections = <Collection>[
    Collection.holiday,
    Collection.sports,
    Collection.education,
    Collection.games,
    Collection.art,
    Collection.healthy,
    Collection.foodAndBevarage,
    Collection.lifeStyle,
    Collection.galaxy,
  ];

  static final visibility = <Visible>[
    Visible.public,
    Visible.private,
  ];
}

enum Visible {
  public,
  private,
}

enum Collection {
  holiday,
  sports,
  education,
  games,
  art,
  healthy,
  foodAndBevarage,
  lifeStyle,
  galaxy,
}
