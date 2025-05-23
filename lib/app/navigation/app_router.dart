import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/user_provider.dart';
import '../../features/auth/domain/models/user_model.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/user_setup_screen.dart';
import '../../features/auth/presentation/screens/invitations_screen.dart';
import '../../features/browse/presentation/screens/browse_units_screen.dart';
import '../../features/dashboard/presentation/screens/employee_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/landlord_dashboard_screen.dart';
import '../../features/dashboard/presentation/widgets/landlord_dashboard_content.dart';
import '../../features/dashboard/presentation/screens/manager_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/tenant_dashboard_screen.dart';
import '../../features/problems/presentation/screens/problem_details_screen.dart';
import '../../features/problems/presentation/screens/problems_list_screen.dart';
import '../../features/problems/presentation/screens/report_problem_screen.dart';
import '../../features/properties/presentation/screens/add_property_screen.dart';
import '../../features/properties/presentation/screens/properties_list_screen.dart';
import '../../features/properties/presentation/screens/property_details_screen.dart';
import '../../features/units/presentation/screens/unit_details_screen.dart';
import '../../features/units/presentation/screens/units_list_screen.dart';
import '../../features/units/presentation/screens/add_unit_screen.dart';
import '../../features/units/presentation/screens/edit_unit_screen.dart';
import '../../features/properties/presentation/screens/edit_property_screen.dart';
import '../../features/payments/presentation/screens/make_payment_screen.dart';
import '../../features/employees/presentation/screens/employees_list_screen.dart';
import '../../features/employees/presentation/screens/handyman_profile_screen.dart';
import '../../features/tenants/presentation/screens/tenants_list_screen.dart';
import '../../features/tenants/presentation/screens/tenant_details_screen.dart';
import '../../features/payments/presentation/screens/finances_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/admin/presentation/screens/admin_approval_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/handyman/presentation/screens/handyman_dashboard_screen.dart';
import '../../features/timesheets/presentation/screens/timesheet_list_screen.dart';
import '../../features/timesheets/presentation/screens/timesheet_entry_screen.dart';
import '../../features/dashboard/presentation/screens/admin_dashboard_screen.dart';

// Helper function to determine dashboard route based on role
String _getDashboardRoute(UserRole? role) {
  switch (role) {
    case UserRole.admin:
      return '/admin';
    case UserRole.landlord:
      return '/landlord';
    case UserRole.tenant:
      return '/tenant';
    case UserRole.employee:
      return '/employee';
    case UserRole.manager:
      return '/manager';
    case UserRole.handyman:
      return '/handyman';
    default:
      return '/browse';
  }
}

// Provider for the app router
final appRouterProvider = Provider<GoRouter>((ref) {
  final userStateNotifier = ValueNotifier<UserState>(const UserLoading());

  ref.listen<AsyncValue<UserState>>(userStateProvider, (_, next) {
    if (next.hasValue) {
      userStateNotifier.value = next.value!;
    } else if (next.hasError) {
      userStateNotifier.value = UserError(next.error.toString());
    } else {
      userStateNotifier.value = const UserLoading();
    }
  });

  return GoRouter(
    refreshListenable: userStateNotifier,
    debugLogDiagnostics: true,
    initialLocation: '/browse',
    routes: [
      // Public Routes
      GoRoute(
        path: '/browse',
        builder: (context, state) => const BrowseUnitsScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/user-setup',
        builder: (context, state) => const UserSetupScreen(),
      ),

      // Tenant Routes
      GoRoute(
        path: '/tenant',
        builder: (context, state) => const TenantDashboardScreen(),
        routes: [
          GoRoute(
            path: 'problems',
            builder: (context, state) => const ProblemsListScreen(),
            routes: [
              GoRoute(
                path: 'report',
                builder: (context, state) {
                  final propertyId = state.uri.queryParameters['propertyId'] ?? '';
                  final unitId = state.uri.queryParameters['unitId'] ?? '';
                  return ReportProblemScreen(propertyId: propertyId, unitId: unitId);
                },
              ),
              GoRoute(
                path: ':problemId',
                builder: (context, state) {
                  final problemId = state.pathParameters['problemId']!;
                  return ProblemDetailsScreen(problemId: problemId);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'make-payment',
            builder: (context, state) {
              final unitId = state.uri.queryParameters['unitId'];
              final propertyId = state.uri.queryParameters['propertyId'];
              final amountString = state.uri.queryParameters['amount'];
              final rentAmount = double.tryParse(amountString ?? '0.0') ?? 0.0;

              if (unitId == null || propertyId == null || unitId.isEmpty || propertyId.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: const Center(child: Text('Missing payment information.')),
                );
              }

              return MakePaymentScreen(
                unitId: unitId,
                propertyId: propertyId,
                rentAmount: rentAmount,
              );
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
    ],

    redirect: (BuildContext context, GoRouterState state) {
      final userStateAsync = ref.read(userStateProvider);
      final activeRole = ref.read(activeRoleProvider);
      final isLoggedIn = userStateAsync.hasValue && userStateAsync.value is UserAuthenticated;
      final path = state.uri.path;

      final publicRoutes = ['/login', '/register', '/forgot-password', '/browse'];
      final isPublicRoute = publicRoutes.contains(path);
      final isSetupRoute = path == '/user-setup';
      final isChatRoute = path.startsWith('/chat');

      if (isChatRoute) return null;

      if (!isLoggedIn) {
        return isPublicRoute ? null : '/browse';
      }

      if (userStateAsync.hasValue && userStateAsync.value is UserAuthenticated) {
        final user = (userStateAsync.value as UserAuthenticated).user;

        if (!user.isSetUp && !isSetupRoute) {
          return '/user-setup';
        }

        if (user.isSetUp && isSetupRoute) {
          return _getDashboardRoute(activeRole);
        }

        if ((isPublicRoute || path == '/') && user.isSetUp) {
          return _getDashboardRoute(activeRole);
        }
      }

      return null;
    },

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Page not found: ${state.error}')),
      );
    },

    observers: [
      NavigatorObserver(),
    ],
  );
});
