import 'package:flutter/material.dart';

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.2,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  // Specialized Text Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.4,
  );
  
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // K-pop Inspired Styles
  static const TextStyle kpopTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: 1.0,
  );
  
  static const TextStyle groupName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0.5,
  );
  
  static const TextStyle memberName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle albumTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  // Collection Specific Styles
  static const TextStyle collectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle photocardInfo = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  
  static const TextStyle statusBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    height: 1.0,
    letterSpacing: 0.5,
  );
  
  // Themed Text Styles
  static TextStyle getThemedH1(Color color) => h1.copyWith(color: color);
  static TextStyle getThemedH2(Color color) => h2.copyWith(color: color);
  static TextStyle getThemedH3(Color color) => h3.copyWith(color: color);
  static TextStyle getThemedH4(Color color) => h4.copyWith(color: color);
  static TextStyle getThemedH5(Color color) => h5.copyWith(color: color);
  static TextStyle getThemedH6(Color color) => h6.copyWith(color: color);
  
  static TextStyle getThemedBodyLarge(Color color) => bodyLarge.copyWith(color: color);
  static TextStyle getThemedBodyMedium(Color color) => bodyMedium.copyWith(color: color);
  static TextStyle getThemedBodySmall(Color color) => bodySmall.copyWith(color: color);
  
  static TextStyle getThemedCaption(Color color) => caption.copyWith(color: color);
  static TextStyle getThemedOverline(Color color) => overline.copyWith(color: color);
  static TextStyle getThemedButton(Color color) => button.copyWith(color: color);
  static TextStyle getThemedLabel(Color color) => label.copyWith(color: color);
  
  // Responsive Text Styles
  static TextStyle getResponsiveH1(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = 32;
    
    if (screenWidth < 600) {
      fontSize = 24;
    } else if (screenWidth < 1024) {
      fontSize = 28;
    }
    
    return h1.copyWith(fontSize: fontSize);
  }
  
  static TextStyle getResponsiveH2(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = 28;
    
    if (screenWidth < 600) {
      fontSize = 20;
    } else if (screenWidth < 1024) {
      fontSize = 24;
    }
    
    return h2.copyWith(fontSize: fontSize);
  }
  
  static TextStyle getResponsiveBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = 16;
    
    if (screenWidth < 600) {
      fontSize = 14;
    } else if (screenWidth < 1024) {
      fontSize = 15;
    }
    
    return bodyMedium.copyWith(fontSize: fontSize);
  }
}

// Extension for easy text style application
extension TextStyleExtensions on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle withOpacity(double opacity) => copyWith(color: color?.withValues(alpha: opacity));
  TextStyle withSpacing(double spacing) => copyWith(letterSpacing: spacing);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle makeItalic() => copyWith(fontStyle: FontStyle.italic);
  TextStyle makeUnderline() => copyWith(decoration: TextDecoration.underline);
  TextStyle makeLineThrough() => copyWith(decoration: TextDecoration.lineThrough);
}