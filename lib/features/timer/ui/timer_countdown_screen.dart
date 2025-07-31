import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TimerCountdownScreen extends StatefulWidget {
  final int hours;
  final int minutes;
  final int seconds;

  const TimerCountdownScreen({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  State<TimerCountdownScreen> createState() => _TimerCountdownScreenState();
}

class _TimerCountdownScreenState extends State<TimerCountdownScreen> {
  late Duration _remainingDuration;
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingDuration = Duration(
      hours: widget.hours,
      minutes: widget.minutes,
      seconds: widget.seconds,
    );
    _audioPlayer = AudioPlayer();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds == 0) {
        _timer?.cancel();
        _onTimerFinished();
      } else {
        setState(() {
          _remainingDuration -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    }
  }

  void _resumeTimer() {
    if (!_isRunning && _remainingDuration.inSeconds > 0) {
      _startTimer();
    }
  }

  Future<void> _playLoopingSound() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/timer_end.mp3'));
    } catch (e) {
      debugPrint('Erro ao tocar som: $e');
    }
  }

  Future<void> _stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Erro ao parar som: $e');
    }
  }

  /// 🔁 Método reutilizável para parar som, cancelar timer e voltar
  Future<void> _cancelarETerminar() async {
    _timer?.cancel();
    await _stopSound();
    if (mounted) {
      Navigator.of(context).pop(); // volta para TimerScreen
    }
  }

  void _onTimerFinished() async {
    await _playLoopingSound();
    _showTimerFinishedDialog();
  }

  void _showTimerFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Timer finalizado!'),
          content: const Text('O tempo terminou.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Fecha o alerta
                await Future.delayed(const Duration(milliseconds: 300));
                await _cancelarETerminar(); // Simula "Cancelar"
              },
              child: const Text('Desligar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o alerta
                setState(() {
                  _remainingDuration = Duration(
                    hours: widget.hours,
                    minutes: widget.minutes,
                    seconds: widget.seconds,
                  );
                });
                _startTimer();
              },
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(duration.inHours);
    final m = twoDigits(duration.inMinutes.remainder(60));
    final s = twoDigits(duration.inSeconds.remainder(60));
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds =
        widget.hours * 3600 + widget.minutes * 60 + widget.seconds;
    final progress = totalSeconds > 0
        ? 1.0 - (_remainingDuration.inSeconds / totalSeconds)
        : 0.0;

    final endTime = DateTime.now().add(_remainingDuration);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Timer'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tempo escolhido: ${_formatDuration(Duration(
                  hours: widget.hours,
                  minutes: widget.minutes,
                  seconds: widget.seconds,
                ))}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      color: Colors.tealAccent.shade400,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Text(
                    _formatDuration(_remainingDuration),
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.tealAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Hora provável do término: ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _isRunning ? _pauseTimer() : _resumeTimer();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.shade400,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isRunning ? 'Pausar' : 'Continuar',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: _cancelarETerminar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
