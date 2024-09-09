import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:woofriend/features/BL_woofriend/presentation/screens/animal_update_screen.dart';
import 'package:woofriend/features/BL_woofriend/presentation/screens/home_screen.dart';
import 'package:woofriend/features/auth/presentation/screen/screens.dart';

import '../../features/BL_woofriend/presentation/screens/animal_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/petlover',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/foundation',
        builder: (context, state) => const FoundationRegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/animal/:id', // /product/new
        builder: (context, state) => AnimalScreen(
          animalId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),

      GoRoute(
        path: '/animalUpdate/:id', // /product/new
        builder: (context, state) => AnimalUpdateScreen(
          animalId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking)
        return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/petlover' ||
            isGoingTo == '/foundation') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/petlover' ||
            isGoingTo == '/splash' ||
            isGoingTo == '/foundation') {
          return '/';
        }
      }

      return null;
    },
  );
});
