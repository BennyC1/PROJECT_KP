import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/curved_edges/curved_edges.dart';

class BCurvedEdgesWidget extends StatelessWidget {
  const BCurvedEdgesWidget({
  super . key,
  required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BCustomCurvedEdges(),
      child: child,
    );
  }
}