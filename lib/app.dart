import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whizz/src/features/auth/data/bloc/auth_cubit.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/ui/auth_screen.dart';
import 'package:whizz/src/gen/colors.gen.dart';
import 'package:whizz/src/gen/fonts.gen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthenticationRepository()))
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          title: 'Quizwhizz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: FontFamily.montserrat,
            colorScheme: ColorScheme.fromSeed(
              seedColor: CustomColors.darkBrown,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: child,
        ),
        child: const AuthScreen(),
      ),
    );
  }
}
