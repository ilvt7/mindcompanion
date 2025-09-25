import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

class CrisisModeScreen extends StatefulWidget {
  const CrisisModeScreen({super.key});

  @override
  State<CrisisModeScreen> createState() => _CrisisModeScreenState();
}

class _CrisisModeScreenState extends State<CrisisModeScreen>
    with TickerProviderStateMixin {
  late AnimationController _crisisInfoController;
  late AnimationController _buttonsController;
  late AnimationController _breathingController;
  late AnimationController _meditationController;
  late AnimationController _comfortAudioController;

  late Animation<double> _crisisInfoFade;
  late Animation<Offset> _crisisInfoSlide;
  late Animation<double> _buttonsFade;
  late Animation<double> _breathingScale;
  late Animation<double> _breathingOpacity;
  late Animation<double> _comfortAudioScale;

  // Breathing exercise state
  bool _isBreathingActive = false;
  bool _isInhaling = true;
  int _breathingCount = 0;

  // Meditation state
  bool _isMeditationActive = false;
  bool _isMeditationAudioPlaying = false;
  final AudioPlayer _meditationAudioPlayer = AudioPlayer();

  // Comfort audio state
  bool _isComfortAudioActive = false;
  bool _isComfortAudioPlaying = false;
  final AudioPlayer _comfortAudioPlayer = AudioPlayer();

  // Emergency contact
  static const String _emergencyNumber = '911';
  static const String _crisisHotline = '988';

  @override
  void initState() {
    super.initState();

    // Controller para la información de crisis
    _crisisInfoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Controller para los botones
    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller para ejercicios de respiración
    _breathingController = AnimationController(
      duration: const Duration(
        milliseconds: 4000,
      ), // 4 seconds per breath cycle
      vsync: this,
    );

    // Controller para meditación
    _meditationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Controller para comfort audio
    _comfortAudioController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animación de fade-in y slide para la información de crisis
    _crisisInfoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _crisisInfoController,
        curve: Curves.easeOutCubic,
      ),
    );

    _crisisInfoSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _crisisInfoController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Animación de fade para los botones
    _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonsController, curve: Curves.easeOutCubic),
    );

    // Animaciones para ejercicios de respiración
    _breathingScale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _breathingOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    // Animación para comfort audio
    _comfortAudioScale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _comfortAudioController, curve: Curves.easeInOut),
    );

    // Configurar listener para el ciclo de respiración
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingCount++;
        _isInhaling = !_isInhaling;
        if (_isBreathingActive) {
          _breathingController.reset();
          _breathingController.forward();
        }
      }
    });

    // Iniciar animaciones secuenciales
    _startCrisisAnimations();
  }

  @override
  void dispose() {
    _crisisInfoController.dispose();
    _buttonsController.dispose();
    _breathingController.dispose();
    _meditationController.dispose();
    _comfortAudioController.dispose();
    _meditationAudioPlayer.dispose();
    _comfortAudioPlayer.dispose();
    super.dispose();
  }

  void _startCrisisAnimations() {
    // Crisis info animation starts first
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _crisisInfoController.forward();
    });

    // Buttons animation starts after crisis info
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _buttonsController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Crisis Mode',
          style: TextStyle(
            color: const Color(0xFF2D3748),
            fontWeight: FontWeight.w700,
            fontFamily: 'Segoe UI',
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF2D3748),
            size: isSmallScreen ? 20 : 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Emergency Phone Icon
          Container(
            margin: EdgeInsets.only(right: isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF56565).withOpacity(0.15),
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              border: Border.all(
                color: const Color(0xFFF56565).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.phone,
                color: const Color(0xFFF56565),
                size: isSmallScreen ? 20 : 22,
              ),
              onPressed: () {
                _makeEmergencyCall(context);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Column(
            children: [
              // Crisis Mode Info
              SlideTransition(
                position: _crisisInfoSlide,
                child: FadeTransition(
                  opacity: _crisisInfoFade,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF56565).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 16 : 20,
                      ),
                      border: Border.all(
                        color: const Color(0xFFF56565).withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF56565).withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF56565).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 14 : 16,
                            ),
                            border: Border.all(
                              color: const Color(0xFFF56565).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: const Color(0xFFF56565),
                            size: isSmallScreen ? 24 : 28,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 16 : 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crisis Mode Activated',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF56565),
                                  fontFamily: 'Segoe UI',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Choose an intervention to help you through this moment',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: const Color(0xFFF56565),
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Crisis Intervention Buttons
              Expanded(
                child: FadeTransition(
                  opacity: _buttonsFade,
                  child: Column(
                    children: [
                      _buildCrisisButton(
                        'Breathing Exercise',
                        Icons.air_rounded,
                        const Color(0xFFFFB6C1), // Rosa pastel
                        'Take deep breaths to calm your mind',
                        () {
                          _startBreathingExercise();
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),

                      _buildCrisisButton(
                        'Quick Meditation',
                        Icons.self_improvement_rounded,
                        const Color(0xFF87CEEB), // Azul pastel
                        '5-minute guided meditation for relief',
                        () {
                          _startMeditation();
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),

                      _buildCrisisButton(
                        'Comfort Audio',
                        Icons.music_note_rounded,
                        const Color(0xFF98FB98), // Verde pastel
                        'Soothing sounds to calm your mind',
                        () {
                          _startComfortAudio();
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),

                      _buildCrisisButton(
                        'Contact Help',
                        Icons.support_agent_rounded,
                        const Color(0xFFE6E6FA), // Lavanda pastel
                        'Connect with crisis counselors',
                        () {
                          _showContactOptions(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startBreathingExercise() {
    setState(() {
      _isBreathingActive = !_isBreathingActive;
      if (_isBreathingActive) {
        _breathingCount = 0;
        _isInhaling = true;
        _breathingController.forward();
      } else {
        _breathingController.stop();
        _breathingController.reset();
      }
    });

    if (_isBreathingActive) {
      _showBreathingDialog();
    }
  }

  void _startMeditation() {
    setState(() {
      _isMeditationActive = !_isMeditationActive;
    });

    if (_isMeditationActive) {
      _playMeditationAudio();
      _showMeditationDialog();
    } else {
      _stopMeditationAudio();
    }
  }

  void _startComfortAudio() {
    setState(() {
      _isComfortAudioActive = !_isComfortAudioActive;
    });

    if (_isComfortAudioActive) {
      _playComfortAudio();
      _showComfortAudioDialog();
    } else {
      _stopComfortAudio();
    }
  }

  Future<void> _playMeditationAudio() async {
    try {
      await _meditationAudioPlayer.play(
        AssetSource('audio/meditation_audio.mp3'),
      );
      setState(() {
        _isMeditationAudioPlaying = true;
      });
    } catch (e) {
      // Audio file not found, show placeholder message
      setState(() {
        _isMeditationAudioPlaying = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Audio file not found. Please add meditation_audio.mp3 to assets/audio/',
            ),
            backgroundColor: Color(0xFF87CEEB),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _playComfortAudio() async {
    try {
      await _comfortAudioPlayer.play(AssetSource('audio/comfort_audio.mp3'));
      setState(() {
        _isComfortAudioPlaying = true;
      });
      // Start comfort audio animation
      _comfortAudioController.repeat();
    } catch (e) {
      // Audio file not found, show placeholder message
      setState(() {
        _isComfortAudioPlaying = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Audio file not found. Please add comfort_audio.mp3 to assets/audio/',
            ),
            backgroundColor: Color(0xFF98FB98),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _stopMeditationAudio() {
    _meditationAudioPlayer.stop();
    setState(() {
      _isMeditationAudioPlaying = false;
    });
  }

  void _stopComfortAudio() {
    _comfortAudioPlayer.stop();
    _comfortAudioController.stop();
    setState(() {
      _isComfortAudioPlaying = false;
    });
  }

  void _showContactOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Contact Help',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Segoe UI',
            ),
          ),
          content: const Text(
            'Choose how you would like to get help:',
            style: TextStyle(fontSize: 16, fontFamily: 'Segoe UI'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _makeEmergencyCall(context);
              },
              child: const Text(
                'Emergency (911)',
                style: TextStyle(
                  color: Color(0xFFF56565),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Segoe UI',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _callCrisisHotline(context);
              },
              child: const Text(
                'Crisis Hotline (988)',
                style: TextStyle(
                  color: Color(0xFF87CEEB),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Segoe UI',
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontFamily: 'Segoe UI',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _callCrisisHotline(BuildContext context) {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Call crisis hotline: 988'),
          backgroundColor: Color(0xFF87CEEB),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      try {
        launchUrl(Uri.parse('tel:$_crisisHotline'));
      } catch (e) {
        Clipboard.setData(ClipboardData(text: _crisisHotline));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Crisis hotline copied to clipboard: $_crisisHotline',
            ),
            backgroundColor: const Color(0xFF87CEEB),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _makeEmergencyCall(BuildContext context) {
    if (kIsWeb) {
      // Web platform - show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Call emergency number'),
          backgroundColor: Color(0xFFF56565),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Mobile platform - open phone dialer
      try {
        launchUrl(Uri.parse('tel:$_emergencyNumber'));
      } catch (e) {
        // Fallback: copy emergency number to clipboard
        Clipboard.setData(ClipboardData(text: _emergencyNumber));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Emergency number copied to clipboard: $_emergencyNumber',
            ),
            backgroundColor: const Color(0xFFF56565),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showBreathingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.air_rounded,
                  color: const Color(0xFFFFB6C1),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Breathing Exercise',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Follow the expanding and contracting circle to breathe slowly and deeply',
                  style: TextStyle(fontSize: 16, fontFamily: 'Segoe UI'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Enhanced breathing circle animation
                AnimatedBuilder(
                  animation: _breathingController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathingScale.value,
                      child: Opacity(
                        opacity: _breathingOpacity.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB6C1).withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFB6C1),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFB6C1).withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _isInhaling ? 'Inhale' : 'Exhale',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFB6C1),
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Breath count: $_breathingCount',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontFamily: 'Segoe UI',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isInhaling
                      ? 'Slowly inhale through your nose'
                      : 'Gently exhale through your mouth',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                    fontFamily: 'Segoe UI',
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isBreathingActive = false;
                  });
                  _breathingController.stop();
                  _breathingController.reset();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Stop Exercise',
                  style: TextStyle(
                    color: Color(0xFFF56565),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMeditationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.self_improvement_rounded,
                  color: const Color(0xFF87CEEB),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Quick Meditation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Find a comfortable position and focus on your breath',
                  style: TextStyle(fontSize: 16, fontFamily: 'Segoe UI'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Enhanced meditation status with audio controls
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87CEEB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF87CEEB).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isMeditationAudioPlaying
                            ? Icons.volume_up
                            : Icons.volume_off,
                        color: const Color(0xFF87CEEB),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isMeditationAudioPlaying
                            ? 'Audio Playing'
                            : 'Audio Stopped',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF87CEEB),
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _isMeditationAudioPlaying
                                ? _stopMeditationAudio
                                : _playMeditationAudio,
                            icon: Icon(
                              _isMeditationAudioPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: const Color(0xFF87CEEB),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _meditationAudioPlayer.seek(Duration.zero);
                            },
                            icon: const Icon(
                              Icons.replay,
                              color: Color(0xFF87CEEB),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Take deep breaths and let your thoughts pass by like clouds',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontFamily: 'Segoe UI',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isMeditationActive = false;
                  });
                  _stopMeditationAudio();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'End Session',
                  style: TextStyle(
                    color: Color(0xFF87CEEB),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showComfortAudioDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.music_note_rounded,
                  color: const Color(0xFF98FB98),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Comfort Audio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Relax and let the soothing sounds wash over you',
                  style: TextStyle(fontSize: 16, fontFamily: 'Segoe UI'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Comfort audio status with animation
                AnimatedBuilder(
                  animation: _comfortAudioController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _comfortAudioScale.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF98FB98).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF98FB98).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _isComfortAudioPlaying
                                  ? Icons.music_note
                                  : Icons.music_off,
                              color: const Color(0xFF98FB98),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isComfortAudioPlaying
                                  ? 'Audio Playing'
                                  : 'Audio Stopped',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF98FB98),
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _isComfortAudioPlaying
                                      ? _stopComfortAudio
                                      : _playComfortAudio,
                                  icon: Icon(
                                    _isComfortAudioPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: const Color(0xFF98FB98),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _comfortAudioPlayer.seek(Duration.zero);
                                  },
                                  icon: const Icon(
                                    Icons.replay,
                                    color: Color(0xFF98FB98),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Close your eyes and focus on the calming sounds',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontFamily: 'Segoe UI',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isComfortAudioActive = false;
                  });
                  _stopComfortAudio();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'End Session',
                  style: TextStyle(
                    color: Color(0xFF98FB98),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCrisisButton(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return StatefulBuilder(
      builder: (context, setInner) {
        double scale = 1.0;
        bool pressed = false;
        return GestureDetector(
          onTapDown: (_) => setInner(() {
            scale = 0.97;
            pressed = true;
          }),
          onTapCancel: () => setInner(() {
            scale = 1.0;
            pressed = false;
          }),
          onTapUp: (_) => setInner(() {
            scale = 1.0;
            pressed = false;
          }),
          onTap: onTap,
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              width: double.infinity,
              padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
                border: Border.all(
                  color: color.withOpacity(pressed ? 0.5 : 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(pressed ? 0.25 : 0.15),
                    blurRadius: pressed ? 26 : 20,
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
              child: Row(
                children: [
                  // Icon Container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    width: isSmallScreen ? 60 : 70,
                    height: isSmallScreen ? 60 : 70,
                    decoration: BoxDecoration(
                      color: color.withOpacity(pressed ? 0.25 : 0.15),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 16 : 20,
                      ),
                      border: Border.all(
                        color: color.withOpacity(pressed ? 0.35 : 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: isSmallScreen ? 32 : 40,
                      color: color,
                    ),
                  ),

                  SizedBox(width: isSmallScreen ? 16 : 20),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.w700,
                            color: color,
                            fontFamily: 'Segoe UI',
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: color.withOpacity(0.8),
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color,
                    size: isSmallScreen ? 18 : 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
