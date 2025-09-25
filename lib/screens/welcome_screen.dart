import 'package:flutter/material.dart';
import 'dart:ui'; // Added for ImageFilter
import 'dart:async'; // Added for Timer
import '../config/opening_transition_config.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _illustrationController;
  late AnimationController _buttonsController;
  late AnimationController _backgroundController;
  late AnimationController _transitionController;
  
  Timer? _illustrationTimer;
  Timer? _buttonsTimer;
  
  late Animation<double> _illustrationFade;
  late Animation<Offset> _illustrationSlide;
  late Animation<double> _buttonsScale;
  late Animation<double> _buttonsFade;
  late Animation<double> _backgroundBlur;
  late Animation<double> _backgroundFade;
  late Animation<Offset> _homeSlide;
  late Animation<double> _homeFade;

  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    // Controller para la ilustración principal
    _illustrationController = AnimationController(
      duration: OpeningTransitionConfig.illustrationEntrance,
      vsync: this,
    );
    
    // Controller para los botones
    _buttonsController = AnimationController(
      duration: OpeningTransitionConfig.buttonsEntrance,
      vsync: this,
    );
    
    // Controller para el fondo
    _backgroundController = AnimationController(
      duration: OpeningTransitionConfig.backgroundTransition,
      vsync: this,
    );
    
    // Controller para la transición
    _transitionController = AnimationController(
      duration: OpeningTransitionConfig.homeScreenTransition,
      vsync: this,
    );
    
    // Animación de fade-in y slide para la ilustración
    _illustrationFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _illustrationController,
      curve: OpeningTransitionConfig.entranceCurve,
    ));
    
    _illustrationSlide = Tween<Offset>(
      begin: OpeningTransitionConfig.illustrationSlideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _illustrationController,
      curve: OpeningTransitionConfig.entranceCurve,
    ));
    
    // Animación de zoom y fade para los botones
    _buttonsScale = Tween<double>(
      begin: 1.0,
      end: OpeningTransitionConfig.maxButtonScale,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: OpeningTransitionConfig.buttonScaleCurve,
    ));
    
    _buttonsFade = Tween<double>(
      begin: 1.0,
      end: OpeningTransitionConfig.minButtonOpacity,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: OpeningTransitionConfig.buttonFadeCurve,
    ));
    
    // Animación de blur y fade para el fondo
    _backgroundBlur = Tween<double>(
      begin: 0.0,
      end: OpeningTransitionConfig.maxBlurRadius,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: OpeningTransitionConfig.transitionCurve,
    ));
    
    _backgroundFade = Tween<double>(
      begin: OpeningTransitionConfig.backgroundFadeStart,
      end: OpeningTransitionConfig.backgroundFadeEnd,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: OpeningTransitionConfig.transitionCurve,
    ));
    
    // Animación de slide y fade para HomeScreen
    _homeSlide = Tween<Offset>(
      begin: OpeningTransitionConfig.homeScreenSlideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: OpeningTransitionConfig.overlayCurve,
    ));
    
    _homeFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: OpeningTransitionConfig.overlayCurve,
    ));
    
    // Iniciar animaciones de entrada
    _startEntranceAnimations();
  }

  @override
  void dispose() {
    _illustrationTimer?.cancel();
    _buttonsTimer?.cancel();
    _illustrationController.dispose();
    _buttonsController.dispose();
    _backgroundController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _startEntranceAnimations() {
    // Secuencia de animaciones de entrada
    _illustrationTimer = Timer(OpeningTransitionConfig.illustrationDelay, () {
      if (mounted) {
        _illustrationController.forward();
      }
    });
    
    _buttonsTimer = Timer(OpeningTransitionConfig.buttonsDelay, () {
      if (mounted) {
        _buttonsController.forward();
      }
    });
  }

  void _startTransitionToHome() {
    if (_isTransitioning) return;
    
    setState(() {
      _isTransitioning = true;
    });
    
    // Secuencia de transición
    _backgroundController.forward().then((_) {
      _transitionController.forward().then((_) {
        // Navegar a HomeScreen
        Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con animación de blur y fade
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF87CEEB).withOpacity(_backgroundFade.value),
                      const Color(0xFFE6E6FA).withOpacity(_backgroundFade.value),
                    ],
                  ),
                ),
                child: ClipRect(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: _backgroundBlur.value,
                      sigmaY: _backgroundBlur.value,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF87CEEB),
                            Color(0xFFE6E6FA),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  
                  // Ilustración principal con animaciones
                  SlideTransition(
                    position: _illustrationSlide,
                    child: FadeTransition(
                      opacity: _illustrationFade,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.self_improvement,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Título principal
                  const Text(
                    'Welcome to MindCompanion',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Segoe UI',
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtítulo
                  Text(
                    'Your journey to mental wellness starts here',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Botones con animaciones de zoom y fade
                  AnimatedBuilder(
                    animation: _buttonsController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonsScale.value,
                        child: Opacity(
                          opacity: _buttonsFade.value,
                          child: Column(
                            children: [
                              // Botón Sign Up
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isTransitioning ? null : _startTransitionToHome,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF87CEEB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Segoe UI',
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Botón Log In
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: _isTransitioning ? null : _startTransitionToHome,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Segoe UI',
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Link de Privacy Policy
                  AnimatedBuilder(
                    animation: _buttonsController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _buttonsFade.value,
                        child: GestureDetector(
                          onTap: _isTransitioning ? null : () {
                            Navigator.pushNamed(context, '/privacy-policy');
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ),
        ),
          
          // Overlay de HomeScreen durante la transición
          if (_isTransitioning)
            AnimatedBuilder(
              animation: _transitionController,
              builder: (context, child) {
                return SlideTransition(
                  position: _homeSlide,
                  child: FadeTransition(
                    opacity: _homeFade,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_rounded,
                              size: 80,
                              color: Color(0xFF87CEEB),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Welcome Home',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Your mental wellness journey continues...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF718096),
                                fontFamily: 'Segoe UI',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
