import 'dart:async';
import 'package:api_client/src/graphql/client_factory.dart';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Query$GetHotels {
  Query$GetHotels({
    required this.hotels,
    this.$__typename = 'Query',
  });

  factory Query$GetHotels.fromJson(Map<String, dynamic> json) {
    final l$hotels = json['hotels'];
    final l$$__typename = json['__typename'];
    return Query$GetHotels(
      hotels: (l$hotels as List<dynamic>)
          .map((e) =>
              Query$GetHotels$hotels.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetHotels$hotels> hotels;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hotels = hotels;
    _resultData['hotels'] = l$hotels.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hotels = hotels;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$hotels.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetHotels || runtimeType != other.runtimeType) {
      return false;
    }
    final l$hotels = hotels;
    final lOther$hotels = other.hotels;
    if (l$hotels.length != lOther$hotels.length) {
      return false;
    }
    for (int i = 0; i < l$hotels.length; i++) {
      final l$hotels$entry = l$hotels[i];
      final lOther$hotels$entry = lOther$hotels[i];
      if (l$hotels$entry != lOther$hotels$entry) {
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

extension UtilityExtension$Query$GetHotels on Query$GetHotels {
  CopyWith$Query$GetHotels<Query$GetHotels> get copyWith =>
      CopyWith$Query$GetHotels(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetHotels<TRes> {
  factory CopyWith$Query$GetHotels(
    Query$GetHotels instance,
    TRes Function(Query$GetHotels) then,
  ) = _CopyWithImpl$Query$GetHotels;

  factory CopyWith$Query$GetHotels.stub(TRes res) =
      _CopyWithStubImpl$Query$GetHotels;

  TRes call({
    List<Query$GetHotels$hotels>? hotels,
    String? $__typename,
  });
  TRes hotels(
      Iterable<Query$GetHotels$hotels> Function(
              Iterable<CopyWith$Query$GetHotels$hotels<Query$GetHotels$hotels>>)
          _fn);
}

class _CopyWithImpl$Query$GetHotels<TRes>
    implements CopyWith$Query$GetHotels<TRes> {
  _CopyWithImpl$Query$GetHotels(
    this._instance,
    this._then,
  );

  final Query$GetHotels _instance;

  final TRes Function(Query$GetHotels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hotels = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetHotels(
        hotels: hotels == _undefined || hotels == null
            ? _instance.hotels
            : (hotels as List<Query$GetHotels$hotels>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes hotels(
          Iterable<Query$GetHotels$hotels> Function(
                  Iterable<
                      CopyWith$Query$GetHotels$hotels<Query$GetHotels$hotels>>)
              _fn) =>
      call(
          hotels:
              _fn(_instance.hotels.map((e) => CopyWith$Query$GetHotels$hotels(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetHotels<TRes>
    implements CopyWith$Query$GetHotels<TRes> {
  _CopyWithStubImpl$Query$GetHotels(this._res);

  TRes _res;

  call({
    List<Query$GetHotels$hotels>? hotels,
    String? $__typename,
  }) =>
      _res;

  hotels(_fn) => _res;
}

const documentNodeQueryGetHotels = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetHotels'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'hotels'),
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
            name: NameNode(value: 'name'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'city'),
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
Query$GetHotels _parserFn$Query$GetHotels(Map<String, dynamic> data) =>
    Query$GetHotels.fromJson(data);
typedef OnQueryComplete$Query$GetHotels = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetHotels?,
);

class Options$Query$GetHotels extends graphql.QueryOptions<Query$GetHotels> {
  Options$Query$GetHotels({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetHotels? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetHotels? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
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
                    data == null ? null : _parserFn$Query$GetHotels(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetHotels,
          parserFn: _parserFn$Query$GetHotels,
        );

  final OnQueryComplete$Query$GetHotels? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetHotels
    extends graphql.WatchQueryOptions<Query$GetHotels> {
  WatchOptions$Query$GetHotels({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetHotels? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeQueryGetHotels,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetHotels,
        );
}

class FetchMoreOptions$Query$GetHotels extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetHotels({required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryGetHotels,
        );
}

extension ClientExtension$Query$GetHotels on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetHotels>> query$GetHotels(
          [Options$Query$GetHotels? options]) async =>
      await this.query(options ?? Options$Query$GetHotels());

  graphql.ObservableQuery<Query$GetHotels> watchQuery$GetHotels(
          [WatchOptions$Query$GetHotels? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$GetHotels());

  void writeQuery$GetHotels({
    required Query$GetHotels data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation: graphql.Operation(document: documentNodeQueryGetHotels)),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$GetHotels? readQuery$GetHotels({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryGetHotels)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetHotels.fromJson(result);
  }
}

class Query$GetHotels$hotels {
  Query$GetHotels$hotels({
    required this.id,
    required this.name,
    required this.city,
    required this.createdAt,
    this.$__typename = 'Hotel',
  });

  factory Query$GetHotels$hotels.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$city = json['city'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Query$GetHotels$hotels(
      id: (l$id as String),
      name: (l$name as String),
      city: (l$city as String),
      createdAt: fromJsonDateTime(l$createdAt),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String city;

  final DateTime createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = toJsonDateTime(l$createdAt);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$city = city;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$city,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetHotels$hotels || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
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

extension UtilityExtension$Query$GetHotels$hotels on Query$GetHotels$hotels {
  CopyWith$Query$GetHotels$hotels<Query$GetHotels$hotels> get copyWith =>
      CopyWith$Query$GetHotels$hotels(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetHotels$hotels<TRes> {
  factory CopyWith$Query$GetHotels$hotels(
    Query$GetHotels$hotels instance,
    TRes Function(Query$GetHotels$hotels) then,
  ) = _CopyWithImpl$Query$GetHotels$hotels;

  factory CopyWith$Query$GetHotels$hotels.stub(TRes res) =
      _CopyWithStubImpl$Query$GetHotels$hotels;

  TRes call({
    String? id,
    String? name,
    String? city,
    DateTime? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetHotels$hotels<TRes>
    implements CopyWith$Query$GetHotels$hotels<TRes> {
  _CopyWithImpl$Query$GetHotels$hotels(
    this._instance,
    this._then,
  );

  final Query$GetHotels$hotels _instance;

  final TRes Function(Query$GetHotels$hotels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? city = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetHotels$hotels(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        name: name == _undefined || name == null
            ? _instance.name
            : (name as String),
        city: city == _undefined || city == null
            ? _instance.city
            : (city as String),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetHotels$hotels<TRes>
    implements CopyWith$Query$GetHotels$hotels<TRes> {
  _CopyWithStubImpl$Query$GetHotels$hotels(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? city,
    DateTime? createdAt,
    String? $__typename,
  }) =>
      _res;
}
