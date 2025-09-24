import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/simple_accessibility_settings_widget.dart';
import '../core/accessibility/simple_accessibility_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardsController;
  late AnimationController _toggleController;
  late AnimationController _sliderController;
  late AnimationController _saveButtonController;
  
  late Animation<double> _cardsFade;
  late Animation<Offset> _cardsSlide;
  late Animation<double> _toggleBounce;
  late Animation<double> _sliderBounce;
  late Animation<double> _saveButtonScale;
  late Animation<double> _saveButtonGlow;

  // Settings states
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _autoSaveEnabled = true;
  double _reminderTime = 9.0;

  @override
  void initState() {
    super.initState();
    
    // Initialize accessibility provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        context,
        listen: false,
      );
      accessibilityProvider.init();
    });
    
    // Controller para las tarjetas
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Controller para los toggles
    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Controller para los sliders
    _sliderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Controller para el botón de guardar
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeOutCubic,
    ));
    
    // Animación de bounce para toggles
    _toggleBounce = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _toggleController,
      curve: Curves.elasticOut,
    ));
    
    // Animación de bounce para sliders
    _sliderBounce = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _sliderController,
      curve: Curves.elasticOut,
    ));
    
    // Animación de escala para el botón de guardar
    _saveButtonScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _saveButtonController,
      curve: Curves.easeInOut,
    ));
    
    // Animación de brillo para el botón de guardar
    _saveButtonGlow = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _saveButtonController,
      curve: Curves.easeInOut,
    ));
    
    // Iniciar animación de las tarjetas
    _cardsController.forward();
  }

  @override
  void dispose() {
    _cardsController.dispose();
    _toggleController.dispose();
    _sliderController.dispose();
    _saveButtonController.dispose();
    super.dispose();
  }

  void _onToggleChanged(bool value, String settingName) {
    _toggleController.forward().then((_) {
      _toggleController.reverse();
    });
    
    setState(() {
      switch (settingName) {
        case 'notifications':
          _notificationsEnabled = value;
          break;
        case 'sound':
          _soundEnabled = value;
          break;
        case 'autoSave':
          _autoSaveEnabled = value;
          break;
      }
    });
  }

  void _onSliderChanged(double value, String settingName) {
    _sliderController.forward().then((_) {
      _sliderController.reverse();
    });
    
    setState(() {
      switch (settingName) {
        case 'reminderTime':
          _reminderTime = value;
          break;
      }
    });
  }

  void _onSaveSettings() {
    _saveButtonController.forward().then((_) {
      _saveButtonController.reverse();
    });
    
    // TODO: Implement save settings functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Color(0xFF48BB78),
        duration: Duration(seconds: 2),
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
              Color(0xFFF0F4FF), // Azul muy claro
              Color(0xFFE6E6FA), // Lavanda
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
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
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
                        'Settings',
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
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
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
                  'Customize your MindCompanion experience',
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
              
              // Lista de opciones con animaciones
              Expanded(
                child: SlideTransition(
                  position: _cardsSlide,
                  child: FadeTransition(
                    opacity: _cardsFade,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      children: [
                        _buildSettingsCard(
                          'Notifications',
                          'Receive reminders and updates',
                          Icons.notifications_rounded,
                          const Color(0xFF87CEEB),
                          _buildToggleSwitch(
                            _notificationsEnabled,
                            (value) => _onToggleChanged(value, 'notifications'),
                          ),
                        ),
                        
                        
                        _buildSettingsCard(
                          'Sound Effects',
                          'Enable audio feedback',
                          Icons.volume_up_rounded,
                          const Color(0xFF48BB78),
                          _buildToggleSwitch(
                            _soundEnabled,
                            (value) => _onToggleChanged(value, 'sound'),
                          ),
                        ),
                        
                        _buildSettingsCard(
                          'Auto Save',
                          'Automatically save your entries',
                          Icons.save_rounded,
                          const Color(0xFFED8936),
                          _buildToggleSwitch(
                            _autoSaveEnabled,
                            (value) => _onToggleChanged(value, 'autoSave'),
                          ),
                        ),
                        
                        // Accessibility Settings Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const SimpleAccessibilitySettingsWidget(),
                        ),
                        
                        _buildSettingsCard(
                          'Reminder Time',
                          'Set daily reminder time',
                          Icons.access_time_rounded,
                          const Color(0xFF38B2AC),
                          _buildSlider(
                            _reminderTime,
                            6.0,
                            22.0,
                            '${_reminderTime.round()}:00',
                            (value) => _onSliderChanged(value, 'reminderTime'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botón Save Settings con zoom y efecto de luz
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AnimatedBuilder(
                  animation: _saveButtonController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _saveButtonScale.value,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF48BB78).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: const Color(0xFF48BB78).withOpacity(_saveButtonGlow.value * 0.6),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _onSaveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF48BB78),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Segoe UI',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    String title,
    String description,
    IconData icon,
    Color color,
    Widget child,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icono
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: color,
                      fontFamily: 'Segoe UI',
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
            
            const SizedBox(width: 20),
            
            // Control (toggle o slider)
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(bool value, ValueChanged<bool> onChanged) {
    return AnimatedBuilder(
      animation: _toggleBounce,
      builder: (context, child) {
        return Transform.scale(
          scale: _toggleBounce.value,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF48BB78),
            activeTrackColor: const Color(0xFF48BB78).withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E0),
          ),
        );
      },
    );
  }

  Widget _buildSlider(
    double value,
    double min,
    double max,
    String label,
    ValueChanged<double> onChanged,
  ) {
    return AnimatedBuilder(
      animation: _sliderBounce,
      builder: (context, child) {
        return Transform.scale(
          scale: _sliderBounce.value,
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF48BB78),
                  inactiveTrackColor: const Color(0xFFCBD5E0),
                  thumbColor: const Color(0xFF48BB78),
                  overlayColor: const Color(0xFF48BB78).withOpacity(0.2),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Segoe UI',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
