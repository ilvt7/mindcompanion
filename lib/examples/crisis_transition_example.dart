import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/crisis_mode_screen.dart';
import '../widgets/crisis_transition_wrapper.dart';
import '../config/crisis_transition_config.dart';

/// Ejemplo de implementación de transiciones coordinadas de modo crisis
/// Muestra cómo usar los wrappers para crear transiciones suaves entre pantallas
class CrisisTransitionExample extends StatefulWidget {
  const CrisisTransitionExample({super.key});

  @override
  State<CrisisTransitionExample> createState() => _CrisisTransitionExampleState();
}

class _CrisisTransitionExampleState extends State<CrisisTransitionExample>
    with TickerProviderStateMixin {
  bool _showCrisis = false;
  bool _isTransitioning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text(
          'Crisis Transition Demo',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w700,
            fontFamily: 'Segoe UI',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Controles de demostración
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Controles de Transición',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showCrisis ? null : _startCrisisTransition,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF56565),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Iniciar Crisis'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: !_showCrisis ? null : _stopCrisisTransition,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF48BB78),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Detener Crisis'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Estado: ${_showCrisis ? "Crisis Activo" : "Normal"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _showCrisis ? const Color(0xFFF56565) : const Color(0xFF48BB78),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Área de demostración de transición
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CrisisTransitionCoordinator(
                    homeScreen: _buildHomeScreenPreview(),
                    crisisScreen: _buildCrisisScreenPreview(),
                    showCrisis: _showCrisis,
                    onTransitionComplete: _onTransitionComplete,
                    transitionDuration: CrisisTransitionConfig.totalTransitionDuration,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreenPreview() {
    return Container(
      color: const Color(0xFFF8F9FF),
      child: Column(
        children: [
          // Header del HomeScreen
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Bienvenido de vuelta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Cómo te sientes hoy?',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF2D3748).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // Tarjetas de características
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    'Diario AI',
                    Icons.psychology,
                    const Color(0xFF87CEEB),
                  ),
                  _buildFeatureCard(
                    'Diario Personal',
                    Icons.book,
                    const Color(0xFFE6E6FA),
                  ),
                  _buildFeatureCard(
                    'Meditaciones',
                    Icons.self_improvement,
                    const Color(0xFF98FB98),
                  ),
                  _buildFeatureCard(
                    'Historial',
                    Icons.timeline,
                    const Color(0xFFFFB6C1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisScreenPreview() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header del CrisisModeScreen
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF56565).withOpacity(0.08),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF56565).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF56565).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Color(0xFFF56565),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'Modo Crisis Activado',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Botones de crisis con animaciones secuenciales
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: CrisisButtonsSequentialWrapper(
                isTransitioning: _isTransitioning,
                transitionDuration: CrisisTransitionConfig.buttonIndividualDuration,
                children: [
                  _buildCrisisButton(
                    'Contactar Ayuda',
                    Icons.phone,
                    const Color(0xFFFFB6C1),
                  ),
                  _buildCrisisButton(
                    'Respiración',
                    Icons.air,
                    const Color(0xFF87CEEB),
                  ),
                  _buildCrisisButton(
                    'Ejercicios',
                    Icons.fitness_center,
                    const Color(0xFF98FB98),
                  ),
                  _buildCrisisButton(
                    'Recursos',
                    Icons.help,
                    const Color(0xFFE6E6FA),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisButton(String title, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: color.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  void _startCrisisTransition() {
    setState(() {
      _showCrisis = true;
      _isTransitioning = true;
    });
  }

  void _stopCrisisTransition() {
    setState(() {
      _showCrisis = false;
      _isTransitioning = false;
    });
  }

  void _onTransitionComplete() {
    setState(() {
      _isTransitioning = false;
    });
  }
}

/// Ejemplo simplificado de uso del wrapper de transición
class SimpleCrisisTransitionExample extends StatefulWidget {
  const SimpleCrisisTransitionExample({super.key});

  @override
  State<SimpleCrisisTransitionExample> createState() => _SimpleCrisisTransitionExampleState();
}

class _SimpleCrisisTransitionExampleState extends State<SimpleCrisisTransitionExample> {
  bool _showCrisis = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text('Crisis Transition Simple'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Botón de control
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showCrisis = !_showCrisis;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showCrisis ? const Color(0xFF48BB78) : const Color(0xFFF56565),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _showCrisis ? 'Ocultar Crisis' : 'Mostrar Crisis',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Área de demostración
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: CrisisTransitionWrapper(
                  isTransitioning: _showCrisis,
                  onTransitionComplete: () {
                    print('Transición de crisis completada');
                  },
                  child: _buildHomeScreenPreview(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreenPreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 64,
              color: Color(0xFF87CEEB),
            ),
            SizedBox(height: 16),
            Text(
              'HomeScreen Preview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Este es el HomeScreen que se animará\ncon slide hacia arriba y blur',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
