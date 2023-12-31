import 'package:flutter/material.dart';
import 'package:gmstest/super_admin/admins.dart';
import 'package:gmstest/views/dashboard.dart';
import 'package:gmstest/views/login.dart';
import 'package:gmstest/views/members.dart';
import 'package:gmstest/views/trainer.dart';
import 'package:gmstest/views/visitors.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case Dashboard.routeName:
        return Dashboard.route();
      case LoginPage.routeName:
        return LoginPage.route();
      case MembersView.membersRouteName:
        return MembersView.memberRoute();
      case VisitorsView.visitorsRouteName:
        return VisitorsView.visitorRoute();
      case TrainerView.trainerRouteName:
        return TrainerView.trainerRoute();
      case AllAdmins.allAdminRouteName:
        return AllAdmins.allAdminsRoute();

      default:
        return Dashboard.route();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const SelectableText('Error'),
        ),
        body: const Center(
          child: SelectableText('Something went wrong!'),
        ),
      ),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
