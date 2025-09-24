# Diary Storage Implementation

This document describes the local storage implementation for both AI Diary and Personal Diary entries using `shared_preferences`.

## Features

### 1. Data Models
- **DiaryEntry**: A unified model for both AI and Personal diary entries
  - `id`: Unique identifier for each entry
  - `text`: The diary content
  - `date`: When the entry was created
  - `emotion`: Detected emotion (AI diary only, null for personal)
  - `type`: Either 'ai' or 'personal'

### 2. Storage Service
- **DiaryStorageService**: Handles all storage operations
  - Save AI diary entries with emotion detection
  - Save personal diary entries
  - Retrieve entries by type or date
  - Delete individual entries
  - Clear all entries

### 3. Screen Updates
- **AI Diary Screen**: Now saves entries with text, emotion, and date
- **Personal Diary Screen**: Saves entries with text and date
- **Emotional History Screen**: Displays all saved entries with filtering

## Usage

### Saving Entries

#### AI Diary
```dart
await DiaryStorageService.saveAIEntry(
  "I had a great day today!",
  "Happy",
  DateTime.now(),
);
```

#### Personal Diary
```dart
await DiaryStorageService.savePersonalEntry(
  "Today I reflected on my goals...",
  DateTime.now(),
);
```

### Retrieving Entries

```dart
// Get all entries
final allEntries = await DiaryStorageService.getAllEntries();

// Get AI entries only
final aiEntries = await DiaryStorageService.getAIEntries();

// Get personal entries only
final personalEntries = await DiaryStorageService.getPersonalEntries();

// Get entries for a specific date
final todayEntries = await DiaryStorageService.getEntriesForDate(DateTime.now());

// Get entries for a date range
final weekEntries = await DiaryStorageService.getEntriesForDateRange(
  DateTime.now().subtract(const Duration(days: 7)),
  DateTime.now(),
);
```

### Filtering in Emotional History

The Emotional History screen automatically:
- Loads all saved entries from both diary types
- Updates available emotion filters based on saved AI entries
- Shows personal entries with a "Personal" label and 📝 emoji
- Displays entry previews (first 50 characters)
- Shows time ago (e.g., "2 hours ago", "1 day ago")

### Calendar View

- **Interactive Calendar**: Uses `table_calendar` to display entries by date
- **Emotion Markers**: Each date with entries shows emotion emojis as markers
- **Date Selection**: Click on dates to view entries for that specific day
- **Selected Day Entries**: Shows detailed view of entries for the selected date
- **Calendar Navigation**: Navigate between months and years

### Emotion Trend Chart

- **Line Chart**: Uses `fl_chart` to visualize emotional progress over time
- **Emotion Scoring**: Converts emotions to numerical scores (Happy=5, Sad=1, etc.)
- **Trend Analysis**: Shows cumulative average emotional state
- **Visual Indicators**: Emoji labels on Y-axis for quick emotion reference
- **Interactive**: Hover effects and smooth animations

## Data Persistence

- All data is stored locally using `shared_preferences`
- Data persists between app sessions
- Entries are automatically sorted by date
- No internet connection required

## Error Handling

- Graceful error handling for storage operations
- User feedback through SnackBar messages
- Loading states during data operations
- Empty state when no entries exist

## Future Enhancements

- Export/import functionality
- Cloud backup options
- Advanced filtering and search
- Entry editing and deletion
- Data analytics and insights
