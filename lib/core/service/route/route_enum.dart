
enum RouteEnum {
  splashView(path: '/splash'),
  countriesView(path: '/countries'),
  connectionView(path: '/connection'),
  settingsView(path: '/settings');

  const RouteEnum({required this.path});

  final String path;
}
