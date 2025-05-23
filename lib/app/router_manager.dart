import 'package:go_router/go_router.dart';
import 'package:note_app/screens/home_page.dart';
import 'package:note_app/screens/login_page.dart';
import 'package:note_app/screens/signup_view.dart';
import 'package:note_app/screens/splash_screen.dart';

class RouteManager {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/logout',
        redirect: (context, state) {
          return '/login';
        },
      ),
    ],
  );
}
