import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttervpndemo/base/init/cache/base_get_storage_helper.dart';
import 'package:fluttervpndemo/base/service/network/network_api_service.dart';
import 'package:fluttervpndemo/core/enum/app_enum.dart';
import 'package:fluttervpndemo/core/enum/shared_preferences_keys.dart';
import 'package:fluttervpndemo/core/repository/login/local/login_local_data_source.dart';
import 'package:fluttervpndemo/core/repository/login/login_repository.dart';
import 'package:fluttervpndemo/core/repository/login/remote/login_remote_data_source.dart';
import 'package:fluttervpndemo/core/service/auth_controller/auth_controller.dart';
import 'package:fluttervpndemo/core/service/bll/app_service.dart';
import 'package:fluttervpndemo/core/service/route/route_service.dart';
import 'package:fluttervpndemo/core/service/theme/theme_manager.dart';
import 'package:fluttervpndemo/core/service/vpn/vpn_service.dart';
import 'package:fluttervpndemo/ui/helper/layout_helper.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  await setUpPrepareApplication();
  runApp(
    Builder(
      builder: (context) {
        LayoutHelper.instance.init(context);
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: false,
      designSize: const Size(360, 800),
      builder: (context, child) => GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), // statik text size
          child: child!,
        ),
      ),
      child: ToastificationWrapper(
        child: Obx(
          () => GetMaterialApp.router(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            debugShowCheckedModeBanner: false,
            title: AppEnums.appTitle,
            theme: Get.find<ThemeManager>().lightTheme,
            darkTheme: Get.find<ThemeManager>().darkTheme,
            themeMode: Get.find<ThemeManager>().themeMode.value,
            routerDelegate: Get.find<RouteService>().router.routerDelegate,
            routeInformationParser: Get.find<RouteService>().router.routeInformationParser,
            routeInformationProvider: Get.find<RouteService>().router.routeInformationProvider,
          ),
        ),
      ),
    );
  }
}

initTheme() async {
  final storageService = Get.find<StorageService>();
  final themeManager = Get.find<ThemeManager>();
  themeManager.initThemeData();
  bool? userDarkTheme = storageService.getBoolValue(PreferencesKeys.isDarkMode.name);
  if (userDarkTheme != null) {
    if (userDarkTheme) {
      themeManager.themeMode.value = ThemeMode.dark;
    } else {
      themeManager.themeMode.value = ThemeMode.light;
    }
  } else {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    themeManager.themeMode.value = (brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark);
  }
  await storageService.setBoolValue(PreferencesKeys.isDarkMode.name, themeManager.themeMode.value == ThemeMode.dark ? true : false);
}

Future<void> setupDI() async {
  //#region services
  Get.put<AppService>(AppService());
  Get.put<ThemeManager>(ThemeManager());
  Get.put<VpnService>(VpnService());
  Get.lazyPut<RouteService>(() => RouteService());
  Get.lazyPut<AuthController>(() => AuthController());
  Get.lazyPut<NetworkApiService>(() => NetworkApiService());
  await Get.putAsync<StorageService>(() async => await StorageService.getInstance());
  //#endregion

  //#region repositories
  Get.lazyPut(() => LoginLocalDataSource());
  Get.lazyPut(() => LoginRemoteDataSource(networkManager: Get.find<NetworkApiService>()));
  Get.lazyPut(() => LoginRepository(local: Get.find<LoginLocalDataSource>(), remote: Get.find<LoginRemoteDataSource>()));
  //#endregion
}

Future<void> setUpPrepareApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await setupDI();
  await initTheme();
}

errorDebugPrint(Object v) => debugPrint('\x1B[31m${v.toString()}\x1B[0m');

warningDebugPrint(Object v) => debugPrint('\x1B[33m${v.toString()}\x1B[0m');

infoDebugPrint(Object v) => debugPrint('\x1B[34m${v.toString()}\x1B[0m');

successDebugPrint(Object v) => debugPrint('\x1B[32m${v.toString()}\x1B[0m');

cyaDebugPrint(Object v) => debugPrint('\x1B[36m${v.toString()}\x1B[0m');

purpleDebugPrint(Object v) => debugPrint('\x1B[35m${v.toString()}\x1B[0m');
