// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $introScreenRoute,
    ];

RouteBase get $introScreenRoute => GoRouteData.$route(
      path: '/',
      factory: $IntroScreenRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'login',
          factory: $LoginScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'dashboard',
          factory: $DashboardScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'add-transaction',
          factory: $AddTransactionScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'roadmap',
          factory: $RoadmapScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'tag-group',
          factory: $TagGroupScreenRouteExtension._fromState,
        ),
      ],
    );

extension $IntroScreenRouteExtension on IntroScreenRoute {
  static IntroScreenRoute _fromState(GoRouterState state) =>
      const IntroScreenRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginScreenRouteExtension on LoginScreenRoute {
  static LoginScreenRoute _fromState(GoRouterState state) =>
      const LoginScreenRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DashboardScreenRouteExtension on DashboardScreenRoute {
  static DashboardScreenRoute _fromState(GoRouterState state) =>
      const DashboardScreenRoute();

  String get location => GoRouteData.$location(
        '/dashboard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddTransactionScreenRouteExtension on AddTransactionScreenRoute {
  static AddTransactionScreenRoute _fromState(GoRouterState state) =>
      const AddTransactionScreenRoute();

  String get location => GoRouteData.$location(
        '/add-transaction',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RoadmapScreenRouteExtension on RoadmapScreenRoute {
  static RoadmapScreenRoute _fromState(GoRouterState state) =>
      const RoadmapScreenRoute();

  String get location => GoRouteData.$location(
        '/roadmap',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TagGroupScreenRouteExtension on TagGroupScreenRoute {
  static TagGroupScreenRoute _fromState(GoRouterState state) =>
      const TagGroupScreenRoute();

  String get location => GoRouteData.$location(
        '/tag-group',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
