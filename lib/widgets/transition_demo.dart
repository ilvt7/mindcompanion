import 'package:flutter/material.dart';
import 'custom_page_transitions.dart';
import '../config/transition_config.dart';

/// Widget de demostración para mostrar todas las transiciones disponibles
class TransitionDemo extends StatelessWidget {
  const TransitionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transiciones Personalizadas'),
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFE6E6FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tipos de Transiciones',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prueba las diferentes transiciones entre pantallas',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF718096).withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),
                
                Expanded(
                  child: ListView(
                    children: [
                      _buildTransitionCard(
                        context,
                        'Pantallas Principales',
                        'Slide lateral suave',
                        Icons.swap_horiz,
                        const Color(0xFF87CEEB),
                        () => _showTransitionInfo(context, 'main'),
                      ),
                      
                      _buildTransitionCard(
                        context,
                        'Pantallas Secundarias',
                        'Fade-in desde abajo',
                        Icons.keyboard_arrow_up,
                        const Color(0xFF9F7AEA),
                        () => _showTransitionInfo(context, 'secondary'),
                      ),
                      
                      _buildTransitionCard(
                        context,
                        'Welcome Screen',
                        'Fade-in con escala',
                        Icons.home,
                        const Color(0xFF48BB78),
                        () => _showTransitionInfo(context, 'welcome'),
                      ),
                      
                      _buildTransitionCard(
                        context,
                        'Crisis Mode',
                        'Transición rápida',
                        Icons.emergency,
                        const Color(0xFFF56565),
                        () => _showTransitionInfo(context, 'crisis'),
                      ),
                      
                      _buildTransitionCard(
                        context,
                        'Transición Personalizada',
                        'Configuración avanzada',
                        Icons.tune,
                        const Color(0xFFED8936),
                        () => _showTransitionInfo(context, 'custom'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Botón para probar transición personalizada
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _testCustomTransition(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48BB78),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Probar Transición Personalizada',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransitionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
        trailing: Icon(
          Icons.info_outline,
          color: color.withOpacity(0.6),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showTransitionInfo(BuildContext context, String type) {
    String title = '';
    String description = '';
    String duration = '';
    String curve = '';
    
    switch (type) {
      case 'main':
        title = 'Pantallas Principales';
        description = 'Slide lateral suave para navegación entre pantallas principales como Home, Diary, Meditations, etc.';
        duration = '${TransitionConfig.mainScreenTransition.inMilliseconds}ms';
        curve = 'easeInOutCubic';
        break;
      case 'secondary':
        title = 'Pantallas Secundarias';
        description = 'Fade-in desde abajo para pantallas de configuración y políticas.';
        duration = '${TransitionConfig.secondaryScreenTransition.inMilliseconds}ms';
        curve = 'easeOutCubic';
        break;
      case 'welcome':
        title = 'Welcome Screen';
        description = 'Fade-in completo con escala para la pantalla de bienvenida.';
        duration = '${TransitionConfig.welcomeTransition.inMilliseconds}ms';
        curve = 'easeInOutCubic';
        break;
      case 'crisis':
        title = 'Crisis Mode';
        description = 'Transición rápida para acceso inmediato al modo de crisis.';
        duration = '${TransitionConfig.crisisTransition.inMilliseconds}ms';
        curve = 'easeIn';
        break;
      case 'custom':
        title = 'Transición Personalizada';
        description = 'Configuración avanzada con parámetros personalizables.';
        duration = 'Configurable';
        curve = 'Configurable';
        break;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 16),
            Text('Duración: $duration'),
            Text('Curva: $curve'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _testCustomTransition(BuildContext context) {
    // Crear una pantalla de prueba
    final testPage = Scaffold(
      appBar: AppBar(
        title: const Text('Transición Personalizada'),
        backgroundColor: const Color(0xFFED8936),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFB6C1),
              Color(0xFFDDA0DD),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                '¡Transición Personalizada!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Esta pantalla usa una transición\ncompletamente personalizada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    // Navegar con transición personalizada
    CustomNavigator.pushWithCustomTransition(
      context,
      testPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      slideOffset: const Offset(0.0, -0.5),
      scaleStart: 0.8,
      useFade: true,
      useSlide: true,
      useScale: true,
    );
  }
}
