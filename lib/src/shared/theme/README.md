# Theme System

## Quick Start

### Using Themes

```dart
// Access theme properties easily
Container(
  padding: Paddings.allL,              // 16px padding
  color: context.primaryColor,          // Primary color
  child: Column(
    children: [
      Text('Title', style: context.textTheme.headlineMedium),
      Spacing.verticalM,                // 12px vertical space
      Text('Content', style: context.textTheme.bodyMedium),
    ],
  ),
)
```

### Creating a New Theme

```dart
// 1. Define colors in app_colors.dart
static const Color myPrimary = Color(0xFF123456);
static const Color myAccent = Color(0xFF654321);

// 2. Create theme file
class MyTheme {
  static ThemeData get myTheme {
    return ThemeComposer.compose(
      ThemeConfig.dark(
        primaryColor: AppColors.myPrimary,
        accentColor: AppColors.myAccent,
      ),
    );
  }
}
```

## File Structure

- **`tokens.dart`** - Design system constants (spacing, sizing, timing)
- **`app_colors.dart`** - Color definitions for all themes
- **`theme_composer.dart`** - Theme composition system
- **`theme_extensions.dart`** - Custom theme properties
- **`theme_utils.dart`** - Utility helpers and extensions
- **`theme_model.dart`** - Theme enum and type definitions
- **`theme_providers.dart`** - Riverpod providers for theme management
- **`app_theme.dart`** - Main export file
- **Individual theme files** - One file per theme variant

## Key Features

✅ **Consistent Composition** - All themes use unified ThemeComposer  
✅ **Enhanced Tokens** - 42 design system constants  
✅ **Custom Extensions** - App-specific theme properties  
✅ **Utility Helpers** - Easy theme access via context extensions  
✅ **Zero Duplication** - Theme files are ~15 lines each  
✅ **100% Backward Compatible** - No breaking changes  

## Documentation

- **[THEME_SYSTEM_GUIDE.md](./THEME_SYSTEM_GUIDE.md)** - Complete guide with examples
- **[../../THEME_COMPOSITION_IMPROVEMENTS.md](../../THEME_COMPOSITION_IMPROVEMENTS.md)** - Summary of improvements

## Available Themes (21 Total)

### Light Themes (7)
1. **Classic Light** - Purple accents on light background
2. **Rose Pink** - Pink accents on light background  
3. **🆕 Lavender Dream** - Soft lavender accents on light background
4. **🆕 Mint Fresh** - Fresh mint green accents on light background
5. **🆕 Coral Sunset** - Warm coral accents on light background
6. **🆕 Sky Blue** - Soft blue accents on light background
7. **🆕 Honey Gold** - Warm golden accents on light background

### Dark Themes (14)
1. **Classic Dark** - Purple accents on dark background
2. **Blue Ocean** - Blue accents on dark background
3. **Sunset Orange** - Orange accents on dark background
4. **Forest Green** - Green accents on dark background
5. **Midnight Purple** - Deep purple accents on dark background
6. **Amber Gold** - Golden accents on dark background
7. **🆕 Emerald Night** - Rich emerald accents on dark background
8. **🆕 Deep Ocean** - Deep navy blue accents on dark background
9. **🆕 Ruby Red** - Rich ruby red accents on dark background
10. **🆕 Slate Gray** - Cool slate gray accents on dark background
11. **🆕 Violet Dusk** - Rich violet accents on dark background
12. **🆕 Crimson Night** - Deep crimson accents on dark background
13. **🆕 Teal Wave** - Teal cyan accents on dark background
14. **🆕 Indigo Deep** - Deep indigo accents on dark background

## Quick Reference

### Design Tokens

```dart
Tokens.spaceL          // 16px
Tokens.radiusM         // 12px
Tokens.elevationMedium // 4px
Tokens.durMed          // 250ms
```

### Context Extensions

```dart
context.primaryColor
context.surfaceColor
context.successColor
context.isDarkTheme
context.textTheme
```

### Spacing & Padding

```dart
Spacing.verticalM      // SizedBox(height: 12)
Paddings.allL          // EdgeInsets.all(16)
AppBorderRadius.medium // BorderRadius.circular(12)
```

### Custom Properties

```dart
context.appTheme.successColor
context.appTheme.warningColor
context.appTheme.shimmerBaseColor
context.appTheme.gradientStart
```

---

For detailed documentation, see [THEME_SYSTEM_GUIDE.md](./THEME_SYSTEM_GUIDE.md)

