# MindCompanion

A comprehensive mental health companion app designed to support emotional wellness and provide crisis intervention tools.

## 🎯 **Project Specifications Met**

✅ **Navegación inferior con 3 íconos**: Home, History, Settings  
✅ **Seis pantallas conectadas con rutas**: Todas implementadas con navegación correcta  
✅ **Cada pantalla en archivo `.dart` separado**: Estructura organizada en `/lib/screens/`  
✅ **Colores y estilos suaves basados en tonos pastel**: Paleta de colores calmantes implementada  
✅ **Navegación usando `Navigator.pushNamed` y `routes`**: Configuración completa en `main.dart`  
✅ **Estructura limpia**: `/lib/screens` para pantallas, `/lib/widgets` para componentes reutilizables  
✅ **Solo UI y navegación**: Sin funcionalidad de backend ni IA, enfocado en la interfaz  

## 🏗️ **Project Structure**

```
flutter_project/
├── lib/
│   ├── main.dart                 # App entry point with routes configuration
│   ├── screens/                  # All app screens
│   │   ├── welcome_screen.dart
│   │   ├── home_screen.dart
│   │   ├── ai_diary_screen.dart
│   │   ├── personal_diary_screen.dart
│   │   ├── crisis_mode_screen.dart
│   │   ├── emotional_history_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/                  # Reusable UI components
│       ├── feature_card.dart
│       ├── crisis_button.dart
│       ├── primary_button.dart
│       └── app_colors.dart
├── pubspec.yaml
└── README.md
```

## 📱 **Screens Implemented**

### 🏠 **WelcomeScreen**
- Beautiful welcome interface with app branding
- Sign Up and Log In buttons using `PrimaryButton` widget
- Privacy Policy link
- Clean, calming design with pastel colors

### 🏡 **HomeScreen**
- Personalized greeting
- 4 main feature cards using `FeatureCard` widget:
  - **Register Emotion**: Navigates to AI Diary
  - **Diary**: Navigates to Personal Diary
  - **Meditations**: Placeholder for future implementation
  - **Crisis Mode**: Navigates to Crisis Mode
- Bottom navigation with Home, History, and Settings

### 🤖 **AIDiaryScreen**
- Text input for describing feelings
- Voice input with microphone button
- AI emotion detection simulation with emoji and text results
- Personalized suggestions for exercises/meditation
- Save entry functionality using `PrimaryButton`

### 📝 **PersonalDiaryScreen**
- Free-form text input
- Date selector for entries
- Save and manage personal thoughts
- Clean, distraction-free interface

### 🚨 **CrisisModeScreen**
- 4 crisis intervention options using `CrisisButton` widget:
  - **Breathing Exercise**: 4-7-8 technique
  - **Quick Meditation**: 5-minute guided sessions
  - **Comfort Audio**: Soothing sounds
  - **Contact Help**: Crisis counselor support
- Emergency phone icon
- Emergency resources section

### 📊 **EmotionalHistoryScreen**
- Calendar heatmap showing emotional patterns
- Recent entries with dates and emojis
- Filtering options by emotion type
- Visual representation of emotional journey

### ⚙️ **SettingsScreen**
- User profile management
- Notification preferences
- Appearance settings (Dark Mode, Language)
- Security options (Biometric login)
- Support and help resources
- Account management using `PrimaryButton`

## 🎨 **Design Features**

- **Color Scheme**: Soft, calming pastel colors with primary blue (#6B73FF)
- **Typography**: Clean, readable fonts with proper hierarchy
- **Layout**: Card-based design with rounded corners
- **Navigation**: Intuitive bottom navigation and screen transitions
- **Accessibility**: High contrast and clear visual elements
- **Consistency**: Reusable widgets ensure uniform appearance

## 🔧 **Technical Implementation**

### **Navigation System**
- Uses `Navigator.pushNamed` for screen transitions
- Routes configured in `main.dart`
- Bottom navigation bar for main sections
- Proper back navigation with `Navigator.pop`

### **Widget Architecture**
- **FeatureCard**: Reusable card component for home screen features
- **CrisisButton**: Specialized button for crisis mode interventions
- **PrimaryButton**: Universal button component with outlined/solid variants
- **AppColors**: Centralized color constants for consistency

### **State Management**
- `StatefulWidget` for screens requiring state
- Local state management for UI interactions
- No external state management libraries (as requested)

## 🚀 **Getting Started**

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd mindcompanion
```

## 🧪 **Testing**

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test suites
flutter test test/integration/theme_integration_test.dart
flutter test test/golden/text_scaling_golden_test.dart
```

### Updating Golden Baselines
When UI changes require updating visual test baselines:

```bash
# Update text scaling golden baselines
flutter test --update-goldens test/golden/text_scaling_golden_test.dart

# Update theme golden baselines
flutter test --update-goldens test/golden/theme_golden_test.dart

# Update all golden baselines
flutter test --update-goldens
```

**Important**: Always commit the generated PNG files to the repository for CI/CD validation.

### CI/CD Pipeline

The project includes a comprehensive CI/CD pipeline that validates:

- **Code Quality**: Formatting, analysis, and linting
- **Unit Tests**: Full test coverage with reports
- **Integration Tests**: Theme and provider integration
- **Golden Tests**: Visual regression testing
- **Build Validation**: APK and web builds

#### Pipeline Features

- **Automatic Testing**: Runs on every push and PR
- **Golden Test Validation**: Ensures visual consistency across environments
- **Golden Baseline Updates**: Automated updates when labeled with `update-goldens`
- **Release Automation**: Automatic releases on main branch
- **Multi-platform Builds**: Android APK and web deployment

#### Local Validation

Before pushing, validate golden tests locally:

```bash
# Linux/Mac
./scripts/validate_goldens.sh

# Windows
scripts\validate_goldens.bat
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building

For Android:
```bash
flutter build apk
```

For iOS:
```bash
flutter build ios
```

For Web:
```bash
flutter build web
```

## 🔮 **Future Enhancements**

- [ ] User authentication and backend integration
- [ ] Real AI emotion detection
- [ ] Meditation audio content
- [ ] Crisis hotline integration
- [ ] Data export and backup
- [ ] Push notifications
- [ ] Dark mode implementation
- [ ] Multi-language support
- [ ] Offline functionality
- [ ] Analytics and insights

## 📝 **Code Quality**

- **Clean Architecture**: Separation of concerns with screens and widgets
- **Reusable Components**: Widgets designed for maximum reusability
- **Consistent Styling**: Centralized color and style management
- **Proper Navigation**: Follows Flutter navigation best practices
- **No Backend Dependencies**: Pure UI implementation as requested

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 **Support**

For support and questions, please contact the development team or create an issue in the repository.

---

**Note**: This app is designed to support mental health but is not a replacement for professional medical care. If you're experiencing a mental health crisis, please contact emergency services or a mental health professional.
