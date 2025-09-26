import 'package:flutter/material.dart';
import '../config/emotional_history_transition_config.dart';
import '../services/diary_storage_service.dart';
import '../models/diary_entry.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

class EmotionalHistoryScreen extends StatefulWidget {
  const EmotionalHistoryScreen({super.key});

  @override
  State<EmotionalHistoryScreen> createState() => _EmotionalHistoryScreenState();
}

class _EmotionalHistoryScreenState extends State<EmotionalHistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _calendarController;
  late AnimationController _entriesController;

  late Animation<double> _calendarFade;
  late Animation<double> _calendarScale;
  late Animation<double> _entriesFade;

  // Filter functionality
  String _selectedFilter = 'All Emotions';
  List<String> _availableEmotions = ['All Emotions'];

  void _updateAvailableEmotions() {
    final emotions = _allEntries
        .where((entry) => entry.emotion != null)
        .map((entry) => entry.emotion!)
        .toSet()
        .toList();

    setState(() {
      _availableEmotions = ['All Emotions', ...emotions];
    });
  }

  // Real entries data
  List<DiaryEntry> _allEntries = [];
  bool _isLoading = true;

  // Calendar state
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<DiaryEntry>> _events = {};

  List<DiaryEntry> get _filteredEntries {
    if (_selectedFilter == 'All Emotions') {
      return _allEntries;
    }
    return _allEntries
        .where((entry) => entry.emotion == _selectedFilter)
        .toList();
  }

  List<DiaryEntry> get _selectedDayEntries {
    if (_selectedDay == null) return [];
    final key = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );
    return _events[key] ?? [];
  }

  // Get recent entries for the list
  List<DiaryEntry> get _recentEntries {
    final sortedEntries = List<DiaryEntry>.from(_allEntries);
    sortedEntries.sort((a, b) => b.date.compareTo(a.date));
    return sortedEntries.take(10).toList(); // Show last 10 entries
  }

  @override
  void initState() {
    super.initState();

    _calendarController = AnimationController(
      duration: EmotionalHistoryTransitionConfig.calendarFadeDuration,
      vsync: this,
    );

    _entriesController = AnimationController(
      duration: EmotionalHistoryTransitionConfig.entriesFadeDuration,
      vsync: this,
    );

    _calendarFade =
        Tween<double>(
          begin: EmotionalHistoryTransitionConfig.calendarFadeStart,
          end: EmotionalHistoryTransitionConfig.calendarFadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _calendarController,
            curve: EmotionalHistoryTransitionConfig.calendarFadeCurve,
          ),
        );

    _calendarScale =
        Tween<double>(
          begin: EmotionalHistoryTransitionConfig.calendarScaleStart,
          end: EmotionalHistoryTransitionConfig.calendarScaleEnd,
        ).animate(
          CurvedAnimation(
            parent: _calendarController,
            curve: EmotionalHistoryTransitionConfig.calendarScaleCurve,
          ),
        );

    _entriesFade =
        Tween<double>(
          begin: EmotionalHistoryTransitionConfig.entriesFadeStart,
          end: EmotionalHistoryTransitionConfig.entriesFadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _entriesController,
            curve: EmotionalHistoryTransitionConfig.entriesFadeCurve,
          ),
        );

    _startSequentialAnimations();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final entries = await DiaryStorageService.getEntries();
      setState(() {
        _allEntries = entries;
        _isLoading = false;
      });
      _organizeEntriesByDate();
      _updateAvailableEmotions();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading entries: $e'),
            backgroundColor: const Color(0xFFF56565),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _organizeEntriesByDate() {
    _events.clear();
    for (final entry in _allEntries) {
      final key = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (_events[key] == null) _events[key] = [];
      _events[key]!.add(entry);
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _entriesController.dispose();
    super.dispose();
  }

  void _startSequentialAnimations() {
    // Calendar animation starts first
    Future.delayed(EmotionalHistoryTransitionConfig.calendarStartDelay, () {
      if (mounted) _calendarController.forward();
    });

    // Entries animation starts after calendar
    Future.delayed(EmotionalHistoryTransitionConfig.entriesStartDelay, () {
      if (mounted) _entriesController.forward();
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      // Clear selected day when filter changes to show all entries
      _selectedDay = null;
    });
  }

  void _clearSelectedDay() {
    setState(() {
      _selectedDay = null;
    });
  }

  // Enhanced emotion emoji mapping
  String _getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
      case 'excited':
        return '😊';
      case 'sad':
      case 'sadness':
      case 'depressed':
        return '😢';
      case 'angry':
      case 'anger':
      case 'frustrated':
        return '😠';
      case 'anxious':
      case 'anxiety':
      case 'worried':
        return '😰';
      case 'calm':
      case 'peaceful':
      case 'relaxed':
        return '😌';
      case 'confused':
      case 'uncertain':
        return '😕';
      case 'grateful':
      case 'thankful':
        return '🙏';
      case 'surprised':
      case 'shocked':
        return '😲';
      case 'tired':
      case 'exhausted':
        return '😴';
      case 'proud':
      case 'accomplished':
        return '😎';
      default:
        return '😐';
    }
  }

  // Enhanced emotion color mapping
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
      case 'excited':
        return const Color(0xFF48BB78); // Green
      case 'sad':
      case 'sadness':
      case 'depressed':
        return const Color(0xFF4299E1); // Blue
      case 'angry':
      case 'anger':
      case 'frustrated':
        return const Color(0xFFF56565); // Red
      case 'anxious':
      case 'anxiety':
      case 'worried':
        return const Color(0xFFED8936); // Orange
      case 'calm':
      case 'peaceful':
      case 'relaxed':
        return const Color(0xFF9F7AEA); // Purple
      case 'confused':
      case 'uncertain':
        return const Color(0xFF718096); // Gray
      case 'grateful':
      case 'thankful':
        return const Color(0xFF38B2AC); // Teal
      case 'surprised':
      case 'shocked':
        return const Color(0xFFECC94B); // Yellow
      case 'tired':
      case 'exhausted':
        return const Color(0xFF805AD5); // Indigo
      case 'proud':
      case 'accomplished':
        return const Color(0xFF319795); // Emerald
      default:
        return const Color(0xFF87CEEB); // Light blue
    }
  }

  // Get emotion description for display
  String _getEmotionDescription(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return 'Feeling joyful';
      case 'sad':
      case 'sadness':
        return 'Feeling down';
      case 'angry':
      case 'anger':
        return 'Feeling angry';
      case 'anxious':
      case 'anxiety':
        return 'Feeling anxious';
      case 'calm':
      case 'peaceful':
        return 'Feeling calm';
      case 'confused':
        return 'Feeling confused';
      case 'grateful':
        return 'Feeling grateful';
      case 'excited':
        return 'Feeling excited';
      case 'surprised':
        return 'Feeling surprised';
      case 'tired':
        return 'Feeling tired';
      case 'proud':
        return 'Feeling proud';
      default:
        return 'Emotional state';
    }
  }

  // Enhanced emotion trend data for chart
  List<FlSpot> _getEmotionTrendData() {
    if (_allEntries.isEmpty) return [];

    final sortedEntries = List<DiaryEntry>.from(_allEntries);
    sortedEntries.sort((a, b) => a.date.compareTo(b.date));

    return sortedEntries.asMap().entries.map((entry) {
      final index = entry.key;
      final diaryEntry = entry.value;

      // Convert emotion to numeric value for chart
      double emotionValue = 2.5; // Neutral default
      if (diaryEntry.emotion != null) {
        switch (diaryEntry.emotion!.toLowerCase()) {
          case 'happy':
          case 'joy':
          case 'excited':
          case 'proud':
            emotionValue = 5.0; // Very positive
            break;
          case 'calm':
          case 'peaceful':
          case 'relaxed':
          case 'grateful':
            emotionValue = 4.0; // Positive
            break;
          case 'confused':
          case 'uncertain':
          case 'surprised':
            emotionValue = 2.5; // Neutral
            break;
          case 'tired':
          case 'exhausted':
            emotionValue = 1.5; // Slightly negative
            break;
          case 'sad':
          case 'sadness':
          case 'depressed':
            emotionValue = 1.0; // Negative
            break;
          case 'anxious':
          case 'anxiety':
          case 'worried':
            emotionValue = 0.5; // Very negative
            break;
          case 'angry':
          case 'anger':
          case 'frustrated':
            emotionValue = 0.0; // Extremely negative
            break;
        }
      }

      return FlSpot(index.toDouble(), emotionValue);
    }).toList();
  }

  // Format time ago for recent entries
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Build calendar event markers with emojis
  List<Widget> _getEventMarkers(DateTime date, List<DiaryEntry> events) {
    return events.take(3).map((event) {
      final emoji = event.emotion != null
          ? _getEmotionEmoji(event.emotion!)
          : '📝';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(emoji, style: const TextStyle(fontSize: 12)),
      );
    }).toList();
  }

  // Helper methods for UI components
  Widget _buildFilterChip(String label, bool isSelected, Color color) {
    return GestureDetector(
      onTap: () => _onFilterChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
            fontFamily: 'Segoe UI',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Emotional History',
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
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: const Color(0xFF2D3748),
              size: isSmallScreen ? 20 : 22,
            ),
            onPressed: _loadEntries,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Animation
                AnimatedBuilder(
                  animation: _calendarController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _calendarFade,
                      child: ScaleTransition(
                        scale: _calendarScale,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF87CEEB).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
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
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 10 : 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF87CEEB,
                                      ).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 14 : 16,
                                      ),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF87CEEB,
                                        ).withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.insights_rounded,
                                      color: const Color(0xFF87CEEB),
                                      size: isSmallScreen ? 22 : 26,
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 16 : 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Emotional Journey',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 18 : 20,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF2D3748),
                                            fontFamily: 'Segoe UI',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Track your mood patterns and emotional growth over time',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
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

                              SizedBox(height: isSmallScreen ? 20 : 24),

                              // Filter Buttons
                              Wrap(
                                spacing: isSmallScreen ? 8 : 12,
                                runSpacing: isSmallScreen ? 8 : 12,
                                children: _availableEmotions.map((emotion) {
                                  Color chipColor;
                                  switch (emotion.toLowerCase()) {
                                    case 'happy':
                                      chipColor = const Color(0xFF48BB78);
                                      break;
                                    case 'sad':
                                      chipColor = const Color(0xFF4299E1);
                                      break;
                                    case 'anxious':
                                      chipColor = const Color(0xFFED8936);
                                      break;
                                    case 'calm':
                                      chipColor = const Color(0xFF9F7AEA);
                                      break;
                                    case 'angry':
                                      chipColor = const Color(0xFFF56565);
                                      break;
                                    case 'frustrated':
                                      chipColor = const Color(0xFFE53E3E);
                                      break;
                                    default:
                                      chipColor = const Color(0xFF87CEEB);
                                  }
                                  return _buildFilterChip(
                                    emotion,
                                    _selectedFilter == emotion,
                                    chipColor,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Enhanced Calendar Section with Animation
                AnimatedBuilder(
                  animation: _calendarController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _calendarFade,
                      child: ScaleTransition(
                        scale: _calendarScale,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
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
                                      isSmallScreen ? 8 : 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF48BB78,
                                      ).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 12 : 14,
                                      ),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF48BB78,
                                        ).withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.calendar_view_month_rounded,
                                      color: const Color(0xFF48BB78),
                                      size: isSmallScreen ? 20 : 24,
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 12 : 16),
                                  Text(
                                    'Mood Calendar',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 20,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2D3748),
                                      fontFamily: 'Segoe UI',
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: isSmallScreen ? 16 : 20),

                              // Enhanced Table Calendar with emotion emoji markers
                              TableCalendar<DiaryEntry>(
                                firstDay: DateTime.utc(2020, 1, 1),
                                lastDay: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                },
                                onPageChanged: (focusedDay) {
                                  setState(() {
                                    _focusedDay = focusedDay;
                                  });
                                },
                                eventLoader: (day) {
                                  final key = DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  );
                                  return _events[key] ?? [];
                                },
                                calendarStyle: CalendarStyle(
                                  outsideDaysVisible: false,
                                  weekendTextStyle: const TextStyle(
                                    color: Color(0xFFF56565),
                                  ),
                                  holidayTextStyle: const TextStyle(
                                    color: Color(0xFFF56565),
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: const Color(0xFF87CEEB),
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: const Color(
                                      0xFF87CEEB,
                                    ).withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  markerDecoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  markersMaxCount: 3,
                                  markerSize: 16,
                                  markerMargin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                ),
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2D3748),
                                    fontFamily: 'Segoe UI',
                                  ),
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left,
                                    color: const Color(0xFF87CEEB),
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right,
                                    color: const Color(0xFF87CEEB),
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ),
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, date, events) {
                                    if (events.isEmpty) return null;
                                    return Positioned(
                                      bottom: 1,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: _getEventMarkers(
                                          date,
                                          events,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: isSmallScreen ? 16 : 20),

                              // Enhanced Emotion Trend Chart
                              if (_allEntries.isNotEmpty) ...[
                                Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Emotion Trends Over Time',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2D3748),
                                          fontFamily: 'Segoe UI',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: LineChart(
                                          LineChartData(
                                            gridData: FlGridData(
                                              show: true,
                                              drawVerticalLine: false,
                                              horizontalInterval: 1,
                                              getDrawingHorizontalLine:
                                                  (value) {
                                                    return FlLine(
                                                      color: const Color(
                                                        0xFFE2E8F0,
                                                      ),
                                                      strokeWidth: 1,
                                                    );
                                                  },
                                            ),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                        if (value == 0)
                                                          return const Text(
                                                            '😠',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        if (value == 1.5)
                                                          return const Text(
                                                            '😢',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        if (value == 2.5)
                                                          return const Text(
                                                            '😐',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        if (value == 4.0)
                                                          return const Text(
                                                            '😌',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        if (value == 5.0)
                                                          return const Text(
                                                            '😊',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        return const Text('');
                                                      },
                                                ),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            minX: 0,
                                            maxX: (_allEntries.length - 1)
                                                .toDouble()
                                                .clamp(0, 20),
                                            minY: 0,
                                            maxY: 5,
                                            lineBarsData: [
                                              LineChartBarData(
                                                spots: _getEmotionTrendData(),
                                                isCurved: true,
                                                color: const Color(0xFF87CEEB),
                                                barWidth: 3,
                                                isStrokeCapRound: true,
                                                dotData: FlDotData(
                                                  show: true,
                                                  getDotPainter:
                                                      (
                                                        spot,
                                                        percent,
                                                        barData,
                                                        index,
                                                      ) {
                                                        return FlDotCirclePainter(
                                                          radius: 4,
                                                          color: const Color(
                                                            0xFF87CEEB,
                                                          ),
                                                          strokeWidth: 2,
                                                          strokeColor:
                                                              Colors.white,
                                                        );
                                                      },
                                                ),
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: const Color(
                                                    0xFF87CEEB,
                                                  ).withOpacity(0.1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Enhanced Legend
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildLegendItem(
                                    '😠 Negative',
                                    const Color(0xFFF56565),
                                  ),
                                  _buildLegendItem(
                                    '😐 Neutral',
                                    const Color(0xFF718096),
                                  ),
                                  _buildLegendItem(
                                    '😊 Positive',
                                    const Color(0xFF48BB78),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Selected Day Entries Section
                if (_selectedDay != null && _selectedDayEntries.isNotEmpty)
                  AnimatedBuilder(
                    animation: _calendarController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _calendarFade,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6FFFA),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
                            border: Border.all(
                              color: const Color(0xFF87CEEB).withOpacity(0.3),
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
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 8 : 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF87CEEB,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 12 : 14,
                                      ),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF87CEEB,
                                        ).withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: const Color(0xFF87CEEB),
                                      size: isSmallScreen ? 20 : 24,
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 12 : 16),
                                  Expanded(
                                    child: Text(
                                      'Entries for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 18 : 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2D3748),
                                        fontFamily: 'Segoe UI',
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _clearSelectedDay,
                                    child: Text(
                                      'Clear',
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
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              ..._selectedDayEntries.map((entry) {
                                final emotion = entry.emotion ?? 'Personal';
                                final emotionColor = entry.emotion != null
                                    ? _getEmotionColor(entry.emotion!)
                                    : const Color(0xFF718096);
                                final emoji = entry.emotion != null
                                    ? _getEmotionEmoji(entry.emotion!)
                                    : '📝';

                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: isSmallScreen ? 12 : 16,
                                  ),
                                  padding: EdgeInsets.all(
                                    isSmallScreen ? 16 : 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 12 : 16,
                                    ),
                                    border: Border.all(
                                      color: emotionColor.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: emotionColor.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: isSmallScreen ? 40 : 50,
                                        height: isSmallScreen ? 40 : 50,
                                        decoration: BoxDecoration(
                                          color: emotionColor.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            isSmallScreen ? 10 : 12,
                                          ),
                                          border: Border.all(
                                            color: emotionColor.withOpacity(
                                              0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            emoji,
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 18 : 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 12 : 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              emotion,
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 14
                                                    : 16,
                                                fontWeight: FontWeight.w700,
                                                color: emotionColor,
                                                fontFamily: 'Segoe UI',
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              entry.text,
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 12
                                                    : 14,
                                                color: const Color(0xFF718096),
                                                fontFamily: 'Segoe UI',
                                                height: 1.3,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Enhanced Recent Entries Section with Animation
                AnimatedBuilder(
                  animation: _entriesController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _entriesFade,
                      child: Container(
                        width: double.infinity,
                        height: 400, // Fixed height for better scrolling
                        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 16 : 20,
                          ),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
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
                                    isSmallScreen ? 8 : 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF9F7AEA,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 12 : 14,
                                    ),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF9F7AEA,
                                      ).withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.history_rounded,
                                    color: const Color(0xFF9F7AEA),
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 12 : 16),
                                Text(
                                  'Recent Entries',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 18 : 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2D3748),
                                    fontFamily: 'Segoe UI',
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 16 : 20),

                            // Enhanced Entries List with better scrolling
                            Expanded(
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFF87CEEB),
                                            ),
                                      ),
                                    )
                                  : _recentEntries.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.note_add,
                                            size: 64,
                                            color: const Color(
                                              0xFF718096,
                                            ).withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No entries yet',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF718096),
                                              fontFamily: 'Segoe UI',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Start writing in your diary to see your emotional history',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color(
                                                0xFF718096,
                                              ).withOpacity(0.7),
                                              fontFamily: 'Segoe UI',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _recentEntries.length,
                                      itemBuilder: (context, index) {
                                        final entry = _recentEntries[index];
                                        final double start = 0.05 * index;
                                        final double end = (start + 0.6).clamp(
                                          0.0,
                                          1.0,
                                        );

                                        // Handle entries without emotion (personal diary)
                                        final emotion =
                                            entry.emotion ?? 'Personal';
                                        final emotionColor =
                                            entry.emotion != null
                                            ? _getEmotionColor(entry.emotion!)
                                            : const Color(0xFF718096);
                                        final emoji = entry.emotion != null
                                            ? _getEmotionEmoji(entry.emotion!)
                                            : '📝';

                                        return SlideTransition(
                                          position:
                                              Tween<Offset>(
                                                begin: const Offset(0, 0.3),
                                                end: Offset.zero,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: _entriesController,
                                                  curve: Interval(
                                                    start,
                                                    end,
                                                    curve: Curves.easeOutCubic,
                                                  ),
                                                ),
                                              ),
                                          child: FadeTransition(
                                            opacity:
                                                Tween<double>(
                                                  begin: 0.0,
                                                  end: 1.0,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: _entriesController,
                                                    curve: Interval(
                                                      start,
                                                      end,
                                                      curve:
                                                          Curves.easeOutCubic,
                                                    ),
                                                  ),
                                                ),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                bottom: isSmallScreen ? 12 : 16,
                                              ),
                                              padding: EdgeInsets.all(
                                                isSmallScreen ? 16 : 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      isSmallScreen ? 12 : 16,
                                                    ),
                                                border: Border.all(
                                                  color: emotionColor
                                                      .withOpacity(0.2),
                                                  width: 1.5,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: emotionColor
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  // Enhanced Emoji Display
                                                  Container(
                                                    width: isSmallScreen
                                                        ? 50
                                                        : 60,
                                                    height: isSmallScreen
                                                        ? 50
                                                        : 60,
                                                    decoration: BoxDecoration(
                                                      color: emotionColor
                                                          .withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            isSmallScreen
                                                                ? 12
                                                                : 16,
                                                          ),
                                                      border: Border.all(
                                                        color: emotionColor
                                                            .withOpacity(0.3),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        emoji,
                                                        style: TextStyle(
                                                          fontSize:
                                                              isSmallScreen
                                                              ? 24
                                                              : 28,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: isSmallScreen
                                                        ? 16
                                                        : 20,
                                                  ),

                                                  // Enhanced Content Display
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              emotion,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isSmallScreen
                                                                    ? 16
                                                                    : 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    emotionColor,
                                                                fontFamily:
                                                                    'Segoe UI',
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              _formatTimeAgo(
                                                                entry.date,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isSmallScreen
                                                                    ? 12
                                                                    : 14,
                                                                color:
                                                                    const Color(
                                                                      0xFF718096,
                                                                    ),
                                                                fontFamily:
                                                                    'Segoe UI',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(
                                                          height: isSmallScreen
                                                              ? 6
                                                              : 8,
                                                        ),

                                                        Text(
                                                          '${entry.date.day}/${entry.date.month}/${entry.date.year} • ${entry.type == 'ai' ? _getEmotionDescription(emotion) : 'Personal reflection'}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                isSmallScreen
                                                                ? 13
                                                                : 14,
                                                            color: const Color(
                                                              0xFF718096,
                                                            ),
                                                            fontFamily:
                                                                'Segoe UI',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.3,
                                                          ),
                                                        ),

                                                        // Enhanced Text Preview
                                                        if (entry.text.length >
                                                            60)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8,
                                                                ),
                                                            child: Text(
                                                              '${entry.text.substring(0, 60)}...',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isSmallScreen
                                                                    ? 12
                                                                    : 13,
                                                                color:
                                                                    const Color(
                                                                      0xFF718096,
                                                                    ).withOpacity(
                                                                      0.8,
                                                                    ),
                                                                fontFamily:
                                                                    'Segoe UI',
                                                                height: 1.3,
                                                              ),
                                                            ),
                                                          )
                                                        else if (entry
                                                            .text
                                                            .isNotEmpty)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8,
                                                                ),
                                                            child: Text(
                                                              entry.text,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isSmallScreen
                                                                    ? 12
                                                                    : 13,
                                                                color:
                                                                    const Color(
                                                                      0xFF718096,
                                                                    ).withOpacity(
                                                                      0.8,
                                                                    ),
                                                                fontFamily:
                                                                    'Segoe UI',
                                                                height: 1.3,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: isSmallScreen
                                                        ? 12
                                                        : 16,
                                                  ),

                                                  // Arrow Icon
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: emotionColor,
                                                    size: isSmallScreen
                                                        ? 16
                                                        : 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
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
