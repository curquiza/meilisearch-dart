import 'dart:convert';

import 'filter_builder_base.dart';

class MeiliNumberValueExpression extends MeiliValueExpressionBase {
  final num value;

  const MeiliNumberValueExpression(this.value);

  @override
  String transform() => value.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliNumberValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MeiliDateTimeValueExpression extends MeiliValueExpressionBase {
  final DateTime value;
  MeiliDateTimeValueExpression(this.value)
      : assert(
          value.isUtc,
          "DateTime passed to Meili must be in UTC to avoid inconsistency accross multiple devices",
        );

  /// Unix epoch time is seconds since epoch
  @override
  String transform() =>
      (value.millisecondsSinceEpoch / 1000).floor().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliDateTimeValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MeiliBooleanValueExpression extends MeiliValueExpressionBase {
  final bool value;

  const MeiliBooleanValueExpression(this.value);

  @override
  String transform() {
    return value.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliBooleanValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MeiliStringValueExpression extends MeiliValueExpressionBase {
  final String value;

  const MeiliStringValueExpression(this.value);

  @override
  String transform() {
    return jsonEncode(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliStringValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
