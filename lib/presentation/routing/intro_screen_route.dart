part of 'routes.dart';

/// Navigation root
@TypedGoRoute<IntroScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<LoginScreenRoute>(
      path: 'login',
    ),
    TypedGoRoute<DashboardScreenRoute>(
      path: 'dashboard',
    ),
    TypedGoRoute<AddTransactionScreenRoute>(
      path: 'add-transaction',
    ),
    TypedGoRoute<RoadmapScreenRoute>(
      path: 'roadmap',
    ),
    TypedGoRoute<TagGroupScreenRoute>(
      path: 'tag-group',
    ),
  ],
)

/// MainPage route (root)
class IntroScreenRoute extends GoRouteData {
  const IntroScreenRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    return const IntroScreen();
  }
}
