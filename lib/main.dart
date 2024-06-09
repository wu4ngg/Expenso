import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hdmgr/pages/home_screen.dart';
import 'package:hdmgr/pages/settings_screen.dart';
import 'package:path/path.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

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
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      surfaceContainerHighest: Color(0xFF515151),
      onSurfaceVariant: Color(0xFFFFFFFF),
      surfaceTint: Color(0xFFF1F1F1));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedIconTheme: IconThemeData(color: colorScheme.secondary),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedItemColor: colorScheme.onSurface,
            type: BottomNavigationBarType.fixed),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.all(10)))),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(colorScheme.surfaceTint),
              shape: WidgetStateProperty.resolveWith((states) {
                double borderRadius = 20;
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius));
              }),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.fromLTRB(20, 10, 20, 10))),
        ),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                    TextStyle(color: colorScheme.secondary)))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return colorScheme.surfaceTint;
                }
                return colorScheme.primary;
              }),
              elevation: WidgetStateProperty.resolveWith((states) {
                if (!states.contains(WidgetState.disabled) ||
                    states.contains(WidgetState.pressed)) {
                  return 3;
                }
                return 0;
              }),
              shadowColor: WidgetStateProperty.all(colorScheme.primary),
              foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
              shape: WidgetStateProperty.resolveWith((states) {
                double borderRadius = 20;
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius));
              }),
              padding: WidgetStateProperty.all(
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
            titleMedium: GoogleFonts.inter(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            bodySmall: GoogleFonts.inter(
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            displaySmall: GoogleFonts.inter(
                textStyle:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            labelMedium: GoogleFonts.inter(),
            labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        popupMenuTheme: PopupMenuThemeData(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            surfaceTintColor: colorScheme.surface),
        cardTheme: const CardTheme(elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: "Inter", color: const Color(0x4B000000)),
          border: MaterialStateOutlineInputBorder.resolveWith((states) =>
              OutlineInputBorder(
                  borderSide:
                      BorderSide(color: colorScheme.surfaceTint, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(16)))),
          focusedBorder: MaterialStateOutlineInputBorder.resolveWith((states) =>
              states.contains(WidgetState.focused)
                  ? OutlineInputBorder(
                      borderSide:
                          BorderSide(color: colorScheme.surfaceTint, width: 1),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)))
                  : Theme.of(context).inputDecorationTheme.border!),
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: colorScheme.surfaceTint,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: "Inter", color: const Color(0x4B000000)),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((states) {
            if(states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surface;
          },
          ), 
          
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.all(8))
          )
        ),
        switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFFFFFFF);
          }
          return const Color(0xFF000000);
        }), trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondary;
          }
          return colorScheme.surface;
        })),
        listTileTheme: ListTileThemeData(
          subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
          iconColor: colorScheme.onBackground
        ),
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
