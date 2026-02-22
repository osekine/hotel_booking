import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Failure mapOperationException(OperationException ex) {
  if (ex.linkException != null) {
    return NetworkFailure(ex.linkException.toString());
  }

  if (ex.graphqlErrors.isNotEmpty) {
    final err = ex.graphqlErrors.first;
    final code = err.extensions?['code'];
    if (code == 'CONFLICT') {
      final count = (err.extensions?['conflictsCount'] as int?) ?? 0;
      return BookingConflictFailure(conflictsCount: count);
    }
    return UnknownFailure(err.message);
  }

  return UnknownFailure(ex.toString());
}
