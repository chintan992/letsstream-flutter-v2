import 'package:flutter/material.dart';

// Utility to generate app logos programmatically
// This file contains design specifications and helper functions

class LogoDesign {
  // Color palette
  static const Color primaryPurple = Color(0xFF6200EE);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color whiteColor = Color(0xFFFFFFFF);
  
  // Design constants
  static const double cornerRadius = 24.0;
  static const double iconPadding = 32.0;
  
  // Opacities for streaming waves
  static const double wave1Opacity = 0.3;
  static const double wave2Opacity = 0.2;
  static const double wave3Opacity = 0.1;
  
  // Text styles
  static const String fontFamily = 'Roboto';
  static const FontWeight fontWeight = FontWeight.bold;
  
  /// Returns the SVG string for the app icon
  static String getAppIconSVG({double size = 192}) {
    return '''
<svg width="$size" height="$size" viewBox="0 0 $size $size" xmlns="http://www.w3.org/2000/svg">
  <rect width="$size" height="$size" rx="${size * 0.25}" fill="#1a1a1a"/>
  <g transform="translate(${size * 0.167}, ${size * 0.167})">
    <!-- Play button base -->
    <rect x="0" y="0" width="${size * 0.333}" height="${size * 0.333}" rx="${size * 0.042}" fill="#6200ee"/>
    
    <!-- Play arrow -->
    <path d="M${size * 0.125} ${size * 0.083} L${size * 0.125} ${size * 0.25} L${size * 0.292} ${size * 0.167} Z" fill="white"/>
    
    <!-- Streaming waves -->
    <rect x="${size * 0.292}" y="${size * 0.042}" width="${size * 0.042}" height="${size * 0.042}" rx="1" fill="#6200ee" opacity="0.3"/>
    <rect x="${size * 0.333}" y="${size * 0.104}" width="${size * 0.042}" height="${size * 0.042}" rx="1" fill="#6200ee" opacity="0.2"/>
    <rect x="${size * 0.375}" y="${size * 0.167}" width="${size * 0.042}" height="${size * 0.042}" rx="1" fill="#6200ee" opacity="0.1"/>
  </g>
</svg>
''';
  }
  
  /// Returns the SVG string for the full logo with text
  static String getFullLogoSVG({double size = 1024}) {
    return '''
<svg width="$size" height="$size" viewBox="0 0 $size $size" xmlns="http://www.w3.org/2000/svg">
  <rect width="$size" height="$size" rx="${size * 0.219}" fill="#1a1a1a"/>
  <g transform="translate(${size * 0.176}, ${size * 0.176})">
    <!-- Play button base -->
    <rect x="0" y="0" width="${size * 0.273}" height="${size * 0.273}" rx="${size * 0.023}" fill="#6200ee"/>
    
    <!-- Play arrow -->
    <path d="M${size * 0.107} ${size * 0.078} L${size * 0.107} ${size * 0.195} L${size * 0.186} ${size * 0.137} Z" fill="white"/>
    
    <!-- Streaming waves -->
    <rect x="${size * 0.215}" y="${size * 0.029}" width="${size * 0.039}" height="${size * 0.039}" rx="4" fill="#6200ee" opacity="0.3"/>
    <rect x="${size * 0.235}" y="${size * 0.078}" width="${size * 0.039}" height="${size * 0.039}" rx="4" fill="#6200ee" opacity="0.2"/>
    <rect x="${size * 0.255}" y="${size * 0.127}" width="${size * 0.039}" height="${size * 0.039}" rx="4" fill="#6200ee" opacity="0.1"/>
    
    <!-- Dots for media types -->
    <circle cx="${size * 0.039}" cy="${size * 0.215}" r="${size * 0.012}" fill="#4caf50"/>
    <circle cx="${size * 0.078}" cy="${size * 0.215}" r="${size * 0.012}" fill="#ff9800"/>
    <circle cx="${size * 0.117}" cy="${size * 0.215}" r="${size * 0.012}" fill="#f44336"/>
  </g>
  
  <!-- App name -->
  <text x="${size * 0.5}" y="${size * 0.831}" text-anchor="middle" font-family="Roboto, Arial, sans-serif" font-size="${size * 0.117}" font-weight="bold" fill="#ffffff">
    Let's Stream
  </text>
</svg>
''';
  }
}