import '../schema.graphql.dart';
import 'dart:async';
import 'package:api_client/src/graphql/client_factory.dart';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Variables$Query$GetAvailability {
  factory Variables$Query$GetAvailability({
    required String roomId,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      Variables$Query$GetAvailability._({
        r'roomId': roomId,
        r'startDate': startDate,
        r'endDate': endDate,
      });

  Variables$Query$GetAvailability._(this._$data);

  factory Variables$Query$GetAvailability.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$roomId = data['roomId'];
    result$data['roomId'] = (l$roomId as String);
    final l$startDate = data['startDate'];
    result$data['startDate'] = fromJsonDateTime(l$startDate);
    final l$endDate = data['endDate'];
    result$data['endDate'] = fromJsonDateTime(l$endDate);
    return Variables$Query$GetAvailability._(result$data);
  }

  Map<String, dynamic> _$data;

  String get roomId => (_$data['roomId'] as String);

  DateTime get startDate => (_$data['startDate'] as DateTime);

  DateTime get endDate => (_$data['endDate'] as DateTime);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$roomId = roomId;
    result$data['roomId'] = l$roomId;
    final l$startDate = startDate;
    result$data['startDate'] = toJsonDateTime(l$startDate);
    final l$endDate = endDate;
    result$data['endDate'] = toJsonDateTime(l$endDate);
    return result$data;
  }

  CopyWith$Variables$Query$GetAvailability<Variables$Query$GetAvailability>
      get copyWith => CopyWith$Variables$Query$GetAvailability(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetAvailability ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$roomId = roomId;
    final lOther$roomId = other.roomId;
    if (l$roomId != lOther$roomId) {
      return false;
    }
    final l$startDate = startDate;
    final lOther$startDate = other.startDate;
    if (l$startDate != lOther$startDate) {
      return false;
    }
    final l$endDate = endDate;
    final lOther$endDate = other.endDate;
    if (l$endDate != lOther$endDate) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$roomId = roomId;
    final l$startDate = startDate;
    final l$endDate = endDate;
    return Object.hashAll([
      l$roomId,
      l$startDate,
      l$endDate,
    ]);
  }
}

abstract class CopyWith$Variables$Query$GetAvailability<TRes> {
  factory CopyWith$Variables$Query$GetAvailability(
    Variables$Query$GetAvailability instance,
    TRes Function(Variables$Query$GetAvailability) then,
  ) = _CopyWithImpl$Variables$Query$GetAvailability;

  factory CopyWith$Variables$Query$GetAvailability.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetAvailability;

