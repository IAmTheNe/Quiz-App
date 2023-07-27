import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/constants/constants.dart';

import 'package:whizz/src/gen/fonts.gen.dart';
import 'package:whizz/src/modules/auth/bloc/auth_bloc.dart';
import 'package:whizz/src/modules/media/bloc/online_media_bloc.dart';
import 'package:whizz/src/router/app_router.dart';

import 'package:whizz/src/modules/collection/bloc/quiz_collection_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => OnlineMediaBloc()..add(const GetListPhotosEvent())),
        BlocProvider(
            create: (_) => QuizCollectionBloc()..add(const GetDataEvent())),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp.router(
          title: 'Quizwhizz',
          debugShowCheckedModeBanner: false,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          theme: ThemeData(
            fontFamily: FontFamily.montserrat,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppConstant.primaryColor,
            ),
            useMaterial3: true,
            platform: TargetPlatform.iOS,
          ),
        ),
      ),
    );
  }
}
