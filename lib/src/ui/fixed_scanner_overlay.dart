import 'package:flutter/material.dart';

import '../../flutter_zxing.dart';

class FixedScannerOverlay extends ScannerOverlay {

  const FixedScannerOverlay({
    super.borderColor,
    super.borderWidth,
    super.overlayColor,
    super.borderRadius,
    super.borderLength,
    this.cutOutSize = 250
  }) : assert(borderLength <= cutOutSize / 2 + borderWidth * 2,
  "Border can't be larger than ${cutOutSize / 2 + borderWidth * 2}");

  @override
  final double cutOutSize;


  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final double width = rect.width;
    final double borderWidthSize = width / 2;
    final double height = rect.height;
    final double borderOffset = borderWidth / 2;
    final double newBorderLength =
    borderLength > cutOutSize / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : borderLength;
    final double newCutOutSize =
    cutOutSize < width ? cutOutSize : width - borderOffset;

    final Paint backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Paint boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final Rect cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - newCutOutSize / 2 + borderOffset,
      rect.top + height / 2 - newCutOutSize / 2 + borderOffset,
      newCutOutSize - borderOffset * 2,
      newCutOutSize - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
    // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - newBorderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + newBorderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + newBorderLength,
          cutOutRect.top + newBorderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - newBorderLength,
          cutOutRect.bottom - newBorderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - newBorderLength,
          cutOutRect.left + newBorderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  FixedScannerOverlay scale(double t) {
    return FixedScannerOverlay(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      overlayColor: overlayColor,
    );
  }
}
