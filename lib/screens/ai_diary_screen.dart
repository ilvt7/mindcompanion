import 'package:flutter/material.dart';
import '../services/diary_storage_service.dart';
import '../models/diary_entry.dart';
import '../widgets/tts_button.dart';

class AIDiaryScreen extends StatefulWidget {
  const AIDiaryScreen({super.key});

  @override
  State<AIDiaryScreen> createState() => _AIDiaryScreenState();
}

class _AIDiaryScreenState extends State<AIDiaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAreaController;
  late AnimationController _microphoneController;
  late AnimationController _emotionCardController;
  late AnimationController _aiRecommendationController;
  late AnimationController _saveButtonController;

  late Animation<double> _textAreaHeight;
  late Animation<double> _microphonePulse;
  late Animation<double> _emotionCardBounce;
  late Animation<double> _aiRecommendationFade;
  late Animation<Offset> _aiRecommendationSlide;
  late Animation<double> _saveButtonScale;

  final TextEditingController _textController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isTextAreaFocused = false;
  bool _isListening = false;
  bool _showEmotionCard = false;
  bool _showAiRecommendation = false;
  bool _isSaving = false;
  String _selectedEmotion = 'Happy'; // Default emotion

  @override
  void initState() {
    super.initState();

    // Controller para el área de texto
    _textAreaController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Controller para el micrófono
    _microphoneController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Controller para la tarjeta de emoción
    _emotionCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Controller para la recomendación IA
    _aiRecommendationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller para el botón guardar
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Animación de altura para el área de texto
    _textAreaHeight = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _textAreaController, curve: Curves.easeInOut),
    );

    // Animación de pulso para el micrófono
    _microphonePulse = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _microphoneController, curve: Curves.easeInOut),
    );

    // Animación de rebote para la tarjeta de emoción
    _emotionCardBounce = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _emotionCardController, curve: Curves.elasticOut),
    );

    // Animación de fade-in para la recomendación IA
    _aiRecommendationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _aiRecommendationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Animación de slide para la recomendación IA
    _aiRecommendationSlide =
        Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _aiRecommendationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Animación de escala para el botón guardar
    _saveButtonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.easeInOut),
    );

    // Simular aparición de tarjetas después de un delay
    _scheduleCardAnimations();
  }

  void _scheduleCardAnimations() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showEmotionCard = true;
        });
        _emotionCardController.forward();

        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showAiRecommendation = true;
            });
            _aiRecommendationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textAreaController.dispose();
    _microphoneController.dispose();
    _emotionCardController.dispose();
    _aiRecommendationController.dispose();
    _saveButtonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF87CEEB),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3748),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something before saving'),
          backgroundColor: Color(0xFFF56565),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Create AI diary entry
      final entry = DiaryEntry.createAIEntry(
        text: _textController.text.trim(),
        emotion: _selectedEmotion,
        date: _selectedDate,
      );

      // Save the entry using the storage service
      final success = await DiaryStorageService.saveEntry(entry);

      if (!success) {
        throw Exception('Failed to save entry');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Entry saved for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
            backgroundColor: const Color(0xFF48BB78),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/emotional-history');
              },
            ),
          ),
        );

        // Clear the text controller
        _textController.clear();

        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving entry: $e'),
            backgroundColor: const Color(0xFFF56565),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _onTextAreaFocus(bool hasFocus) {
    setState(() {
      _isTextAreaFocused = hasFocus;
    });

    if (hasFocus) {
      _textAreaController.forward();
    } else {
      _textAreaController.reverse();
    }
  }

  void _onMicrophoneTap() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _microphoneController.repeat();
    } else {
      _microphoneController.stop();
      _microphoneController.reset();
    }
  }

  void _changeEmotion(String emotion) {
    setState(() {
      _selectedEmotion = emotion;
      _showEmotionCard = true;
    });
    _emotionCardController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isMediumScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'AI Emotion Diary',
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text Area con animación de expansión
                AnimatedBuilder(
                  animation: _textAreaHeight,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _textAreaHeight.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 16 : 20,
                          ),
                          border: Border.all(
                            color: _isTextAreaFocused
                                ? const Color(0xFF87CEEB)
                                : const Color(0xFFE2E8F0),
                            width: _isTextAreaFocused ? 2.0 : 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isTextAreaFocused
                                  ? const Color(0xFF87CEEB).withOpacity(0.2)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: _isTextAreaFocused ? 25 : 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Date Selector
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 16 : 20,
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF87CEEB).withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    isSmallScreen ? 16 : 20,
                                  ),
                                  topRight: Radius.circular(
                                    isSmallScreen ? 16 : 20,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    color: const Color(0xFF87CEEB),
                                    size: isSmallScreen ? 18 : 20,
                                  ),
                                  SizedBox(width: isSmallScreen ? 8 : 12),
                                  Expanded(
                                    child: Text(
                                      'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                      style: TextStyle(
                                        color: const Color(0xFF87CEEB),
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Segoe UI',
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _selectDate(context),
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: const Color(0xFF87CEEB),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Segoe UI',
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text Field
                            TextField(
                              controller: _textController,
                              maxLines: isSmallScreen ? 5 : 6,
                              onTap: () => _onTextAreaFocus(true),
                              onSubmitted: (_) => _onTextAreaFocus(false),
                              decoration: InputDecoration(
                                hintText:
                                    'Describe how you\'re feeling today...',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFA0AEC0),
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontFamily: 'Segoe UI',
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  isSmallScreen ? 20 : 24,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontFamily: 'Segoe UI',
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // TTS Button for reading the text
                if (_textController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TTSButton(
                      text: _textController.text,
                      label: 'Listen',
                      color: const Color(0xFF87CEEB),
                    ),
                  ),
                ],

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Microphone Button con animación de pulso
                Center(
                  child: AnimatedBuilder(
                    animation: _microphonePulse,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _microphonePulse.value,
                        child: Container(
                          width: isSmallScreen ? 80 : 90,
                          height: isSmallScreen ? 80 : 90,
                          decoration: BoxDecoration(
                            color: _isListening
                                ? const Color(0xFF48BB78)
                                : const Color(0xFF87CEEB),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 40 : 45,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isListening
                                            ? const Color(0xFF48BB78)
                                            : const Color(0xFF87CEEB))
                                        .withOpacity(0.4),
                                blurRadius: _isListening ? 30 : 25,
                                offset: const Offset(0, 12),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _onMicrophoneTap,
                            icon: Icon(
                              _isListening ? Icons.stop : Icons.mic,
                              size: isSmallScreen ? 40 : 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Emotion Detection Result con animación de rebote
                if (_showEmotionCard)
                  AnimatedBuilder(
                    animation: _emotionCardBounce,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _emotionCardBounce.value,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF98FB98).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
                            border: Border.all(
                              color: const Color(0xFF98FB98).withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF98FB98).withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                _selectedEmotion == 'Happy'
                                    ? '😊'
                                    : _selectedEmotion == 'Sad'
                                    ? '😢'
                                    : _selectedEmotion == 'Angry'
                                    ? '😠'
                                    : _selectedEmotion == 'Anxious'
                                    ? '😰'
                                    : _selectedEmotion == 'Excited'
                                    ? '🤩'
                                    : _selectedEmotion == 'Calm'
                                    ? '😌'
                                    : _selectedEmotion == 'Confused'
                                    ? '😕'
                                    : _selectedEmotion == 'Grateful'
                                    ? '🙏'
                                    : '😐',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 40 : 48,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              Text(
                                _selectedEmotion,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 20 : 24,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF48BB78),
                                  fontFamily: 'Segoe UI',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Select Your Emotion',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: const Color(
                                    0xFF48BB78,
                                  ).withOpacity(0.8),
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Emotion selection buttons
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    [
                                          'Happy',
                                          'Sad',
                                          'Angry',
                                          'Anxious',
                                          'Excited',
                                          'Calm',
                                          'Confused',
                                          'Grateful',
                                        ]
                                        .map(
                                          (emotion) => GestureDetector(
                                            onTap: () =>
                                                _changeEmotion(emotion),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    _selectedEmotion == emotion
                                                    ? const Color(0xFF48BB78)
                                                    : const Color(
                                                        0xFF48BB78,
                                                      ).withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF48BB78,
                                                  ),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Text(
                                                emotion,
                                                style: TextStyle(
                                                  color:
                                                      _selectedEmotion ==
                                                          emotion
                                                      ? Colors.white
                                                      : const Color(0xFF48BB78),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // AI Recommendation Card con animación de fade-in y slide
                if (_showAiRecommendation)
                  SlideTransition(
                    position: _aiRecommendationSlide,
                    child: FadeTransition(
                      opacity: _aiRecommendationFade,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6FA).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 16 : 20,
                          ),
                          border: Border.all(
                            color: const Color(0xFFE6E6FA).withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE6E6FA).withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    isSmallScreen ? 6 : 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF9F7AEA,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 10 : 12,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.lightbulb,
                                    color: const Color(0xFF9F7AEA),
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 12 : 16),
                                Text(
                                  'AI Recommendation',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF9F7AEA),
                                    fontFamily: 'Segoe UI',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Text(
                              'Try a 5-minute breathing exercise to maintain this positive mood!',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: const Color(0xFF9F7AEA),
                                fontFamily: 'Segoe UI',
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: isSmallScreen ? 32 : 40),

                // Save Entry Button
                AnimatedBuilder(
                  animation: _saveButtonScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _saveButtonScale.value,
                      child: Container(
                        width: double.infinity,
                        height: isSmallScreen ? 56 : 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 16 : 20,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF48BB78).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveEntry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF48BB78),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 16 : 20,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  height: isSmallScreen ? 20 : 24,
                                  width: isSmallScreen ? 20 : 24,
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save Entry',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 18 : 20,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
