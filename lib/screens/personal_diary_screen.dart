import 'package:flutter/material.dart';
import '../services/diary_storage_service.dart';
import '../models/diary_entry.dart';
import '../widgets/tts_button.dart';

class PersonalDiaryScreen extends StatefulWidget {
  const PersonalDiaryScreen({super.key});

  @override
  State<PersonalDiaryScreen> createState() => _PersonalDiaryScreenState();
}

class _PersonalDiaryScreenState extends State<PersonalDiaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAreaController;
  late AnimationController _saveButtonController;
  late AnimationController _datePickerController;

  late Animation<double> _textAreaFade;
  late Animation<double> _saveButtonScale;
  late Animation<double> _datePickerHeight;
  late Animation<double> _datePickerOpacity;

  final TextEditingController _textController = TextEditingController();
  bool _isDatePickerExpanded = false;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Controller para el área de texto
    _textAreaController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller para el botón de guardar
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Controller para el selector de fecha
    _datePickerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Animación de fade-in para el área de texto
    _textAreaFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAreaController, curve: Curves.easeOutCubic),
    );

    // Animación de escala para el botón de guardar
    _saveButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.easeInOut),
    );

    // Animación de altura para el selector de fecha
    _datePickerHeight = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _datePickerController, curve: Curves.easeInOut),
    );

    // Animación de opacidad para el selector de fecha
    _datePickerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _datePickerController, curve: Curves.easeInOut),
    );

    // Iniciar animación del área de texto
    _textAreaController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textAreaController.dispose();
    _saveButtonController.dispose();
    _datePickerController.dispose();
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
      // Create personal diary entry
      final entry = DiaryEntry.createPersonalEntry(
        text: _textController.text.trim(),
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
              'Personal diary entry saved for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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

  void _onSaveButtonTap() {
    _saveEntry();
  }

  void _toggleDatePicker() {
    setState(() {
      _isDatePickerExpanded = !_isDatePickerExpanded;
    });

    if (_isDatePickerExpanded) {
      _datePickerController.forward();
    } else {
      _datePickerController.reverse();
    }
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
          'Personal Diary',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF87CEEB).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                  border: Border.all(
                    color: const Color(0xFF87CEEB).withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF87CEEB).withOpacity(0.1),
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
                          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF87CEEB).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 14 : 16,
                            ),
                            border: Border.all(
                              color: const Color(0xFF87CEEB).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: const Color(0xFF87CEEB),
                            size: isSmallScreen ? 22 : 26,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 16 : 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Date',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: const Color(0xFF87CEEB),
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2D3748),
                                  fontFamily: 'Segoe UI',
                                ),
                              ),
                            ],
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
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 24 : 32),

              // Text Area with Animation
              Expanded(
                child: FadeTransition(
                  opacity: _textAreaFade,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 16 : 20,
                      ),
                      border: Border.all(
                        color: const Color(0xFF87CEEB).withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF87CEEB).withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText:
                            'Write your thoughts, feelings, and experiences for today...',
                        hintStyle: TextStyle(
                          color: const Color(0xFFA0AEC0),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Segoe UI',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                      ),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontFamily: 'Segoe UI',
                        color: const Color(0xFF2D3748),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
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

              // Save Button with Animation
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
                        onPressed: _isSaving ? null : _onSaveButtonTap,
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
    );
  }

  Widget _buildQuickDateButton(String label, DateTime date) {
    final isSelected =
        date.day == _selectedDate.day &&
        date.month == _selectedDate.month &&
        date.year == _selectedDate.year;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF87CEEB)
              : const Color(0xFFE6E6FA).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF87CEEB)
                : const Color(0xFFE6E6FA).withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9F7AEA),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
