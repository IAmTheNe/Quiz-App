import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/constants/constants.dart';

import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';
import 'package:whizz/src/features/auth/data/bloc/register/signup_cubit.dart';
import 'package:whizz/src/features/auth/data/bloc/verify_email/verify_email_cubit.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/ui/login/login_screen.dart';
import 'package:whizz/src/gen/fonts.gen.dart';
import 'package:whizz/src/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(AuthenticationRepository())),
        BlocProvider(create: (_) => SignUpCubit(AuthenticationRepository())),
        BlocProvider(
            create: (_) => VerifyEmailCubit(AuthenticationRepository())),
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
              seedColor: Constants.primaryColor,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}
