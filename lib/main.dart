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

  static const List<String> _fontFallbacks = <String>[
    'Hiragino Sans',
    'Hiragino Kaku Gothic ProN',
    'Noto Sans JP',
    'Yu Gothic',
    'sans-serif',
  ];

  TextStyle _textStyle({
    required double fontSize,
    required FontWeight fontWeight,
    double? letterSpacing,
    double? height,
    Color color = const Color(0xFF171411),
  }) {
    return TextStyle(
      fontFamily: 'Hiragino Sans',
      fontFamilyFallback: _fontFallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  //アプリ全体のテーマを返す
  ThemeData _buildTheme() {
    const Color surfaceColor = Color(0xFFF2EBDD);
    const Color accentColor = Color(0xFF171411);
    const Color softSurfaceColor = Color(0xFFF8F3EA);
    const Color outlineColor = Color(0xFF3B342D);

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Hiragino Sans',
      scaffoldBackgroundColor: surfaceColor,
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        onPrimary: Colors.white,
        secondary: Color(0xFF8E857A),
        surface: softSurfaceColor,
        onSurface: accentColor,
      ),
      textTheme: TextTheme(
        headlineLarge: _textStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.1,
          height: 1.1,
        ),
        headlineMedium: _textStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.15,
        ),
        titleLarge: _textStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.2,
        ),
        titleMedium: _textStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.25,
        ),
        bodyLarge: _textStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.6,
        ),
        bodyMedium: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.55,
          letterSpacing: 0.05,
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
        fillColor: softSurfaceColor,
        labelStyle: _textStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5C544C),
          height: 1.35,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: outlineColor, width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: accentColor, width: 1.6),
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
        backgroundColor: softSurfaceColor,
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
