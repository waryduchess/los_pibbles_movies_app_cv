import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';

final AudioPlayer splashAudioPlayer = AudioPlayer();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _loadingController;

  late Animation<double> _glowOpacity;
  late Animation<double> _glowScale;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;

  late Animation<double> _textOpacity;
  late Animation<double> _textOffset;

  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _playIntroAudio();
    _startSplashSequence();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _glowOpacity =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 0.7,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 0.7,
              end: 0.35,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.8),
          ),
        );

    _glowScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.6,
              end: 1.4,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 60,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.4,
              end: 1.6,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 40,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.8),
          ),
        );

    _logoScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.4,
              end: 1.1,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 30,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.1,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 20,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.0,
              end: 1.04,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.04,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 18,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.93),
          ),
        );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _logoRotation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: -8.0 * (math.pi / 180),
              end: 2.0 * (math.pi / 180),
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 2.0 * (math.pi / 180),
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.93),
          ),
        );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );

    _textOffset = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _mainController.forward();
  }

  Future<void> _playIntroAudio() async {
    try {
      await splashAudioPlayer.setVolume(0.35);
      splashAudioPlayer.audioCache.prefix = '';
      await splashAudioPlayer.play(
        AssetSource('lib/resources/audio/Pibbles.mp3'),
      );
    } catch (e) {
      debugPrint(
        "El autoplay está bloqueado o el audio no se encontró, splash silencioso.",
      );
    }
  }

  void _startSplashSequence() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isFadingOut = true);
      }
      _fadeOutAudio();
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) context.go('/login');
      });
    });
  }

  void _fadeOutAudio() {
    const int steps = 30;
    const int stepDurationMs = 50;
    const double initialVol = 0.35;
    final double volStep = initialVol / steps;
    double currentVol = initialVol;

    Timer.periodic(const Duration(milliseconds: stepDurationMs), (timer) {
      currentVol -= volStep;
      if (currentVol <= 0) {
        currentVol = 0;
        splashAudioPlayer.pause();
        timer.cancel();
      }
      splashAudioPlayer.setVolume(currentVol);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E17),
      body: AnimatedOpacity(
        opacity: _isFadingOut ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 700),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Opacity(
                  opacity: _glowOpacity.value,
                  child: Transform.scale(
                    scale: _glowScale.value,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        width: 420,
                        height: 420,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color(0x8C675CFF),
                              Color(0x38FF5C8A),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xA6675CFF),
                                  blurRadius: 30,
                                ),
                                BoxShadow(
                                  color: Color(0x59FF5C8A),
                                  blurRadius: 60,
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage(
                                  'lib/resources/images/logo.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _textOffset.value),
                        child: Text(
                          'Pibble Movies',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFF1EDFF),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 22 * 0.04,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    final double barOpacity = _mainController.value > 0.5
                        ? 1.0
                        : 0.0;
                    return AnimatedOpacity(
                      opacity: barOpacity,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: 120,
                        height: 2,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: AnimatedBuilder(
                          animation: _loadingController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                -60.0 + (_loadingController.value * 180.0),
                                0,
                              ),
                              child: Container(
                                width: 60,
                                height: 2,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF675CFF),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
