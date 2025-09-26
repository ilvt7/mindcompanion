import 'package:flutter/material.dart';
// Added for navigation

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _cardsController;
  late AnimationController _iconBounceController;
  late AnimationController _navController;

  late Animation<double> _cardsFade;
  late Animation<Offset> _cardsSlide;
  late Animation<double> _iconBounce;
  late Animation<Color?> _navColor;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Controller para las cards
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller para el bounce de iconos
    _iconBounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Controller para la navegación
    _navController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Animación de fade-in y slide para las cards
    _cardsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.easeOutCubic),
    );

    _cardsSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _cardsController, curve: Curves.easeOutCubic),
        );

    // Animación de bounce para iconos
    _iconBounce = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _iconBounceController, curve: Curves.elasticOut),
    );

    // Animación de color para navegación
    _navColor = ColorTween(
      begin: const Color(0xFFCBD5E0),
      end: const Color(0xFF87CEEB),
    ).animate(CurvedAnimation(parent: _navController, curve: Curves.easeInOut));

    // Iniciar animación de las cards
    _cardsController.forward();
  }

  @override
  void dispose() {
    _cardsController.dispose();
    _iconBounceController.dispose();
    _navController.dispose();
    super.dispose();
  }

  void _onIconTap() {
    _iconBounceController.forward().then((_) {
      _iconBounceController.reverse();
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Animar el cambio de color
    _navController.forward().then((_) {
      _navController.reverse();
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
      case 2:
        // TODO: Navigate to settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isMediumScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, UserName',
                style: TextStyle(
                  fontSize: isSmallScreen ? 28 : 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3748),
                  fontFamily: 'Segoe UI',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How are you feeling today?',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  color: const Color(0xFF718096),
                  fontFamily: 'Segoe UI',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: isSmallScreen ? 32 : 40),
              Expanded(
                child: SlideTransition(
                  position: _cardsSlide,
                  child: FadeTransition(
                    opacity: _cardsFade,
                    child: GridView.count(
                      crossAxisCount: isSmallScreen
                          ? 2
                          : (isMediumScreen ? 2 : 3),
                      crossAxisSpacing: isSmallScreen ? 12 : 20,
                      mainAxisSpacing: isSmallScreen ? 12 : 20,
                      childAspectRatio: isSmallScreen ? 0.85 : 1.0,
                      children: [
                        _buildFeatureCard(
                          context,
                          'Register Emotion',
                          Icons.sentiment_satisfied_alt,
                          const Color(0xFFFFB6C1),
                          () => Navigator.pushNamed(context, '/ai-diary'),
                        ),
                        _buildFeatureCard(
                          context,
                          'Diary',
                          Icons.book_rounded,
                          const Color(0xFF98FB98),
                          () => Navigator.pushNamed(context, '/personal-diary'),
                        ),
                        _buildFeatureCard(
                          context,
                          'Meditations',
                          Icons.self_improvement,
                          const Color(0xFF87CEEB),
                          () => Navigator.pushNamed(context, '/meditations'),
                        ),
                        _buildFeatureCard(
                          context,
                          'Crisis Mode',
                          Icons.emergency,
                          const Color(0xFFE6E6FA),
                          () => Navigator.pushNamed(context, '/crisis'),
                        ),
                        _buildFeatureCard(
                          context,
                          'Transitions',
                          Icons.animation_rounded,
                          const Color(0xFFDDA0DD),
                          () =>
                              Navigator.pushNamed(context, '/transition-demo'),
                        ),
                        _buildFeatureCard(
                          context,
                          'Crisis Transitions',
                          Icons.warning_rounded,
                          const Color(0xFFF56565),
                          () => Navigator.pushNamed(
                            context,
                            '/crisis-transition-demo',
                          ),
                        ),
                        _buildFeatureCard(
                          context,
                          'Settings Transitions',
                          Icons.settings_rounded,
                          const Color(0xFF48BB78),
                          () => Navigator.pushNamed(
                            context,
                            '/settings-transition-demo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
          selectedItemColor: const Color(0xFF87CEEB),
          unselectedItemColor: const Color(0xFFCBD5E0),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: isSmallScreen ? 10 : 12,
          unselectedFontSize: isSmallScreen ? 10 : 12,
          items: [
            BottomNavigationBarItem(
              icon: AnimatedBuilder(
                animation: _navColor,
                builder: (context, child) {
                  return Icon(
                    Icons.home_rounded,
                    size: isSmallScreen ? 20 : 24,
                    color: _currentIndex == 0
                        ? _navColor.value ?? const Color(0xFF87CEEB)
                        : const Color(0xFFCBD5E0),
                  );
                },
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: AnimatedBuilder(
                animation: _navColor,
                builder: (context, child) {
                  return Icon(
                    Icons.history_rounded,
                    size: isSmallScreen ? 20 : 24,
                    color: _currentIndex == 1
                        ? _navColor.value ?? const Color(0xFF87CEEB)
                        : const Color(0xFFCBD5E0),
                  );
                },
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: AnimatedBuilder(
                animation: _navColor,
                builder: (context, child) {
                  return Icon(
                    Icons.settings_rounded,
                    size: isSmallScreen ? 20 : 24,
                    color: _currentIndex == 2
                        ? _navColor.value ?? const Color(0xFF87CEEB)
                        : const Color(0xFFCBD5E0),
                  );
                },
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _onIconTap,
              child: AnimatedBuilder(
                animation: _iconBounce,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconBounce.value,
                    child: Container(
                      width: isSmallScreen ? 60 : 70,
                      height: isSmallScreen ? 60 : 70,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 16 : 20,
                        ),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: isSmallScreen ? 28 : 35,
                        color: color,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
                fontFamily: 'Segoe UI',
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getCardDescription(title),
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                color: color.withOpacity(0.7),
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getCardDescription(String title) {
    switch (title) {
      case 'Register Emotion':
        return 'Track your mood';
      case 'Diary':
        return 'Write your thoughts';
      case 'Meditations':
        return 'Find peace';
      case 'Crisis Mode':
        return 'Get help now';
      case 'Transitions':
        return 'See animations';
      default:
        return '';
    }
  }
}
