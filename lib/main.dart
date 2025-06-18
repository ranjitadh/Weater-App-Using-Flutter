import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'Pages/weather_page.dart';
import 'Providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Weather App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFE0F7FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0288D1),
              foregroundColor: Colors.white,
            ),
            cardColor: Colors.white.withOpacity(0.95),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                  color: Color(0xFF212121), fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(
                  color: Color(0xFF212121), fontWeight: FontWeight.w300),
              bodyMedium: TextStyle(color: Color(0xFF757575)),
              bodySmall: TextStyle(color: Color(0xFF757575)),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF0288D1)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide:
                    const BorderSide(color: Color(0xFF0288D1), width: 2),
              ),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blueGrey,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
            cardColor: const Color(0xFF1E1E1E),
            textTheme: const TextTheme(
              headlineLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              headlineMedium:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.w300),
              bodyMedium: TextStyle(color: Colors.white60),
              bodySmall: TextStyle(color: Colors.white60),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF4FC3F7)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide:
                    const BorderSide(color: Color(0xFF4FC3F7), width: 2),
              ),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const WeatherPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
