import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'application.dart';
import 'presentation/app_theme.dart';
import 'presentation/routing/routes.dart';
import 'utils/app_localizations.dart';

// flutter packages pub run build_runner build --delete-conflicting-outputs

void main() async {
  await Application.initialize();
  runApp(const BizApp());
}

class BizApp extends StatelessWidget {
  const BizApp({super.key});

  static final _router = GoRouter(
    routes: $appRoutes,
  );

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Financial Helper',
      theme: appThemeLight,
      darkTheme: appThemeDark,
      debugShowCheckedModeBanner: false,
      // Localization & internationalization
      locale: AppLocalizations.currentLocale.value,
      supportedLocales: AppLocalizations.supportedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      localeResolutionCallback: AppLocalizations.localeResolutionCallback,
    );
  }
}
