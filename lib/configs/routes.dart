import 'package:flutter/material.dart';
import 'package:gmstest/super_admin/admins.dart';
import 'package:gmstest/super_admin/branch/branch_view.dart';
import 'package:gmstest/super_admin/branch/branches.dart';
import 'package:gmstest/views/dashboards/admin_dashboard.dart';
import 'package:gmstest/views/dashboards/branch/branch_dashboard.dart';
import 'package:gmstest/views/dashboards/dashboard.dart';
import 'package:gmstest/views/expense_tracker.dart';
import 'package:gmstest/views/login.dart';
import 'package:gmstest/views/map_view.dart';
import 'package:gmstest/views/members/member_profile.dart';
import 'package:gmstest/views/members/members.dart';
import 'package:gmstest/views/send_notifications.dart';
import 'package:gmstest/views/trainer.dart';
import 'package:gmstest/views/visitors.dart';
import 'package:gmstest/website/screens/home/home_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case WebsiteHomeScreen.routeName:
        return WebsiteHomeScreen.route();
      case Dashboard.routeName:
        return Dashboard.route();
      case BranchDashboard.routeName:
        return BranchDashboard.route();
      case AdminDashboard.routeName:
        return AdminDashboard.route();
      case ExpenseTrackerView.routeName:
        return ExpenseTrackerView.route();
      case LoginPage.routeName:
        return LoginPage.route();
      case MembersView.membersRouteName:
        return MembersView.memberRoute();
      case VisitorsView.visitorsRouteName:
        return VisitorsView.visitorRoute();
      case MapView.routeName:
        return MapView.mapviewRoute();
      case TrainerView.trainerRouteName:
        return TrainerView.trainerRoute();
      case AllAdmins.allAdminRouteName:
        return AllAdmins.allAdminsRoute();
      case MemberProfile.routeName:
        return MemberProfile.route(settings.arguments);
      case BranchProfile.routeName:
        return BranchProfile.route(settings.arguments);
      case AdminAllBranch.adminAllBranchesRouteName:
        return AdminAllBranch.allAdminsRoute(settings.arguments);
      case SendNotificationView.routeName:
        return SendNotificationView.route(settings.arguments);

      default:
        return WebsiteHomeScreen.route();
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
