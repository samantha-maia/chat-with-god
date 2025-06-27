import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Deep Spiritual Blue
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep blue
  static const Color primaryLightColor = Color(0xFF3B82F6); // Lighter blue
  static const Color primaryDarkColor = Color(0xFF1E40AF); // Darker blue
  
  // Secondary Colors - Warm Gold
  static const Color secondaryColor = Color(0xFFD97706); // Warm gold
  static const Color secondaryLightColor = Color(0xFFF59E0B); // Lighter gold
  static const Color secondaryDarkColor = Color(0xFFB45309); // Darker gold
  
  // Accent Colors - Soft and Calming
  static const Color accentColor = Color(0xFF10B981); // Soft green
  static const Color accentLightColor = Color(0xFF34D399); // Lighter green
  
  // Neutral Colors - Warm Grays
  static const Color backgroundColor = Color(0xFFF8FAFC); // Very light gray
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white
  static const Color cardColor = Color(0xFFFFFFFF); // Pure white
  
  // Text Colors
  static const Color textPrimaryColor = Color(0xFF1F2937); // Dark gray
  static const Color textSecondaryColor = Color(0xFF6B7280); // Medium gray
  static const Color textLightColor = Color(0xFF9CA3AF); // Light gray
  
  // Status Colors
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color warningColor = Color(0xFFF59E0B); // Orange
  static const Color infoColor = Color(0xFF3B82F6); // Blue
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLightColor],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, secondaryLightColor],
  );
  
  static const LinearGradient spiritualGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, accentColor],
  );

  // Enhanced Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Cooler background
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1E293B); // Slate 800
  static const Color lightOnSurfaceVariant = Color(0xFF64748B); // Slate 500
  static const Color lightOutline = Color(0xFFE2E8F0); // Slate 200
  static const Color lightOutlineVariant = Color(0xFFF1F5F9); // Slate 100

  // Enhanced Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkOnSurface = Color(0xFFF1F5F9); // Slate 100
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8); // Slate 400
  static const Color darkOutline = Color(0xFF334155); // Slate 700
  static const Color darkOutlineVariant = Color(0xFF475569); // Slate 600

  // Enhanced Chat Colors
  static const Color userMessageLight = Color(0xFF6366F1); // Primary color
  static const Color userMessageDark = Color(0xFF8B5CF6); // Secondary color
  static const Color aiMessageLight = Color(0xFFF8FAFC); // Light background
  static const Color aiMessageDark = Color(0xFF334155); // Dark surface

  // New Gradient Colors
  static const Color gradientStart = Color(0xFF6366F1);
  static const Color gradientEnd = Color(0xFF8B5CF6);
  static const Color gradientAccent = Color(0xFFF59E0B);

  // New Semantic Colors
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);

  // Enhanced Typography
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: textPrimaryColor,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    color: textPrimaryColor,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: textPrimaryColor,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: textPrimaryColor,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: textSecondaryColor,
    height: 1.3,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: textPrimaryColor,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textSecondaryColor,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textLightColor,
  );
  
  // Special Typography for Spiritual Content
  static const TextStyle verseText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: textPrimaryColor,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );
  
  static const TextStyle prayerText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: textPrimaryColor,
    height: 1.7,
  );
  
  static const TextStyle spiritualTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    color: primaryColor,
    height: 1.3,
  );

  // Enhanced Card Design
  static const double cardRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(cardRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 4,
        offset: const Offset(0, 1),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration elevatedCardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(cardRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration primaryCardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(cardRadius),
    border: Border.all(
      color: primaryColor.withOpacity(0.1),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.05),
        blurRadius: 12,
        offset: const Offset(0, 3),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration gradientCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(cardRadius),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        primaryLightColor,
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.2),
        blurRadius: 12,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
  );

  // Enhanced Button Styling
  static const double buttonRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double smallButtonHeight = 36.0;
  
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    shadowColor: primaryColor.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    minimumSize: const Size(120, buttonHeight),
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: primaryColor,
    elevation: 0,
    side: BorderSide(color: primaryColor, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    minimumSize: const Size(120, buttonHeight),
  );
  
  static ButtonStyle gradientButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 3,
    shadowColor: primaryColor.withOpacity(0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    minimumSize: const Size(120, buttonHeight),
  );
  
  static ButtonStyle smallButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 1,
    shadowColor: primaryColor.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius - 2),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minimumSize: const Size(80, smallButtonHeight),
  );
  
  static ButtonStyle iconButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor.withOpacity(0.1),
    foregroundColor: primaryColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
    padding: const EdgeInsets.all(12),
    minimumSize: const Size(48, 48),
  );
  
  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minimumSize: const Size(80, smallButtonHeight),
  );

  // Enhanced Spacing & Layout
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;
  
  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(paddingM);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: paddingM);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: paddingM);
  
  // Card Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(paddingM);
  static const EdgeInsets cardPaddingHorizontal = EdgeInsets.symmetric(horizontal: paddingM);
  static const EdgeInsets cardPaddingVertical = EdgeInsets.symmetric(vertical: paddingM);
  
  // Button Padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: paddingL, vertical: paddingS);
  static const EdgeInsets smallButtonPadding = EdgeInsets.symmetric(horizontal: paddingM, vertical: paddingXS);
  
  // List Item Spacing
  static const double listItemSpacing = spacingM;
  static const EdgeInsets listItemPadding = EdgeInsets.all(paddingM);
  
  // Section Spacing
  static const double sectionSpacing = spacingXL;
  static const double subsectionSpacing = spacingL;
  
  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Elevation
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  // Enhanced Animations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);
  
  static const Curve animationCurveFast = Curves.easeInOut;
  static const Curve animationCurveNormal = Curves.easeInOut;
  static const Curve animationCurveSlow = Curves.easeInOut;
  static const Curve animationCurveBounce = Curves.elasticOut;
  
  // Page Transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOut;
  
  // Button Animations
  static const Duration buttonPressDuration = Duration(milliseconds: 100);
  static const Duration buttonHoverDuration = Duration(milliseconds: 200);
  
  // Card Animations
  static const Duration cardHoverDuration = Duration(milliseconds: 200);
  static const Duration cardPressDuration = Duration(milliseconds: 150);
  
  // List Animations
  static const Duration listItemAnimationDuration = Duration(milliseconds: 300);
  static const Curve listItemAnimationCurve = Curves.easeOut;
  
  // Loading Animations
  static const Duration loadingAnimationDuration = Duration(milliseconds: 1000);
  static const Duration shimmerAnimationDuration = Duration(milliseconds: 1500);
  
  // Fade Animations
  static const Duration fadeInDuration = Duration(milliseconds: 300);
  static const Duration fadeOutDuration = Duration(milliseconds: 200);
  
  // Scale Animations
  static const Duration scaleAnimationDuration = Duration(milliseconds: 200);
  static const double scaleAnimationValue = 0.95;
  
  // Slide Animations
  static const Duration slideAnimationDuration = Duration(milliseconds: 300);
  static const Curve slideAnimationCurve = Curves.easeInOut;

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF60A5FA); // Lighter blue for dark mode
  static const Color darkPrimaryLightColor = Color(0xFF93C5FD); // Very light blue
  static const Color darkPrimaryDarkColor = Color(0xFF3B82F6); // Medium blue
  
  static const Color darkSecondaryColor = Color(0xFFFBBF24); // Lighter gold for dark mode
  static const Color darkSecondaryLightColor = Color(0xFFFCD34D); // Very light gold
  static const Color darkSecondaryDarkColor = Color(0xFFF59E0B); // Medium gold
  
  static const Color darkAccentColor = Color(0xFF34D399); // Lighter green for dark mode
  static const Color darkAccentLightColor = Color(0xFF6EE7B7); // Very light green
  
  static const Color darkBackgroundColor = Color(0xFF0F172A); // Very dark blue-gray
  static const Color darkSurfaceColor = Color(0xFF1E293B); // Dark blue-gray
  static const Color darkCardColor = Color(0xFF334155); // Medium blue-gray
  
  static const Color darkTextPrimaryColor = Color(0xFFF1F5F9); // Very light gray
  static const Color darkTextSecondaryColor = Color(0xFFCBD5E1); // Light gray
  static const Color darkTextLightColor = Color(0xFF94A3B8); // Medium gray

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: textButtonStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: paddingM, vertical: paddingS),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: darkTextPrimaryColor,
        onBackground: darkTextPrimaryColor,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.black,
          elevation: 2,
          shadowColor: darkPrimaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(120, buttonHeight),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(80, smallButtonHeight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: paddingM, vertical: paddingS),
      ),
    );
  }
} 