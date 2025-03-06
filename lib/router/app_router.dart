import 'package:testApp/router/app_routes.dart';
import 'package:testApp/screen/home/group/group_page.dart';
import 'package:testApp/screen/home/mot/mot_page.dart';
import 'package:testApp/screen/home/home_page.dart';
import 'package:testApp/screen/home/profile/profile_edit_page.dart';
import 'package:testApp/screen/home/profile/profile_my_page.dart';
import 'package:testApp/screen/home/profile/profile_other_page.dart';
import 'package:testApp/screen/home/search/search_page.dart';
import 'package:testApp/screen/home/search/search_result_page.dart';
import 'package:testApp/screen/home/setting/setting_page.dart';
import 'package:testApp/screen/home/setting/setting_privacy_page.dart';
import 'package:testApp/screen/home/setting/setting_term_page.dart';
import 'package:testApp/screen/lobby/find/find_id_page.dart';
import 'package:testApp/screen/lobby/find/find_page.dart';
import 'package:testApp/screen/lobby/find/find_pw_page.dart';
import 'package:testApp/screen/lobby/find/reset_pw_page.dart';
import 'package:testApp/screen/lobby/identification_page.dart';
import 'package:testApp/screen/lobby/login_page.dart';
import 'package:testApp/screen/lobby/register_page.dart';
import 'package:testApp/screen/lobby/term_page.dart';
import 'package:testApp/screen/splash_page.dart';
import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  static List<Route<dynamic>> routeStack = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute!);
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}

Route getRoute(RouteSettings settings) {
  Map<String, dynamic> arg = settings.arguments == null ? {} : settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case routeSplashPage: return MaterialPageRoute(builder: (_) => const SplashPage());
    case routeHomePage: return MaterialPageRoute(builder: (_) => const HomePage());
    case routeMotPage: return MaterialPageRoute(builder: (_) => const MotPage());
    case routeGroupPage: return MaterialPageRoute(builder: (_) => GroupPage(name: arg['name'], type: arg['type'], code: arg['code']));
    case routeProfileEditPage: return MaterialPageRoute(builder: (_) => ProfileEditPage(user: arg['user']));
    case routeProfileMyPage: return MaterialPageRoute(builder: (_) => const ProfileMyPage());
    case routeProfileOtherPage: return MaterialPageRoute(builder: (_) => ProfileOtherPage(user: arg['user']));
    case routeSearchPage: return MaterialPageRoute(builder: (_) => const SearchPage());
    case routeSearchResultPage: return MaterialPageRoute(builder: (_) => SearchResultPage(keyword: arg['keyword'], batch: arg['batch'], course: arg['course'],));
    case routeSettingPage: return MaterialPageRoute(builder: (_) => const SettingPage());
    case routeSettingPrivacyPage: return MaterialPageRoute(builder: (_) => const SettingPrivacyPage());
    case routeSettingTermPage: return MaterialPageRoute(builder: (_) => const SettingTermPage());
    case routeIdentificationPage: return MaterialPageRoute(builder: (_) => const IdentificationPage());
    case routeLoginPage: return MaterialPageRoute(builder: (_) => const LoginPage());
    case routeRegisterPage: return MaterialPageRoute(builder: (_) => const RegisterPage());
    case routeTermPage: return MaterialPageRoute(builder: (_) => const TermPage());
    case routeFindPage: return MaterialPageRoute(builder: (_) => const FindPage());
    case routeFindIdPage: return MaterialPageRoute(builder: (_) => const FindIdPage());
    case routeFindPwPage: return MaterialPageRoute(builder: (_) => const FindPwPage());
    case routeResetPwPage: return MaterialPageRoute(builder: (_) => ResetPwPage(name: arg['name'], id: arg['id'], type: arg['type']));
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
}