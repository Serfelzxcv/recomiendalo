import 'package:go_router/go_router.dart';
import 'package:recomiendalo/features/auth/screens/login_screen.dart';
import 'package:recomiendalo/features/auth/screens/register_screen.dart';
import 'package:recomiendalo/features/home/screens/main_screen.dart';
import 'package:recomiendalo/features/jobs/screens/job_create_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/jobs/create',
      builder: (context, state) => const JobCreateScreen(),
    ),
  ],
);
