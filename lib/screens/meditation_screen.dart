import 'package:flutter/material.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardsController;
  late AnimationController _iconBounceController;
  late AnimationController _startButtonController;
  
  late Animation<double> _cardsFade;
  late Animation<Offset> _cardsSlide;
  late Animation<double> _iconBounce;
  late Animation<double> _startButtonScale;

  final List<Map<String, dynamic>> _meditations = [
    {
      'title': 'Breathing Calm',
      'description': '5-minute guided breathing for instant relaxation',
      'duration': '5 min',
      'icon': Icons.air_rounded,
      'color': const Color(0xFFE6E6FA), // Lavanda
      'level': 'Beginner',
    },
    {
      'title': 'Mindful Moments',
      'description': '10-minute mindfulness practice for daily peace',
      'duration': '10 min',
      'icon': Icons.self_improvement_rounded,
      'color': const Color(0xFF87CEEB), // Azul claro
      'level': 'Beginner',
    },
    {
      'title': 'Deep Relaxation',
      'description': '15-minute deep relaxation for stress relief',
      'duration': '15 min',
      'icon': Icons.nights_stay_rounded,
      'color': const Color(0xFF98FB98), // Verde pastel
      'level': 'Intermediate',
    },
    {
      'title': 'Loving Kindness',
      'description': '20-minute compassion meditation for inner peace',
      'duration': '20 min',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFFFB6C1), // Rosa pastel
      'level': 'Intermediate',
    },
    {
      'title': 'Body Scan',
      'description': '25-minute body awareness for deep relaxation',
      'duration': '25 min',
      'icon': Icons.accessibility_new_rounded,
      'color': const Color(0xFFDDA0DD), // Ciruela
      'level': 'Advanced',
    },
    {
      'title': 'Zen Focus',
      'description': '30-minute concentration meditation for clarity',
      'duration': '30 min',
      'icon': Icons.psychology_rounded,
      'color': const Color(0xFFB0E0E6), // Azul polvo
      'level': 'Advanced',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Controller para las tarjetas
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Controller para el bounce de iconos
    _iconBounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Controller para el botón de inicio
    _startButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Animación de fade-in y slide para las tarjetas
    _cardsFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeOutCubic,
    ));
    
    _cardsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeOutCubic,
    ));
    
    // Animación de bounce para iconos
    _iconBounce = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _iconBounceController,
      curve: Curves.elasticOut,
    ));
    
    // Animación de escala para el botón de inicio
    _startButtonScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _startButtonController,
      curve: Curves.easeInOut,
    ));
    
    // Iniciar animación de las tarjetas
    _cardsController.forward();
  }

  @override
  void dispose() {
    _cardsController.dispose();
    _iconBounceController.dispose();
    _startButtonController.dispose();
    super.dispose();
  }

  void _onIconTap() {
    _iconBounceController.forward().then((_) {
      _iconBounceController.reverse();
    });
  }

  void _onStartMeditation(Map<String, dynamic> meditation) {
    _startButtonController.forward().then((_) {
      _startButtonController.reverse();
    });
    
    // TODO: Implement meditation functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${meditation['title']}...'),
        backgroundColor: meditation['color'],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6E6FA), // Lavanda
              Color(0xFF87CEEB), // Azul claro
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar personalizado
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        'Meditations',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Segoe UI',
                          fontSize: 28,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.self_improvement_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Subtítulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Find your inner peace with guided meditations',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Lista de meditaciones con animaciones
              Expanded(
                child: SlideTransition(
                  position: _cardsSlide,
                  child: FadeTransition(
                    opacity: _cardsFade,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: _meditations.length,
                      itemBuilder: (context, index) {
                        final meditation = _meditations[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: meditation['color'].withOpacity(0.2),
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
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Icono con micro-bounce
                                    GestureDetector(
                                      onTap: _onIconTap,
                                      child: AnimatedBuilder(
                                        animation: _iconBounce,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _iconBounce.value,
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: meditation['color'].withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: meditation['color'].withOpacity(0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Icon(
                                                meditation['icon'],
                                                color: meditation['color'],
                                                size: 30,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    
                                    const SizedBox(width: 20),
                                    
                                    // Información de la meditación
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            meditation['title'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: meditation['color'],
                                              fontFamily: 'Segoe UI',
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            meditation['description'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xFF718096),
                                              fontFamily: 'Segoe UI',
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Información adicional y botón
                                Row(
                                  children: [
                                    // Duración y nivel
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                              size: 16,
                                              color: meditation['color'].withOpacity(0.7),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              meditation['duration'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: meditation['color'],
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Segoe UI',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: meditation['color'].withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: meditation['color'].withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            meditation['level'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: meditation['color'],
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Segoe UI',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const Spacer(),
                                    
                                    // Botón Start Meditation con zoom
                                    AnimatedBuilder(
                                      animation: _startButtonScale,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _startButtonScale.value,
                                          child: ElevatedButton(
                                            onPressed: () => _onStartMeditation(meditation),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: meditation['color'],
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: const Text(
                                              'Start',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Segoe UI',
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
