// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:ostrum_test/presentation/feature/ostrum_comments/pages/ostrum_comments_page.dart'
    as _i1;

/// generated route for
/// [_i1.OstrumCommentsPage]
class OstrumCommentsRoute extends _i2.PageRouteInfo<OstrumCommentsRouteArgs> {
  OstrumCommentsRoute({_i3.Key? key, List<_i2.PageRouteInfo>? children})
    : super(
        OstrumCommentsRoute.name,
        args: OstrumCommentsRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'OstrumCommentsRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OstrumCommentsRouteArgs>(
        orElse: () => const OstrumCommentsRouteArgs(),
      );
      return _i1.OstrumCommentsPage(key: args.key);
    },
  );
}

class OstrumCommentsRouteArgs {
  const OstrumCommentsRouteArgs({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return 'OstrumCommentsRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OstrumCommentsRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}
