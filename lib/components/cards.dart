import 'package:flutter/material.dart';

class SoftCard extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget child;
  const SoftCard(
      {Key? key,
      this.width,
      this.height,
      required this.margin,
      required this.padding,
      required this.borderRadius,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: (width == null && height == null)
            ? null
            : (width != null && height != null)
                ? BoxConstraints.tight(Size(width!, height!))
                : (width != null)
                    ? BoxConstraints(minWidth: width!, maxWidth: width!)
                    : BoxConstraints(minHeight: height!, maxHeight: height!),
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: Border.all(
                color: const Color.fromRGBO(97, 104, 117, 0.2), width: 1.0),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 41, 59, 0.098),
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0)
            ]),
        child: child);
  }
}

class PrimaryCard extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget child;
  const PrimaryCard(
      {Key? key,
      this.width,
      this.height,
      required this.margin,
      required this.padding,
      required this.borderRadius,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: (width == null && height == null)
            ? null
            : (width != null && height != null)
                ? BoxConstraints.tight(Size(width!, height!))
                : (width != null)
                    ? BoxConstraints(minWidth: width!, maxWidth: width!)
                    : BoxConstraints(minHeight: height!, maxHeight: height!),
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(235, 239, 248, 1),
            borderRadius: borderRadius,
            border: Border.all(
                color: const Color.fromRGBO(97, 104, 117, 0.2), width: 1.0),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 41, 59, 0.1),
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0)
            ]),
        child: child);
  }
}
