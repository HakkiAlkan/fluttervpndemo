import 'package:flutter/material.dart';
import 'package:fluttervpndemo/core/enum/app_state.dart';
import 'package:fluttervpndemo/core/service/auth_controller/auth_controller.dart';
import 'package:fluttervpndemo/core/service/route/error_view.dart';
import 'package:fluttervpndemo/core/service/route/route_enum.dart';
import 'package:fluttervpndemo/main.dart';
import 'package:fluttervpndemo/ui/views/main/connection/connection_view.dart';
import 'package:fluttervpndemo/ui/views/main/countries/countries_view.dart';
import 'package:fluttervpndemo/ui/views/main/main_view.dart';
import 'package:fluttervpndemo/ui/views/main/settings/settings_view.dart';
import 'package:fluttervpndemo/ui/views/splash/splash_view.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RouteService extends GetxController {
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _countriesViewNavKey = GlobalKey<NavigatorState>(debugLabel: 'countriesView');
  final GlobalKey<NavigatorState> _connectionViewNavKey = GlobalKey<NavigatorState>(debugLabel: 'connectionViewNavKey');
  final GlobalKey<NavigatorState> _settingsNavKey = GlobalKey<NavigatorState>(debugLabel: 'settingsNavKey');

  final authController = Get.find<AuthController>();

  late GoRouter router = GoRouter(
    observers: [CustomNavigatorObserver()],
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: RouteEnum.splashView.path,
    refreshListenable: authController,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteEnum.splashView.path,
        builder: (context, state) {
          return const SplashView();
        },
        redirect: (context, state) {
          if (authController.appState == AppState.ready) return RouteEnum.countriesView.path;
          return null;
        },
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (BuildContext context, GoRouterState state, StatefulNavigationShell body) {
          return FadeTransitionPage(
            key: state.pageKey,
            child: MainView(body),
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _countriesViewNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteEnum.countriesView.path,
                builder: (context, state) {
                  return const CountriesView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _connectionViewNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteEnum.connectionView.path,
                builder: (context, state) {
                  return const ConnectionView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteEnum.settingsView.path,
                builder: (context, state) {
                  return const SettingsView();
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      errorDebugPrint(state.error.toString());
      return ErrorView(state);
    },
  );
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => FadeTransition(
            opacity: animation.drive(_curveTween),
            child: child,
          ),
        );

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    cyaDebugPrint('[Açılan Sayfa] → ${route.settings.name ?? "Root Dizin"}');
    if (previousRoute != null) {
      cyaDebugPrint('[Geldiğim Sayfa] ← ${previousRoute.settings.name ?? "Root Dizin"}');
    } else {
      cyaDebugPrint('[Geldiğim Sayfa] ← Başlangıç noktası');
    }
    cyaDebugPrint('[Bulunduğum Sayfa] 🟢 ${route.settings.name ?? "Root Dizin"}');
  }

  @override
  void didPop(Route<dynamic> route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Kapanan sayfayı izler
    warningDebugPrint('[Kapanan Sayfa] 🔴 ${route.settings.name ?? "Root Dizin"}');

    // Pop işleminden sonra, previousRoute parametresi aslında şu an bulunduğumuz sayfadır
    if (previousRoute != null) {
      warningDebugPrint('[Bulunduğum Sayfa] 🟠 ${previousRoute.settings.name ?? "Root Dizin"}');
    } else {
      warningDebugPrint('[Bulunduğum Sayfa] 🟠 Hiçbir sayfada değiliz (beklenmeyen durum)');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    // Sayfa listeden çıkarıldığında izler
    errorDebugPrint('[Silinen Sayfa] 🟣 ${route.settings.name ?? "Root Dizin"}');

    // Dikkat: Bulunduğum sayfa, silinen sayfa değil, previousRoute olmalı!
    if (previousRoute != null) {
      errorDebugPrint('[Bulunduğum Sayfa] 🟣 ${previousRoute.settings.name ?? "Root Dizin"}');
    } else {
      errorDebugPrint('[Bulunduğum Sayfa] 🟣 Root Dizin');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    // Sayfa değişimlerini izler
    infoDebugPrint('[Değiştirilen Sayfa] 🟡 ${oldRoute?.settings.name ?? "Root Dizin"}');

    // Bulunduğum sayfa
    if (newRoute != null) {
      infoDebugPrint('[Bulunduğum Sayfa] 🟡 ${newRoute.settings.name ?? "Root Dizin"}');
    } else {
      infoDebugPrint('[Bulunduğum Sayfa] 🟡 Bilinmiyor (newRoute null)');
    }
  }
}
