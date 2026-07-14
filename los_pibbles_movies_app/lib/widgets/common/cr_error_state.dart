import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:los_pibbles_movies_app/domain/entities/app_exception.dart';
import '../../theme/app_colors.dart';
import 'cr_button.dart';

class _NoInternetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final baseY = h * 0.68;

    const startAngle = 210 * math.pi / 180;
    const sweepAngle = 120 * math.pi / 180;

    canvas.drawCircle(
      Offset(cx, baseY + 11),
      5.5,
      Paint()
        ..color = AppColors.primary500
        ..style = PaintingStyle.fill,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, baseY + 1), radius: 18),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = AppColors.primary500
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, baseY + 1), radius: 31),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = AppColors.primary400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, baseY + 1), radius: 44),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = AppColors.primary100.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );

    final slash = Paint()
      ..color = AppColors.error
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - 22, baseY - 26),
      Offset(cx + 22, baseY + 6),
      slash,
    );
    canvas.drawLine(
      Offset(cx + 22, baseY - 26),
      Offset(cx - 22, baseY + 6),
      slash,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotFoundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final ringPaint = Paint()
      ..color = AppColors.primary500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    canvas.drawCircle(Offset(cx, cy), 36, ringPaint);

    canvas.drawCircle(Offset(cx, cy), 13, ringPaint);

    const holeCount = 8;
    final dotPaint = Paint()
      ..color = AppColors.primary400
      ..style = PaintingStyle.fill;
    for (int i = 0; i < holeCount; i++) {
      final angle = i * 2 * math.pi / holeCount - math.pi / 2;
      final dx = cx + 25 * math.cos(angle);
      final dy = cy + 25 * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), 3.8, dotPaint);
    }

    final crackPaint = Paint()
      ..color = AppColors.accent500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final crack = Path()
      ..moveTo(cx - 33, cy - 8)
      ..lineTo(cx - 14, cy + 6)
      ..lineTo(cx - 4, cy - 14)
      ..lineTo(cx + 11, cy + 6)
      ..lineTo(cx + 33, cy - 3);
    canvas.drawPath(crack, crackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ServerErrorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 5), width: 58, height: 68),
      const Radius.circular(8),
    );

    final boxFill = Paint()
      ..color = AppColors.secondary700
      ..style = PaintingStyle.fill;
    canvas.drawRRect(boxRect, boxFill);

    final boxOutline = Paint()
      ..color = AppColors.primary500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(boxRect, boxOutline);

    final ventPaint = Paint()
      ..color = AppColors.secondary800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < 5; i++) {
      final y = cy - 16 + i * 9;
      canvas.drawLine(Offset(cx - 18, y), Offset(cx + 18, y), ventPaint);
    }

    canvas.drawCircle(
      Offset(cx - 14, cy + 19),
      3,
      Paint()..color = AppColors.success..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx - 14, cy + 27),
      3,
      Paint()..color = AppColors.warning..style = PaintingStyle.fill,
    );

    final tri = Path()
      ..moveTo(cx, cy - 43)
      ..lineTo(cx + 18, cy - 20)
      ..lineTo(cx - 18, cy - 20)
      ..close();
    canvas.drawPath(
      tri,
      Paint()..color = AppColors.error..style = PaintingStyle.fill,
    );

    final exPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - 36), Offset(cx, cy - 28), exPaint);
    canvas.drawCircle(
      Offset(cx, cy - 24),
      1.5,
      Paint()..color = AppColors.white..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CrErrorState extends StatefulWidget {
  final AppErrorType type;
  final VoidCallback? onRetry;

  const CrErrorState({
    super.key,
    required this.type,
    this.onRetry,
  });

  @override
  State<CrErrorState> createState() => _CrErrorStateState();
}

class _CrErrorStateState extends State<CrErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CustomPainter _buildPainter() {
    switch (widget.type) {
      case AppErrorType.noInternet:
        return _NoInternetPainter();
      case AppErrorType.notFound:
        return _NotFoundPainter();
      case AppErrorType.serverError:
      case AppErrorType.unknown:
        return _ServerErrorPainter();
    }
  }

  Color _borderColor() {
    switch (widget.type) {
      case AppErrorType.noInternet:
        return AppColors.warning.withOpacity(0.4);
      case AppErrorType.notFound:
        return AppColors.info.withOpacity(0.4);
      case AppErrorType.serverError:
      case AppErrorType.unknown:
        return AppColors.error.withOpacity(0.4);
    }
  }

  String _title() {
    switch (widget.type) {
      case AppErrorType.noInternet:
        return 'Sin conexión';
      case AppErrorType.notFound:
        return 'No encontrado';
      case AppErrorType.serverError:
        return 'Error del servidor';
      case AppErrorType.unknown:
        return 'Algo salió mal';
    }
  }

  String _subtitle() {
    switch (widget.type) {
      case AppErrorType.noInternet:
        return 'Parece que no tienes internet.\nRevisa tu conexión e inténtalo de nuevo.';
      case AppErrorType.notFound:
        return 'No pudimos encontrar lo que buscas.\nIntenta con otra búsqueda.';
      case AppErrorType.serverError:
        return 'Tuvimos un problema en el servidor.\nEstamos trabajando para solucionarlo.';
      case AppErrorType.unknown:
        return 'Ocurrió un error inesperado.\nPor favor inténtalo de nuevo.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.secondary900,
                    shape: BoxShape.circle,
                    border: Border.all(color: _borderColor()),
                  ),
                  child: CustomPaint(
                    painter: _buildPainter(),
                    size: const Size(120, 120),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _title(),
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    _subtitle(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 32),
                  CrButton.primary(
                    label: 'Reintentar',
                    onPressed: widget.onRetry!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
