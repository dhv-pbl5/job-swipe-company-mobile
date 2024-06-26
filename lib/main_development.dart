import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pbl5/app_common_data/common_data/global_key_variable.dart';
import 'package:pbl5/app_common_data/enums/app_language.dart';
import 'package:pbl5/app_common_data/enums/enum.dart';
import 'package:pbl5/app_common_data/themes/app_theme.dart';
import 'package:pbl5/app_common_data/themes/versions/app_theme_data_v1.dart';
import 'package:pbl5/flavor_config.dart';
import 'package:pbl5/locator_config.dart';
import 'package:pbl5/models/app_data.dart';
import 'package:pbl5/routes.dart';
import 'package:pbl5/shared_customization/helpers/utilizations/dio_parse_error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await setupLocator();
  FlavorConfig(
      baseApiUrl: "http://192.168.1.52:8080/api",
      flavor: Flavor.development,
      versionAPI: '/v1');

  // Get system constants
  try {
    getIt.get<AppData>().fetchAllSystemConstants();
  } catch (e) {
    debugPrint(parseError(e));
  }

  runApp(
    AppTheme(
      appThemeData: AppThemeDataV1(),
      child: EasyLocalization(
        supportedLocales:
            AppLanguage.values.map((e) => Locale(e.languageCode)).toList(),
        path: 'assets/translations',
        startLocale: Locale(AppLanguage.en.languageCode),
        fallbackLocale: Locale(AppLanguage.en.languageCode),
        saveLocale: true,
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'Job Swipe For Company',
            debugShowCheckedModeBanner: false,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            navigatorKey: GlobalKeyVariable.navigatorState,
            scaffoldMessengerKey: GlobalKeyVariable.scaffoldMessengerState,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            initialRoute: Routes.splash,
            routes: Routes.routes,
          );
        }),
      ),
    ),
  );
}
