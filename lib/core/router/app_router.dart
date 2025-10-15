import 'package:go_router/go_router.dart';
import 'package:recomiendalo/features/auth/screens/login_screen.dart';
import 'package:recomiendalo/features/auth/screens/register_screen.dart';
import 'package:recomiendalo/features/home/screens/main_screen.dart';
import 'package:recomiendalo/features/jobs/screens/job_create_screen.dart';
import 'package:recomiendalo/features/jobs/screens/job_list_screen.dart';
import 'package:recomiendalo/features/profiles/screens/profile_list_screen.dart';
import 'package:recomiendalo/features/references/screens/reference_list_screen.dart';
import 'package:recomiendalo/features/connect/screens/connect_screen.dart';
import 'package:recomiendalo/core/router/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: AppRoutes.jobsList,
      builder: (context, state) => const JobListScreen(),
    ),
    GoRoute(
      path: AppRoutes.jobsCreate,
      builder: (context, state) => const JobCreateScreen(),
    ),
    GoRoute(
      path: AppRoutes.reviewsEmployer,
      builder: (context, state) => const ReferenceListScreen(),
    ),
    // ---------------------------------------------------------------------------------------Perfil de colaboradores (makers no lo usan)
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileListScreen(),
    ),
    // Conexión rápida solo para empleadores
    GoRoute(
      path: AppRoutes.connect,
      builder: (context, state) => const ConnectScreen(),
    ),
  ],
);