  TRes call({
    String? roomId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class _CopyWithImpl$Variables$Query$GetAvailability<TRes>
    implements CopyWith$Variables$Query$GetAvailability<TRes> {
  _CopyWithImpl$Variables$Query$GetAvailability(
    this._instance,
    this._then,
  );

  final Variables$Query$GetAvailability _instance;

  final TRes Function(Variables$Query$GetAvailability) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? roomId = _undefined,
    Object? startDate = _undefined,
    Object? endDate = _undefined,
  }) =>
      _then(Variables$Query$GetAvailability._({
        ..._instance._$data,
        if (roomId != _undefined && roomId != null)
          'roomId': (roomId as String),
        if (startDate != _undefined && startDate != null)
          'startDate': (startDate as DateTime),
        if (endDate != _undefined && endDate != null)
          'endDate': (endDate as DateTime),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetAvailability<TRes>
    implements CopyWith$Variables$Query$GetAvailability<TRes> {
  _CopyWithStubImpl$Variables$Query$GetAvailability(this._res);

  TRes _res;

  call({
    String? roomId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      _res;
}

class Query$GetAvailability {
  Query$GetAvailability({
    required this.availability,
    this.$__typename = 'Query',
  });

  factory Query$GetAvailability.fromJson(Map<String, dynamic> json) {
    final l$availability = json['availability'];
    final l$$__typename = json['__typename'];
    return Query$GetAvailability(
      availability: Query$GetAvailability$availability.fromJson(
          (l$availability as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetAvailability$availability availability;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$availability = availability;
    _resultData['availability'] = l$availability.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$availability = availability;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$availability,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetAvailability || runtimeType != other.runtimeType) {
      return false;
    }
    final l$availability = availability;
    final lOther$availability = other.availability;
    if (l$availability != lOther$availability) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetAvailability on Query$GetAvailability {
  CopyWith$Query$GetAvailability<Query$GetAvailability> get copyWith =>
      CopyWith$Query$GetAvailability(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetAvailability<TRes> {
  factory CopyWith$Query$GetAvailability(
    Query$GetAvailability instance,
    TRes Function(Query$GetAvailability) then,
  ) = _CopyWithImpl$Query$GetAvailability;

  factory CopyWith$Query$GetAvailability.stub(TRes res) =
      _CopyWithStubImpl$Query$GetAvailability;

  TRes call({
    Query$GetAvailability$availability? availability,
    String? $__typename,
  });
  CopyWith$Query$GetAvailability$availability<TRes> get availability;
}

class _CopyWithImpl$Query$GetAvailability<TRes>
    implements CopyWith$Query$GetAvailability<TRes> {
  _CopyWithImpl$Query$GetAvailability(
    this._instance,
    this._then,
  );

  final Query$GetAvailability _instance;

  final TRes Function(Query$GetAvailability) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? availability = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetAvailability(
        availability: availability == _undefined || availability == null
            ? _instance.availability
            : (availability as Query$GetAvailability$availability),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetAvailability$availability<TRes> get availability {
    final local$availability = _instance.availability;
    return CopyWith$Query$GetAvailability$availability(
        local$availability, (e) => call(availability: e));
  }
}

class _CopyWithStubImpl$Query$GetAvailability<TRes>
    implements CopyWith$Query$GetAvailability<TRes> {
  _CopyWithStubImpl$Query$GetAvailability(this._res);

  TRes _res;

  call({
    Query$GetAvailability$availability? availability,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetAvailability$availability<TRes> get availability =>
      CopyWith$Query$GetAvailability$availability.stub(_res);
}

const documentNodeQueryGetAvailability = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetAvailability'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'roomId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'startDate')),
        type: NamedTypeNode(
          name: NameNode(value: 'DateTime'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'endDate')),
        type: NamedTypeNode(
          name: NameNode(value: 'DateTime'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'availability'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'roomId'),
            value: VariableNode(name: NameNode(value: 'roomId')),
          ),
          ArgumentNode(
            name: NameNode(value: 'startDate'),
            value: VariableNode(name: NameNode(value: 'startDate')),
          ),
          ArgumentNode(
            name: NameNode(value: 'endDate'),
            value: VariableNode(name: NameNode(value: 'endDate')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'roomId'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'startDate'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'endDate'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'isAvailable'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'conflicts'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'id'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'guestName'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'startDate'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'endDate'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'status'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);
Query$GetAvailability _parserFn$Query$GetAvailability(
        Map<String, dynamic> data) =>
    Query$GetAvailability.fromJson(data);
typedef OnQueryComplete$Query$GetAvailability = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetAvailability?,
);

class Options$Query$GetAvailability
    extends graphql.QueryOptions<Query$GetAvailability> {
  Options$Query$GetAvailability({
    String? operationName,
    required Variables$Query$GetAvailability variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetAvailability? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetAvailability? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          pollInterval: pollInterval,
          context: context,
          onComplete: onComplete == null
              ? null
              : (data) => onComplete(
                    data,
                    data == null ? null : _parserFn$Query$GetAvailability(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetAvailability,
          parserFn: _parserFn$Query$GetAvailability,
        );

  final OnQueryComplete$Query$GetAvailability? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetAvailability
    extends graphql.WatchQueryOptions<Query$GetAvailability> {
  WatchOptions$Query$GetAvailability({
    String? operationName,
    required Variables$Query$GetAvailability variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetAvailability? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeQueryGetAvailability,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetAvailability,
        );
}

class FetchMoreOptions$Query$GetAvailability extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetAvailability({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetAvailability variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetAvailability,
        );
}

extension ClientExtension$Query$GetAvailability on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetAvailability>> query$GetAvailability(
          Options$Query$GetAvailability options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query$GetAvailability> watchQuery$GetAvailability(
          WatchOptions$Query$GetAvailability options) =>
      this.watchQuery(options);

  void writeQuery$GetAvailability({
    required Query$GetAvailability data,
    required Variables$Query$GetAvailability variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryGetAvailability),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$GetAvailability? readQuery$GetAvailability({
    required Variables$Query$GetAvailability variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation:
            graphql.Operation(document: documentNodeQueryGetAvailability),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetAvailability.fromJson(result);
  }
}

class Query$GetAvailability$availability {
  Query$GetAvailability$availability({
    required this.roomId,
    required this.startDate,
    required this.endDate,
    required this.isAvailable,
    required this.conflicts,
    this.$__typename = 'Availability',
  });

  factory Query$GetAvailability$availability.fromJson(
      Map<String, dynamic> json) {
    final l$roomId = json['roomId'];
    final l$startDate = json['startDate'];
    final l$endDate = json['endDate'];
    final l$isAvailable = json['isAvailable'];
    final l$conflicts = json['conflicts'];
    final l$$__typename = json['__typename'];
    return Query$GetAvailability$availability(
      roomId: (l$roomId as String),
      startDate: fromJsonDateTime(l$startDate),
      endDate: fromJsonDateTime(l$endDate),
      isAvailable: (l$isAvailable as bool),
      conflicts: (l$conflicts as List<dynamic>)
          .map((e) => Query$GetAvailability$availability$conflicts.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String roomId;

  final DateTime startDate;

  final DateTime endDate;

  final bool isAvailable;

  final List<Query$GetAvailability$availability$conflicts> conflicts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$roomId = roomId;
    _resultData['roomId'] = l$roomId;
    final l$startDate = startDate;
    _resultData['startDate'] = toJsonDateTime(l$startDate);
    final l$endDate = endDate;
    _resultData['endDate'] = toJsonDateTime(l$endDate);
    final l$isAvailable = isAvailable;
    _resultData['isAvailable'] = l$isAvailable;
    final l$conflicts = conflicts;
    _resultData['conflicts'] = l$conflicts.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$roomId = roomId;
    final l$startDate = startDate;
    final l$endDate = endDate;
    final l$isAvailable = isAvailable;
    final l$conflicts = conflicts;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$roomId,
      l$startDate,
      l$endDate,
      l$isAvailable,
      Object.hashAll(l$conflicts.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetAvailability$availability ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$roomId = roomId;
    final lOther$roomId = other.roomId;
    if (l$roomId != lOther$roomId) {
      return false;
    }
    final l$startDate = startDate;
    final lOther$startDate = other.startDate;
    if (l$startDate != lOther$startDate) {
      return false;
    }
    final l$endDate = endDate;
    final lOther$endDate = other.endDate;
    if (l$endDate != lOther$endDate) {
      return false;
    }
    final l$isAvailable = isAvailable;
    final lOther$isAvailable = other.isAvailable;
    if (l$isAvailable != lOther$isAvailable) {
      return false;
    }
    final l$conflicts = conflicts;
    final lOther$conflicts = other.conflicts;
    if (l$conflicts.length != lOther$conflicts.length) {
      return false;
    }
    for (int i = 0; i < l$conflicts.length; i++) {
      final l$conflicts$entry = l$conflicts[i];
      final lOther$conflicts$entry = lOther$conflicts[i];
      if (l$conflicts$entry != lOther$conflicts$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetAvailability$availability
    on Query$GetAvailability$availability {
  CopyWith$Query$GetAvailability$availability<
          Query$GetAvailability$availability>
      get copyWith => CopyWith$Query$GetAvailability$availability(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetAvailability$availability<TRes> {
  factory CopyWith$Query$GetAvailability$availability(
    Query$GetAvailability$availability instance,
    TRes Function(Query$GetAvailability$availability) then,
  ) = _CopyWithImpl$Query$GetAvailability$availability;

  factory CopyWith$Query$GetAvailability$availability.stub(TRes res) =
      _CopyWithStubImpl$Query$GetAvailability$availability;

  TRes call({
    String? roomId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAvailable,
    List<Query$GetAvailability$availability$conflicts>? conflicts,
    String? $__typename,
  });
  TRes conflicts(
      Iterable<Query$GetAvailability$availability$conflicts> Function(
              Iterable<
                  CopyWith$Query$GetAvailability$availability$conflicts<
                      Query$GetAvailability$availability$conflicts>>)
          _fn);
}

class _CopyWithImpl$Query$GetAvailability$availability<TRes>
    implements CopyWith$Query$GetAvailability$availability<TRes> {
  _CopyWithImpl$Query$GetAvailability$availability(
    this._instance,
    this._then,
  );

  final Query$GetAvailability$availability _instance;

  final TRes Function(Query$GetAvailability$availability) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? roomId = _undefined,
    Object? startDate = _undefined,
    Object? endDate = _undefined,
    Object? isAvailable = _undefined,
    Object? conflicts = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetAvailability$availability(
        roomId: roomId == _undefined || roomId == null
            ? _instance.roomId
            : (roomId as String),
        startDate: startDate == _undefined || startDate == null
            ? _instance.startDate
            : (startDate as DateTime),
        endDate: endDate == _undefined || endDate == null
            ? _instance.endDate
            : (endDate as DateTime),
        isAvailable: isAvailable == _undefined || isAvailable == null
            ? _instance.isAvailable
            : (isAvailable as bool),
        conflicts: conflicts == _undefined || conflicts == null
            ? _instance.conflicts
            : (conflicts as List<Query$GetAvailability$availability$conflicts>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes conflicts(
          Iterable<Query$GetAvailability$availability$conflicts> Function(
                  Iterable<
                      CopyWith$Query$GetAvailability$availability$conflicts<
                          Query$GetAvailability$availability$conflicts>>)
              _fn) =>
      call(
          conflicts: _fn(_instance.conflicts
              .map((e) => CopyWith$Query$GetAvailability$availability$conflicts(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetAvailability$availability<TRes>
    implements CopyWith$Query$GetAvailability$availability<TRes> {
  _CopyWithStubImpl$Query$GetAvailability$availability(this._res);

  TRes _res;

  call({
    String? roomId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAvailable,
    List<Query$GetAvailability$availability$conflicts>? conflicts,
    String? $__typename,
  }) =>
      _res;

  conflicts(_fn) => _res;
}

class Query$GetAvailability$availability$conflicts {
  Query$GetAvailability$availability$conflicts({
    required this.id,
    required this.guestName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.$__typename = 'Booking',
  });

  factory Query$GetAvailability$availability$conflicts.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$guestName = json['guestName'];
    final l$startDate = json['startDate'];
    final l$endDate = json['endDate'];
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Query$GetAvailability$availability$conflicts(
      id: (l$id as String),
      guestName: (l$guestName as String),
      startDate: fromJsonDateTime(l$startDate),
      endDate: fromJsonDateTime(l$endDate),
      status: fromJson$Enum$BookingStatus((l$status as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String guestName;

  final DateTime startDate;

  final DateTime endDate;

  final Enum$BookingStatus status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$guestName = guestName;
    _resultData['guestName'] = l$guestName;
    final l$startDate = startDate;
    _resultData['startDate'] = toJsonDateTime(l$startDate);
    final l$endDate = endDate;
    _resultData['endDate'] = toJsonDateTime(l$endDate);
    final l$status = status;
    _resultData['status'] = toJson$Enum$BookingStatus(l$status);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$guestName = guestName;
    final l$startDate = startDate;
    final l$endDate = endDate;
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$guestName,
      l$startDate,
      l$endDate,
      l$status,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetAvailability$availability$conflicts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$guestName = guestName;
    final lOther$guestName = other.guestName;
    if (l$guestName != lOther$guestName) {
      return false;
    }
    final l$startDate = startDate;
    final lOther$startDate = other.startDate;
    if (l$startDate != lOther$startDate) {
      return false;
    }
    final l$endDate = endDate;
    final lOther$endDate = other.endDate;
    if (l$endDate != lOther$endDate) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetAvailability$availability$conflicts
    on Query$GetAvailability$availability$conflicts {
  CopyWith$Query$GetAvailability$availability$conflicts<
          Query$GetAvailability$availability$conflicts>
      get copyWith => CopyWith$Query$GetAvailability$availability$conflicts(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetAvailability$availability$conflicts<TRes> {
  factory CopyWith$Query$GetAvailability$availability$conflicts(
    Query$GetAvailability$availability$conflicts instance,
    TRes Function(Query$GetAvailability$availability$conflicts) then,
  ) = _CopyWithImpl$Query$GetAvailability$availability$conflicts;

  factory CopyWith$Query$GetAvailability$availability$conflicts.stub(TRes res) =
      _CopyWithStubImpl$Query$GetAvailability$availability$conflicts;

  TRes call({
    String? id,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
    Enum$BookingStatus? status,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetAvailability$availability$conflicts<TRes>
    implements CopyWith$Query$GetAvailability$availability$conflicts<TRes> {
  _CopyWithImpl$Query$GetAvailability$availability$conflicts(
    this._instance,
    this._then,
  );

  final Query$GetAvailability$availability$conflicts _instance;

  final TRes Function(Query$GetAvailability$availability$conflicts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? guestName = _undefined,
    Object? startDate = _undefined,
    Object? endDate = _undefined,
    Object? status = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetAvailability$availability$conflicts(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        guestName: guestName == _undefined || guestName == null
            ? _instance.guestName
            : (guestName as String),
        startDate: startDate == _undefined || startDate == null
            ? _instance.startDate
            : (startDate as DateTime),
        endDate: endDate == _undefined || endDate == null
            ? _instance.endDate
            : (endDate as DateTime),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$BookingStatus),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetAvailability$availability$conflicts<TRes>
    implements CopyWith$Query$GetAvailability$availability$conflicts<TRes> {
  _CopyWithStubImpl$Query$GetAvailability$availability$conflicts(this._res);

  TRes _res;

  call({
    String? id,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
    Enum$BookingStatus? status,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$CreateBooking {
  factory Variables$Mutation$CreateBooking({
    required String roomId,
    required String guestName,
    required DateTime startDate,
    required DateTime endDate,
  }) =>
      Variables$Mutation$CreateBooking._({
        r'roomId': roomId,
        r'guestName': guestName,
        r'startDate': startDate,
        r'endDate': endDate,
      });

  Variables$Mutation$CreateBooking._(this._$data);

  factory Variables$Mutation$CreateBooking.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$roomId = data['roomId'];
    result$data['roomId'] = (l$roomId as String);
    final l$guestName = data['guestName'];
    result$data['guestName'] = (l$guestName as String);
    final l$startDate = data['startDate'];
    result$data['startDate'] = fromJsonDateTime(l$startDate);
    final l$endDate = data['endDate'];
    result$data['endDate'] = fromJsonDateTime(l$endDate);
    return Variables$Mutation$CreateBooking._(result$data);
  }

  Map<String, dynamic> _$data;

  String get roomId => (_$data['roomId'] as String);

  String get guestName => (_$data['guestName'] as String);

  DateTime get startDate => (_$data['startDate'] as DateTime);

  DateTime get endDate => (_$data['endDate'] as DateTime);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$roomId = roomId;
    result$data['roomId'] = l$roomId;
    final l$guestName = guestName;
    result$data['guestName'] = l$guestName;
    final l$startDate = startDate;
    result$data['startDate'] = toJsonDateTime(l$startDate);
    final l$endDate = endDate;
    result$data['endDate'] = toJsonDateTime(l$endDate);
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateBooking<Variables$Mutation$CreateBooking>
      get copyWith => CopyWith$Variables$Mutation$CreateBooking(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateBooking ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$roomId = roomId;
    final lOther$roomId = other.roomId;
    if (l$roomId != lOther$roomId) {
      return false;
    }
    final l$guestName = guestName;
    final lOther$guestName = other.guestName;
    if (l$guestName != lOther$guestName) {
      return false;
    }
    final l$startDate = startDate;
    final lOther$startDate = other.startDate;
    if (l$startDate != lOther$startDate) {
      return false;
    }
    final l$endDate = endDate;
    final lOther$endDate = other.endDate;
    if (l$endDate != lOther$endDate) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$roomId = roomId;
    final l$guestName = guestName;
    final l$startDate = startDate;
    final l$endDate = endDate;
    return Object.hashAll([
      l$roomId,
      l$guestName,
      l$startDate,
      l$endDate,
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$CreateBooking<TRes> {
  factory CopyWith$Variables$Mutation$CreateBooking(
    Variables$Mutation$CreateBooking instance,
    TRes Function(Variables$Mutation$CreateBooking) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateBooking;

  factory CopyWith$Variables$Mutation$CreateBooking.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateBooking;

  TRes call({
    String? roomId,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class _CopyWithImpl$Variables$Mutation$CreateBooking<TRes>
    implements CopyWith$Variables$Mutation$CreateBooking<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateBooking(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreateBooking _instance;

  final TRes Function(Variables$Mutation$CreateBooking) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? roomId = _undefined,
    Object? guestName = _undefined,
    Object? startDate = _undefined,
    Object? endDate = _undefined,
  }) =>
      _then(Variables$Mutation$CreateBooking._({
        ..._instance._$data,
        if (roomId != _undefined && roomId != null)
          'roomId': (roomId as String),
        if (guestName != _undefined && guestName != null)
          'guestName': (guestName as String),
        if (startDate != _undefined && startDate != null)
          'startDate': (startDate as DateTime),
        if (endDate != _undefined && endDate != null)
          'endDate': (endDate as DateTime),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$CreateBooking<TRes>
    implements CopyWith$Variables$Mutation$CreateBooking<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateBooking(this._res);

  TRes _res;

  call({
    String? roomId,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      _res;
}

class Mutation$CreateBooking {
  Mutation$CreateBooking({
    required this.createBooking,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CreateBooking.fromJson(Map<String, dynamic> json) {
    final l$createBooking = json['createBooking'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateBooking(
      createBooking: Mutation$CreateBooking$createBooking.fromJson(
          (l$createBooking as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CreateBooking$createBooking createBooking;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createBooking = createBooking;
    _resultData['createBooking'] = l$createBooking.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createBooking = createBooking;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$createBooking,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateBooking || runtimeType != other.runtimeType) {
      return false;
    }
    final l$createBooking = createBooking;
    final lOther$createBooking = other.createBooking;
    if (l$createBooking != lOther$createBooking) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateBooking on Mutation$CreateBooking {
  CopyWith$Mutation$CreateBooking<Mutation$CreateBooking> get copyWith =>
      CopyWith$Mutation$CreateBooking(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateBooking<TRes> {
  factory CopyWith$Mutation$CreateBooking(
    Mutation$CreateBooking instance,
    TRes Function(Mutation$CreateBooking) then,
  ) = _CopyWithImpl$Mutation$CreateBooking;

  factory CopyWith$Mutation$CreateBooking.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateBooking;

  TRes call({
    Mutation$CreateBooking$createBooking? createBooking,
    String? $__typename,
  });
  CopyWith$Mutation$CreateBooking$createBooking<TRes> get createBooking;
}

class _CopyWithImpl$Mutation$CreateBooking<TRes>
    implements CopyWith$Mutation$CreateBooking<TRes> {
  _CopyWithImpl$Mutation$CreateBooking(
    this._instance,
    this._then,
  );

  final Mutation$CreateBooking _instance;

  final TRes Function(Mutation$CreateBooking) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createBooking = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CreateBooking(
        createBooking: createBooking == _undefined || createBooking == null
            ? _instance.createBooking
            : (createBooking as Mutation$CreateBooking$createBooking),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$CreateBooking$createBooking<TRes> get createBooking {
    final local$createBooking = _instance.createBooking;
    return CopyWith$Mutation$CreateBooking$createBooking(
        local$createBooking, (e) => call(createBooking: e));
  }
}

class _CopyWithStubImpl$Mutation$CreateBooking<TRes>
    implements CopyWith$Mutation$CreateBooking<TRes> {
  _CopyWithStubImpl$Mutation$CreateBooking(this._res);

  TRes _res;

  call({
    Mutation$CreateBooking$createBooking? createBooking,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$CreateBooking$createBooking<TRes> get createBooking =>
      CopyWith$Mutation$CreateBooking$createBooking.stub(_res);
}

const documentNodeMutationCreateBooking = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'CreateBooking'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'roomId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'guestName')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'startDate')),
        type: NamedTypeNode(
          name: NameNode(value: 'DateTime'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'endDate')),
        type: NamedTypeNode(
          name: NameNode(value: 'DateTime'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'createBooking'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'roomId'),
            value: VariableNode(name: NameNode(value: 'roomId')),
          ),
          ArgumentNode(
            name: NameNode(value: 'guestName'),
            value: VariableNode(name: NameNode(value: 'guestName')),
          ),
          ArgumentNode(
            name: NameNode(value: 'startDate'),
            value: VariableNode(name: NameNode(value: 'startDate')),
          ),
          ArgumentNode(
            name: NameNode(value: 'endDate'),
            value: VariableNode(name: NameNode(value: 'endDate')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'id'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'roomId'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'guestName'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'startDate'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'endDate'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'status'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'createdAt'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);
Mutation$CreateBooking _parserFn$Mutation$CreateBooking(
        Map<String, dynamic> data) =>
    Mutation$CreateBooking.fromJson(data);
typedef OnMutationCompleted$Mutation$CreateBooking = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$CreateBooking?,
);

class Options$Mutation$CreateBooking
    extends graphql.MutationOptions<Mutation$CreateBooking> {
  Options$Mutation$CreateBooking({
    String? operationName,
    required Variables$Mutation$CreateBooking variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateBooking? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$CreateBooking? onCompleted,
    graphql.OnMutationUpdate<Mutation$CreateBooking>? update,
    graphql.OnError? onError,
  })  : onCompletedWithParsed = onCompleted,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          onCompleted: onCompleted == null
              ? null
              : (data) => onCompleted(
                    data,
                    data == null
                        ? null
                        : _parserFn$Mutation$CreateBooking(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationCreateBooking,
          parserFn: _parserFn$Mutation$CreateBooking,
        );

  final OnMutationCompleted$Mutation$CreateBooking? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$CreateBooking
    extends graphql.WatchQueryOptions<Mutation$CreateBooking> {
  WatchOptions$Mutation$CreateBooking({
    String? operationName,
    required Variables$Mutation$CreateBooking variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateBooking? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeMutationCreateBooking,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$CreateBooking,
        );
}

extension ClientExtension$Mutation$CreateBooking on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$CreateBooking>> mutate$CreateBooking(
          Options$Mutation$CreateBooking options) async =>
      await this.mutate(options);

  graphql.ObservableQuery<Mutation$CreateBooking> watchMutation$CreateBooking(
          WatchOptions$Mutation$CreateBooking options) =>
      this.watchMutation(options);
}

class Mutation$CreateBooking$createBooking {
  Mutation$CreateBooking$createBooking({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    this.$__typename = 'Booking',
  });

  factory Mutation$CreateBooking$createBooking.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$roomId = json['roomId'];
    final l$guestName = json['guestName'];
    final l$startDate = json['startDate'];
    final l$endDate = json['endDate'];
    final l$status = json['status'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateBooking$createBooking(
      id: (l$id as String),
      roomId: (l$roomId as String),
      guestName: (l$guestName as String),
      startDate: fromJsonDateTime(l$startDate),
      endDate: fromJsonDateTime(l$endDate),
      status: fromJson$Enum$BookingStatus((l$status as String)),
      createdAt: fromJsonDateTime(l$createdAt),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String roomId;

  final String guestName;

  final DateTime startDate;

  final DateTime endDate;

  final Enum$BookingStatus status;

  final DateTime createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$roomId = roomId;
    _resultData['roomId'] = l$roomId;
    final l$guestName = guestName;
    _resultData['guestName'] = l$guestName;
    final l$startDate = startDate;
    _resultData['startDate'] = toJsonDateTime(l$startDate);
    final l$endDate = endDate;
    _resultData['endDate'] = toJsonDateTime(l$endDate);
    final l$status = status;
    _resultData['status'] = toJson$Enum$BookingStatus(l$status);
    final l$createdAt = createdAt;
    _resultData['createdAt'] = toJsonDateTime(l$createdAt);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$roomId = roomId;
    final l$guestName = guestName;
    final l$startDate = startDate;
    final l$endDate = endDate;
    final l$status = status;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$roomId,
      l$guestName,
      l$startDate,
      l$endDate,
      l$status,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateBooking$createBooking ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$roomId = roomId;
    final lOther$roomId = other.roomId;
    if (l$roomId != lOther$roomId) {
      return false;
    }
    final l$guestName = guestName;
    final lOther$guestName = other.guestName;
    if (l$guestName != lOther$guestName) {
      return false;
    }
    final l$startDate = startDate;
    final lOther$startDate = other.startDate;
    if (l$startDate != lOther$startDate) {
      return false;
    }
    final l$endDate = endDate;
    final lOther$endDate = other.endDate;
    if (l$endDate != lOther$endDate) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateBooking$createBooking
    on Mutation$CreateBooking$createBooking {
  CopyWith$Mutation$CreateBooking$createBooking<
          Mutation$CreateBooking$createBooking>
      get copyWith => CopyWith$Mutation$CreateBooking$createBooking(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$CreateBooking$createBooking<TRes> {
  factory CopyWith$Mutation$CreateBooking$createBooking(
    Mutation$CreateBooking$createBooking instance,
    TRes Function(Mutation$CreateBooking$createBooking) then,
  ) = _CopyWithImpl$Mutation$CreateBooking$createBooking;

  factory CopyWith$Mutation$CreateBooking$createBooking.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateBooking$createBooking;

  TRes call({
    String? id,
    String? roomId,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
    Enum$BookingStatus? status,
    DateTime? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$CreateBooking$createBooking<TRes>
    implements CopyWith$Mutation$CreateBooking$createBooking<TRes> {
  _CopyWithImpl$Mutation$CreateBooking$createBooking(
    this._instance,
    this._then,
  );

  final Mutation$CreateBooking$createBooking _instance;

  final TRes Function(Mutation$CreateBooking$createBooking) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? roomId = _undefined,
    Object? guestName = _undefined,
    Object? startDate = _undefined,
    Object? endDate = _undefined,
    Object? status = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CreateBooking$createBooking(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        roomId: roomId == _undefined || roomId == null
            ? _instance.roomId
            : (roomId as String),
        guestName: guestName == _undefined || guestName == null
            ? _instance.guestName
            : (guestName as String),
        startDate: startDate == _undefined || startDate == null
            ? _instance.startDate
            : (startDate as DateTime),
        endDate: endDate == _undefined || endDate == null
            ? _instance.endDate
            : (endDate as DateTime),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$BookingStatus),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$CreateBooking$createBooking<TRes>
    implements CopyWith$Mutation$CreateBooking$createBooking<TRes> {
  _CopyWithStubImpl$Mutation$CreateBooking$createBooking(this._res);

  TRes _res;

  call({
    String? id,
    String? roomId,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
    Enum$BookingStatus? status,
    DateTime? createdAt,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Mutation$CancelBooking {
  factory Variables$Mutation$CancelBooking({required String bookingId}) =>
      Variables$Mutation$CancelBooking._({
        r'bookingId': bookingId,
      });

  Variables$Mutation$CancelBooking._(this._$data);

  factory Variables$Mutation$CancelBooking.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$bookingId = data['bookingId'];
    result$data['bookingId'] = (l$bookingId as String);
    return Variables$Mutation$CancelBooking._(result$data);
  }

  Map<String, dynamic> _$data;

  String get bookingId => (_$data['bookingId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$bookingId = bookingId;
    result$data['bookingId'] = l$bookingId;
    return result$data;
  }

  CopyWith$Variables$Mutation$CancelBooking<Variables$Mutation$CancelBooking>
      get copyWith => CopyWith$Variables$Mutation$CancelBooking(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CancelBooking ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$bookingId = bookingId;
    final lOther$bookingId = other.bookingId;
    if (l$bookingId != lOther$bookingId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$bookingId = bookingId;
    return Object.hashAll([l$bookingId]);
  }
}

abstract class CopyWith$Variables$Mutation$CancelBooking<TRes> {
  factory CopyWith$Variables$Mutation$CancelBooking(
    Variables$Mutation$CancelBooking instance,
    TRes Function(Variables$Mutation$CancelBooking) then,
  ) = _CopyWithImpl$Variables$Mutation$CancelBooking;

  factory CopyWith$Variables$Mutation$CancelBooking.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CancelBooking;

  TRes call({String? bookingId});
}

class _CopyWithImpl$Variables$Mutation$CancelBooking<TRes>
    implements CopyWith$Variables$Mutation$CancelBooking<TRes> {
  _CopyWithImpl$Variables$Mutation$CancelBooking(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CancelBooking _instance;

  final TRes Function(Variables$Mutation$CancelBooking) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? bookingId = _undefined}) =>
      _then(Variables$Mutation$CancelBooking._({
        ..._instance._$data,
        if (bookingId != _undefined && bookingId != null)
          'bookingId': (bookingId as String),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$CancelBooking<TRes>
    implements CopyWith$Variables$Mutation$CancelBooking<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CancelBooking(this._res);

  TRes _res;

  call({String? bookingId}) => _res;
}

class Mutation$CancelBooking {
  Mutation$CancelBooking({
    required this.cancelBooking,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CancelBooking.fromJson(Map<String, dynamic> json) {
    final l$cancelBooking = json['cancelBooking'];
    final l$$__typename = json['__typename'];
    return Mutation$CancelBooking(
      cancelBooking: Mutation$CancelBooking$cancelBooking.fromJson(
          (l$cancelBooking as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CancelBooking$cancelBooking cancelBooking;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cancelBooking = cancelBooking;
    _resultData['cancelBooking'] = l$cancelBooking.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cancelBooking = cancelBooking;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$cancelBooking,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CancelBooking || runtimeType != other.runtimeType) {
      return false;
    }
    final l$cancelBooking = cancelBooking;
    final lOther$cancelBooking = other.cancelBooking;
    if (l$cancelBooking != lOther$cancelBooking) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CancelBooking on Mutation$CancelBooking {
  CopyWith$Mutation$CancelBooking<Mutation$CancelBooking> get copyWith =>
      CopyWith$Mutation$CancelBooking(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CancelBooking<TRes> {
  factory CopyWith$Mutation$CancelBooking(
    Mutation$CancelBooking instance,
    TRes Function(Mutation$CancelBooking) then,
  ) = _CopyWithImpl$Mutation$CancelBooking;

  factory CopyWith$Mutation$CancelBooking.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CancelBooking;

  TRes call({
    Mutation$CancelBooking$cancelBooking? cancelBooking,
    String? $__typename,
  });
  CopyWith$Mutation$CancelBooking$cancelBooking<TRes> get cancelBooking;
}

class _CopyWithImpl$Mutation$CancelBooking<TRes>
    implements CopyWith$Mutation$CancelBooking<TRes> {
  _CopyWithImpl$Mutation$CancelBooking(
    this._instance,
    this._then,
  );

  final Mutation$CancelBooking _instance;

  final TRes Function(Mutation$CancelBooking) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? cancelBooking = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CancelBooking(
        cancelBooking: cancelBooking == _undefined || cancelBooking == null
            ? _instance.cancelBooking
            : (cancelBooking as Mutation$CancelBooking$cancelBooking),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$CancelBooking$cancelBooking<TRes> get cancelBooking {
    final local$cancelBooking = _instance.cancelBooking;
    return CopyWith$Mutation$CancelBooking$cancelBooking(
        local$cancelBooking, (e) => call(cancelBooking: e));
  }
}

class _CopyWithStubImpl$Mutation$CancelBooking<TRes>
    implements CopyWith$Mutation$CancelBooking<TRes> {
  _CopyWithStubImpl$Mutation$CancelBooking(this._res);

  TRes _res;

  call({
    Mutation$CancelBooking$cancelBooking? cancelBooking,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$CancelBooking$cancelBooking<TRes> get cancelBooking =>
      CopyWith$Mutation$CancelBooking$cancelBooking.stub(_res);
}

const documentNodeMutationCancelBooking = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'CancelBooking'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'bookingId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'cancelBooking'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'bookingId'),
            value: VariableNode(name: NameNode(value: 'bookingId')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'id'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'roomId'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'status'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'canceledAt'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);
Mutation$CancelBooking _parserFn$Mutation$CancelBooking(
        Map<String, dynamic> data) =>
    Mutation$CancelBooking.fromJson(data);
typedef OnMutationCompleted$Mutation$CancelBooking = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$CancelBooking?,
);

class Options$Mutation$CancelBooking
    extends graphql.MutationOptions<Mutation$CancelBooking> {
  Options$Mutation$CancelBooking({
    String? operationName,
    required Variables$Mutation$CancelBooking variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CancelBooking? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$CancelBooking? onCompleted,
    graphql.OnMutationUpdate<Mutation$CancelBooking>? update,
    graphql.OnError? onError,
  })  : onCompletedWithParsed = onCompleted,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          onCompleted: onCompleted == null
              ? null
              : (data) => onCompleted(
                    data,
                    data == null
                        ? null
                        : _parserFn$Mutation$CancelBooking(data),
                  ),
          update: update,
          onError: onError,
          document: documentNodeMutationCancelBooking,
          parserFn: _parserFn$Mutation$CancelBooking,
        );

  final OnMutationCompleted$Mutation$CancelBooking? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed,
      ];
}

class WatchOptions$Mutation$CancelBooking
    extends graphql.WatchQueryOptions<Mutation$CancelBooking> {
  WatchOptions$Mutation$CancelBooking({
    String? operationName,
    required Variables$Mutation$CancelBooking variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CancelBooking? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeMutationCancelBooking,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Mutation$CancelBooking,
        );
}

extension ClientExtension$Mutation$CancelBooking on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$CancelBooking>> mutate$CancelBooking(
          Options$Mutation$CancelBooking options) async =>
      await this.mutate(options);

  graphql.ObservableQuery<Mutation$CancelBooking> watchMutation$CancelBooking(
          WatchOptions$Mutation$CancelBooking options) =>
      this.watchMutation(options);
}

class Mutation$CancelBooking$cancelBooking {
  Mutation$CancelBooking$cancelBooking({
    required this.id,
    required this.roomId,
    required this.status,
    this.canceledAt,
    this.$__typename = 'Booking',
  });

  factory Mutation$CancelBooking$cancelBooking.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$roomId = json['roomId'];
    final l$status = json['status'];
    final l$canceledAt = json['canceledAt'];
    final l$$__typename = json['__typename'];
    return Mutation$CancelBooking$cancelBooking(
      id: (l$id as String),
      roomId: (l$roomId as String),
      status: fromJson$Enum$BookingStatus((l$status as String)),
      canceledAt: l$canceledAt == null ? null : fromJsonDateTime(l$canceledAt),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String roomId;

  final Enum$BookingStatus status;

  final DateTime? canceledAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$roomId = roomId;
    _resultData['roomId'] = l$roomId;
    final l$status = status;
    _resultData['status'] = toJson$Enum$BookingStatus(l$status);
    final l$canceledAt = canceledAt;
    _resultData['canceledAt'] =
        l$canceledAt == null ? null : toJsonDateTime(l$canceledAt);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$roomId = roomId;
    final l$status = status;
    final l$canceledAt = canceledAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$roomId,
      l$status,
      l$canceledAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CancelBooking$cancelBooking ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$roomId = roomId;
    final lOther$roomId = other.roomId;
    if (l$roomId != lOther$roomId) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$canceledAt = canceledAt;
    final lOther$canceledAt = other.canceledAt;
    if (l$canceledAt != lOther$canceledAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CancelBooking$cancelBooking
    on Mutation$CancelBooking$cancelBooking {
  CopyWith$Mutation$CancelBooking$cancelBooking<
          Mutation$CancelBooking$cancelBooking>
      get copyWith => CopyWith$Mutation$CancelBooking$cancelBooking(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$CancelBooking$cancelBooking<TRes> {
  factory CopyWith$Mutation$CancelBooking$cancelBooking(
    Mutation$CancelBooking$cancelBooking instance,
    TRes Function(Mutation$CancelBooking$cancelBooking) then,
  ) = _CopyWithImpl$Mutation$CancelBooking$cancelBooking;

  factory CopyWith$Mutation$CancelBooking$cancelBooking.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CancelBooking$cancelBooking;

  TRes call({
    String? id,
    String? roomId,
    Enum$BookingStatus? status,
    DateTime? canceledAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$CancelBooking$cancelBooking<TRes>
    implements CopyWith$Mutation$CancelBooking$cancelBooking<TRes> {
  _CopyWithImpl$Mutation$CancelBooking$cancelBooking(
    this._instance,
    this._then,
  );

  final Mutation$CancelBooking$cancelBooking _instance;

  final TRes Function(Mutation$CancelBooking$cancelBooking) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? roomId = _undefined,
    Object? status = _undefined,
    Object? canceledAt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$CancelBooking$cancelBooking(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        roomId: roomId == _undefined || roomId == null
            ? _instance.roomId
            : (roomId as String),
        status: status == _undefined || status == null
            ? _instance.status
            : (status as Enum$BookingStatus),
        canceledAt: canceledAt == _undefined
            ? _instance.canceledAt
            : (canceledAt as DateTime?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$CancelBooking$cancelBooking<TRes>
    implements CopyWith$Mutation$CancelBooking$cancelBooking<TRes> {
  _CopyWithStubImpl$Mutation$CancelBooking$cancelBooking(this._res);

  TRes _res;

  call({
    String? id,
    String? roomId,
    Enum$BookingStatus? status,
    DateTime? canceledAt,
    String? $__typename,
  }) =>
      _res;
}
