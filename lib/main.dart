import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hdmgr/components/spending_card.dart';
import 'package:hdmgr/components/statsbar.dart';
import 'package:hdmgr/models/purpose.dart';
import 'package:hdmgr/models/spending.dart';
import 'package:hdmgr/pages/home_screen.dart';
import 'package:hdmgr/pages/settings_screen.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [HomePage(), HomePage(), SettingsPage()];
  final ColorScheme colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFC6D6FF),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFF7299FE),
      onSecondary: Color(0xFF000000),
      error: Color(0xFFFE8B72),
      onError: Color(0xFFFFFFFF),
      background: Color(0xFFFFFFFF),
      onBackground: Color(0xFF000000),
      surface: Color(0xFFF3F3F3),
      onSurface: Color(0xFF000000),
      surfaceVariant: Color(0xFF515151),
      onSurfaceVariant: Color(0xFFFFFFFF),
      surfaceTint: Color(0xFFFFFFFF));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.background,
          foregroundColor: colorScheme.onBackground,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedIconTheme: IconThemeData(color: colorScheme.secondary),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedItemColor: colorScheme.onBackground,
            type: BottomNavigationBarType.fixed),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)))),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(colorScheme.surface),
              shape: MaterialStateProperty.resolveWith((states) {
                double borderRadius = 20;
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius));
              }),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(20, 10, 20, 10))),
        ),
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.all(TextStyle(color: colorScheme.secondary)))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return colorScheme.surface;
                }
                return colorScheme.primary;
              }),
              elevation: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled) ||
                    states.contains(MaterialState.pressed)) {
                  return 3;
                }
                return 0;
              }),
              shadowColor: MaterialStateProperty.all(colorScheme.primary),
              foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
              shape: MaterialStateProperty.resolveWith((states) {
                double borderRadius = 16;
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius));
              }),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(20, 10, 20, 10))),
        ),
        textTheme: TextTheme(
            bodyMedium:
                GoogleFonts.inter(textStyle: const TextStyle(fontSize: 16)),
            bodyLarge:
                GoogleFonts.inter(textStyle: const TextStyle(fontSize: 20)),
            titleLarge: GoogleFonts.inter(
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            displaySmall: GoogleFonts.inter(
                textStyle:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            labelMedium: GoogleFonts.inter(),
            labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        popupMenuTheme: PopupMenuThemeData(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            surfaceTintColor: colorScheme.background),
        cardTheme: const CardTheme(elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: "Inter", color: const Color(0x4B000000)),
          border: MaterialStateOutlineInputBorder.resolveWith((states) =>
              OutlineInputBorder(
                  borderSide:
                      BorderSide(color: colorScheme.background, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(16)))),
          focusedBorder: MaterialStateOutlineInputBorder.resolveWith((states) =>
              states.contains(MaterialState.focused)
                  ? OutlineInputBorder(
                      borderSide:
                          BorderSide(color: colorScheme.background, width: 1),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)))
                  : Theme.of(context).inputDecorationTheme.border!),
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: colorScheme.surface,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: "Inter", color: const Color(0x4B000000)),
        ),
        switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFFFFFFFF);
          }
          return const Color(0xFF000000);
        }), trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.secondary;
          }
          return colorScheme.surface;
        })),
        useMaterial3: true,
      ),
      home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: "Trang chủ"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart_outline), label: "Thống kê"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: "Cài đặt"),
            ],
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
          body: _pages[_selectedIndex]),
    );
  }
}
