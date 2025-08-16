import 'package:flutter/material.dart';

import '../../features/utils/constants/sizes.dart';

class SpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: Sizes.appBarHeight,
    left: Sizes.defaultSpace,
    right: Sizes.defaultSpace,
    bottom: Sizes.defaultSpace,
  );
}
