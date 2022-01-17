import 'dart:ui';

class ScrollConfig {
  ScrollConfig({
    this.useScrollBar = true,
    this.thickness,
    this.hoverThickness,
    this.isAlwaysShown,
    this.showTrackOnHover,
    this.interactive,
    this.radius,
  });

  bool useScrollBar;
  double? thickness;
  double? hoverThickness;
  bool? isAlwaysShown;
  bool? showTrackOnHover;
  bool? interactive;
  Radius? radius;
}
