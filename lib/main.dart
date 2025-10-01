import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color _textColor = Colors.blue; // default text color

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeTextColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomePage(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
        textColor: _textColor,
        onChangeTextColor: _changeTextColor,
      ),
    );
  }
}

// Tabs with Swipe
class HomePage extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final Color textColor;
  final ValueChanged<Color> onChangeTextColor;

  const HomePage({
    Key? key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.textColor,
    required this.onChangeTextColor,
  }) : super(key: key);

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color pickerColor = textColor;
        return AlertDialog(
          title: const Text('Pick Text Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => pickerColor = color,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                onChangeTextColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeMode == ThemeMode.dark;

    return DefaultTabController(
      length: 3, // three tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Swipe Between Screens"),
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () => _openColorPicker(context),
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: onToggleTheme,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Fade Toggle"),
              Tab(text: "Auto Fade"),
              Tab(text: "Image Frame"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FadingTextAnimation1(textColor: textColor),
            FadingTextAnimation2(textColor: textColor),
            RoundedImageToggle(
              imagePath: 'assets/gum.png',
            ),
          ],
        ),
      ),
    );
  }
}

// First Tab
class FadingTextAnimation1 extends StatefulWidget {
  final Color textColor;
  const FadingTextAnimation1({required this.textColor});

  @override
  _FadingTextAnimation1State createState() => _FadingTextAnimation1State();
}

class _FadingTextAnimation1State extends State<FadingTextAnimation1> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 2),
            child: Text(
              'Hello, Humans!',
              style: TextStyle(fontSize: 24, color: widget.textColor),
            ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: toggleVisibility,
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}

// Second Tab
class FadingTextAnimation2 extends StatefulWidget {
  final Color textColor;
  const FadingTextAnimation2({required this.textColor});

  @override
  _FadingTextAnimation2State createState() => _FadingTextAnimation2State();
}

class _FadingTextAnimation2State extends State<FadingTextAnimation2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          'Boo!',
          style: TextStyle(fontSize: 48, color: widget.textColor),
        ),
      ),
    );
  }
}

// Third Tab: Image with Rounded Corners + Frame Toggle ONLY
class RoundedImageToggle extends StatefulWidget {
  final String imagePath;
  const RoundedImageToggle({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _RoundedImageToggleState createState() => _RoundedImageToggleState();
}

class _RoundedImageToggleState extends State<RoundedImageToggle> {
  bool _showFrame = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border:
                  _showFrame ? Border.all(color: Colors.blue, width: 4) : null,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              widget.imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Show Frame"),
              Switch(
                value: _showFrame,
                onChanged: (value) {
                  setState(() {
                    _showFrame = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
