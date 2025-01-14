import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/circular_container.dart';
import 'package:project_uas/common/widgets/custom_shape/curved_edges/curved_edges.dart';
import 'package:project_uas/utils/constants/colors.dart';

class BPrimaryHeaderContainer extends StatelessWidget {
  const BPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BCustomCurvedEdges(),
      child: Container(
        color: BColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(top: -150, right: -250, child: BCircularContainer(backgroundColor: BColors.textWhite.withOpacity(0.1))),
              Positioned(top: 100, right: -300, child: BCircularContainer(backgroundColor: BColors.textWhite.withOpacity(0.1))),
              child,
            ]
          ),
        ), 
      ), 
    );
  }
}