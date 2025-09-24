import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class NavigationService {
  // Standard navigation with FadeThroughTransition
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Push and replace current route with FadeThroughTransition
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // Push and remove all previous routes with FadeThroughTransition
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  // Pop current route
  static void pop<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    Navigator.pop<T>(context, result);
  }

  // Pop until specific route
  static void popUntil(
    BuildContext context,
    bool Function(Route<dynamic>) predicate,
  ) {
    Navigator.popUntil(context, predicate);
  }

  // Custom page route with FadeThroughTransition
  static PageRoute<T> createFadeThroughRoute<T extends Object?>(
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Custom page route with FadeThroughTransition for specific screens
  static PageRoute<T> createMainScreenRoute<T extends Object?>(
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 400),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
  }) {
    return createFadeThroughRoute<T>(
      page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }

  // Custom page route with FadeThroughTransition for secondary screens
  static PageRoute<T> createSecondaryScreenRoute<T extends Object?>(
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 250),
  }) {
    return createFadeThroughRoute<T>(
      page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }

  // Custom page route with FadeThroughTransition for modal screens
  static PageRoute<T> createModalRoute<T extends Object?>(
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 350),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    bool fullscreenDialog = true,
  }) {
    return createFadeThroughRoute<T>(
      page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      fullscreenDialog: fullscreenDialog,
    );
  }

  // Custom page route with FadeThroughTransition for crisis mode
  static PageRoute<T> createCrisisRoute<T extends Object?>(
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 200),
    Duration reverseTransitionDuration = const Duration(milliseconds: 200),
  }) {
    return createFadeThroughRoute<T>(
      page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }

  // Custom page route with FadeThroughTransition for welcome screen
  static PageRoute<T> createWelcomeRoute<T extends Object?>(
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 600),
    Duration reverseTransitionDuration = const Duration(milliseconds: 400),
  }) {
    return createFadeThroughRoute<T>(
      page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }

  // Push with custom FadeThroughTransition route
  static Future<T?> pushWithFadeThrough<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    final route = createFadeThroughRoute<T>(
      page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
    return Navigator.push<T>(context, route);
  }

  // Push main screen with FadeThroughTransition
  static Future<T?> pushMainScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return pushWithFadeThrough<T>(
      context,
      page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Push secondary screen with FadeThroughTransition
  static Future<T?> pushSecondaryScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return pushWithFadeThrough<T>(
      context,
      page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }

  // Push modal screen with FadeThroughTransition
  static Future<T?> pushModalScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return pushWithFadeThrough<T>(
      context,
      page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
    );
  }

  // Push crisis screen with FadeThroughTransition
  static Future<T?> pushCrisisScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return pushWithFadeThrough<T>(
      context,
      page,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  // Push welcome screen with FadeThroughTransition
  static Future<T?> pushWelcomeScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return pushWithFadeThrough<T>(
      context,
      page,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }
}
