import 'package:flutter/material.dart';

class RefreshIndicatorConfig {
  RefreshIndicatorConfig({
    this.color,
    this.backgroundColor,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.showRefreshIndicator = true,
    this.strokeWidth = 2.0,
    this.displacement = 40.0,
    this.edgeOffset,
  });

  Color? color;
  Color? backgroundColor;
  RefreshIndicatorTriggerMode triggerMode;
  bool showRefreshIndicator;
  double strokeWidth;
  double displacement;
  double? edgeOffset;
}
