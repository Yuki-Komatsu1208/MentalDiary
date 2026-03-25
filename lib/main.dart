import 'package:mental_diary/Pages/daily_input_page.dart';
import 'package:flutter/material.dart';

//エントリポイント
void main() {
  print("Start Emotion Diary App");
  runApp(const MyApp());
}

//描画専用ウィジェット。初期設定、ルートページ等を定義。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //アプリ全体のテーマを返す
  ThemeData _buildTheme() {
    const Color surfaceColor = Color(0xFFF3F0E8);
    const Color accentColor = Color(0xFF111111);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surfaceColor,
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        onPrimary: Colors.white,
        secondary: Color(0xFF7C7C7C),
        surface: Colors.white,
        onSurface: accentColor,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.4,
          color: accentColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: accentColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: accentColor,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: accentColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: accentColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: accentColor,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: accentColor,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: Color(0xFF5E5E5E),
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF111111), width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF111111), width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF7A1F1F), width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF7A1F1F), width: 1.4),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //MterialApp：アプリ全体の設定をまとめる土台
    return MaterialApp(
      //タイトル
      title: 'Mental Diary',
      //全体の色、スタイル
      theme: _buildTheme(),
      //最初に表示するページ。当日の入力画面を表示する。
      home: const DailyInputPage(),
    );
  }
}
