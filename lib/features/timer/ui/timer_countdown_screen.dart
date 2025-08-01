import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';

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

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingDuration.inSeconds <= 0) {
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

  Future<void> _cancelarETerminar() async {
    _timer?.cancel();
    await _stopSound();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onTimerFinished() async {
    await _playLoopingSound();
    _showTimerFinishedDialog();
  }

  void _showTimerFinishedDialog() {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(t.timerFinalizado),
          content: Text(t.tempoTerminado),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(milliseconds: 200));
                await _cancelarETerminar();
              },
              child: Text(t.desligar),
            ),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _remainingDuration = Duration(
                    hours: widget.hours,
                    minutes: widget.minutes,
                    seconds: widget.seconds,
                  );
                });
                _startTimer();
              },
              child: Text(t.reiniciar),
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
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final totalSeconds =
        widget.hours * 3600 + widget.minutes * 60 + widget.seconds;
    final progress = totalSeconds > 0
        ? 1.0 - (_remainingDuration.inSeconds / totalSeconds)
        : 0.0;

    final endTime = DateTime.now().add(_remainingDuration);
    final endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(t.timer),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${t.tempoEscolhido}: ${_formatDuration(Duration(hours: widget.hours, minutes: widget.minutes, seconds: widget.seconds))}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 14,
                      color: scheme.primary,
                      backgroundColor: scheme.surfaceContainerHighest,
                    ),
                  ),
                  Text(
                    _formatDuration(_remainingDuration),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '${t.horaProvavelTermino}: $endTimeStr',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        _isRunning ? _pauseTimer() : _resumeTimer();
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _isRunning ? t.pausar : t.continuar,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelarETerminar,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.error,
                        side: BorderSide(color: scheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        t.cancelar,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
