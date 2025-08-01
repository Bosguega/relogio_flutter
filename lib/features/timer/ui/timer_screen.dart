import 'package:flutter/material.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';
import 'timer_countdown_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const int valuesPerUnit = 60;
  static const int itemCount = 10000;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;

  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 0;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final centerIndex = itemCount ~/ 2 - 20;
    _hourController = FixedExtentScrollController(initialItem: centerIndex);
    _minuteController = FixedExtentScrollController(initialItem: centerIndex);
    _secondController = FixedExtentScrollController(initialItem: centerIndex);
  }

  void _resetState() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();

    _initControllers();

    setState(() {
      selectedHour = 0;
      selectedMinute = 0;
      selectedSecond = 0;
    });
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  int _calculateTotalSeconds() {
    return selectedHour * 3600 + selectedMinute * 60 + selectedSecond;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              t.timer,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPicker(
                  label: t.horas,
                  controller: _hourController,
                  onChanged: (i) {
                    setState(() => selectedHour = i % valuesPerUnit);
                  },
                ),
                buildPicker(
                  label: t.min,
                  controller: _minuteController,
                  onChanged: (i) {
                    setState(() => selectedMinute = i % valuesPerUnit);
                  },
                ),
                buildPicker(
                  label: t.seg,
                  controller: _secondController,
                  onChanged: (i) {
                    setState(() => selectedSecond = i % valuesPerUnit);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final totalSeconds = _calculateTotalSeconds();
                if (totalSeconds == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.tempoMaiorZero)),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TimerCountdownScreen(
                      hours: selectedHour,
                      minutes: selectedMinute,
                      seconds: selectedSecond,
                    ),
                  ),
                ).then((_) {
                  _resetState();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent.shade400,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                t.iniciar,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPicker({
    required String label,
    required FixedExtentScrollController controller,
    required void Function(int) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,
            perspective: 0.005,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final value = index % valuesPerUnit;
                final isSelected = index == controller.selectedItem;

                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                      fontSize: isSelected ? 36 : 24,
                      color: isSelected
                          ? Colors.tealAccent.shade400
                          : Colors.white.withOpacity(0.3),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      shadows: isSelected
                          ? [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.tealAccent.shade200,
                                offset: const Offset(0, 0),
                              )
                            ]
                          : [],
                    ),
                    child: Text(value.toString().padLeft(2, '0')),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
