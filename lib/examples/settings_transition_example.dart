import 'package:flutter/material.dart';
import '../widgets/settings_transition_wrapper.dart';
import '../config/settings_transition_config.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

/// Ejemplo de demostración de la transición de configuración
class SettingsTransitionExample extends StatefulWidget {
  const SettingsTransitionExample({super.key});

  @override
  State<SettingsTransitionExample> createState() => _SettingsTransitionExampleState();
}

class _SettingsTransitionExampleState extends State<SettingsTransitionExample> {
  bool _showSettings = false;
  SettingsTransitionSettings _currentSettings = SettingsTransitionSettings.smooth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Transition Demo'),
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Controles de demostración
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configuración de Transición',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Selector de tipo de transición
                DropdownButtonFormField<SettingsTransitionSettings>(
                  value: _currentSettings,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Transición',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: SettingsTransitionSettings.smooth,
                      child: Text('Suave y Elegante'),
                    ),
                    DropdownMenuItem(
                      value: SettingsTransitionSettings.quick,
                      child: Text('Rápida y Directa'),
                    ),
                    DropdownMenuItem(
                      value: SettingsTransitionSettings.dramatic,
                      child: Text('Dramática y Exagerada'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _currentSettings = value;
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Botón para activar transición
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showSettings = !_showSettings;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showSettings ? Colors.orange : const Color(0xFF87CEEB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _showSettings ? 'Ocultar Configuración' : 'Mostrar Configuración',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Vista previa de las pantallas
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // HomeScreen
                    if (!_showSettings)
                      const HomeScreen()
                    else
                      // SettingsScreen con animaciones
                      SettingsScreenWrapper(
                        settings: _currentSettings,
                        child: const SettingsScreen(),
                      ),
                    
                    // Overlay de información
                    if (_showSettings)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Configuración',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
        ],
      ),
    );
  }
}

/// Ejemplo simple de transición de configuración
class SimpleSettingsTransitionExample extends StatelessWidget {
  const SimpleSettingsTransitionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transición Simple'),
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título con animación
            AnimatedTextWrapper(
              delay: SettingsElementsConfig.elementDelays[0],
              child: const Text(
                'Configuración',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF87CEEB),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Subtítulo con animación
            AnimatedTextWrapper(
              delay: SettingsElementsConfig.elementDelays[1],
              child: const Text(
                'Personaliza tu experiencia',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Botones con animación
            AnimatedButtonWrapper(
              delay: SettingsElementsConfig.elementDelays[3],
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEEB),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Configuración General',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            AnimatedButtonWrapper(
              delay: SettingsElementsConfig.elementDelays[4],
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  side: const BorderSide(color: Color(0xFF87CEEB)),
                ),
                child: const Text(
                  'Privacidad',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF87CEEB),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            AnimatedButtonWrapper(
              delay: SettingsElementsConfig.elementDelays[5],
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Acerca de',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF87CEEB),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Controles con animación
            AnimatedControlWrapper(
              delay: SettingsElementsConfig.elementDelays[8],
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Notificaciones'),
                        Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: const Color(0xFF87CEEB),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Modo Oscuro'),
                        Switch(
                          value: false,
                          onChanged: (value) {},
                          activeColor: const Color(0xFF87CEEB),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
