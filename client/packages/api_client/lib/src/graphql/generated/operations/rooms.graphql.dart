import '../schema.graphql.dart';
import 'dart:async';
import 'package:api_client/src/graphql/client_factory.dart';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Variables$Query$GetRooms {
  factory Variables$Query$GetRooms({required String hotelId}) =>
      Variables$Query$GetRooms._({
        r'hotelId': hotelId,
      });

  Variables$Query$GetRooms._(this._$data);

  factory Variables$Query$GetRooms.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$hotelId = data['hotelId'];
    result$data['hotelId'] = (l$hotelId as String);
    return Variables$Query$GetRooms._(result$data);
  }

  Map<String, dynamic> _$data;

  String get hotelId => (_$data['hotelId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$hotelId = hotelId;
    result$data['hotelId'] = l$hotelId;
    return result$data;
  }

  CopyWith$Variables$Query$GetRooms<Variables$Query$GetRooms> get copyWith =>
      CopyWith$Variables$Query$GetRooms(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetRooms ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hotelId = hotelId;
    final lOther$hotelId = other.hotelId;
    if (l$hotelId != lOther$hotelId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$hotelId = hotelId;
    return Object.hashAll([l$hotelId]);
  }
}

abstract class CopyWith$Variables$Query$GetRooms<TRes> {
  factory CopyWith$Variables$Query$GetRooms(
    Variables$Query$GetRooms instance,
    TRes Function(Variables$Query$GetRooms) then,
  ) = _CopyWithImpl$Variables$Query$GetRooms;

  factory CopyWith$Variables$Query$GetRooms.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetRooms;

  TRes call({String? hotelId});
}

class _CopyWithImpl$Variables$Query$GetRooms<TRes>
    implements CopyWith$Variables$Query$GetRooms<TRes> {
  _CopyWithImpl$Variables$Query$GetRooms(
    this._instance,
    this._then,
  );

  final Variables$Query$GetRooms _instance;

  final TRes Function(Variables$Query$GetRooms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? hotelId = _undefined}) =>
      _then(Variables$Query$GetRooms._({
        ..._instance._$data,
        if (hotelId != _undefined && hotelId != null)
          'hotelId': (hotelId as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetRooms<TRes>
    implements CopyWith$Variables$Query$GetRooms<TRes> {
  _CopyWithStubImpl$Variables$Query$GetRooms(this._res);

  TRes _res;

  call({String? hotelId}) => _res;
}

class Query$GetRooms {
  Query$GetRooms({
    required this.rooms,
    this.$__typename = 'Query',
  });

  factory Query$GetRooms.fromJson(Map<String, dynamic> json) {
    final l$rooms = json['rooms'];
    final l$$__typename = json['__typename'];
    return Query$GetRooms(
      rooms: (l$rooms as List<dynamic>)
          .map(
              (e) => Query$GetRooms$rooms.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$GetRooms$rooms> rooms;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$rooms = rooms;
    _resultData['rooms'] = l$rooms.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$rooms = rooms;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$rooms.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetRooms || runtimeType != other.runtimeType) {
      return false;
    }
    final l$rooms = rooms;
    final lOther$rooms = other.rooms;
    if (l$rooms.length != lOther$rooms.length) {
      return false;
    }
    for (int i = 0; i < l$rooms.length; i++) {
      final l$rooms$entry = l$rooms[i];
      final lOther$rooms$entry = lOther$rooms[i];
      if (l$rooms$entry != lOther$rooms$entry) {
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

extension UtilityExtension$Query$GetRooms on Query$GetRooms {
  CopyWith$Query$GetRooms<Query$GetRooms> get copyWith =>
      CopyWith$Query$GetRooms(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetRooms<TRes> {
  factory CopyWith$Query$GetRooms(
    Query$GetRooms instance,
    TRes Function(Query$GetRooms) then,
  ) = _CopyWithImpl$Query$GetRooms;

  factory CopyWith$Query$GetRooms.stub(TRes res) =
      _CopyWithStubImpl$Query$GetRooms;

  TRes call({
    List<Query$GetRooms$rooms>? rooms,
    String? $__typename,
  });
  TRes rooms(
      Iterable<Query$GetRooms$rooms> Function(
              Iterable<CopyWith$Query$GetRooms$rooms<Query$GetRooms$rooms>>)
          _fn);
}

class _CopyWithImpl$Query$GetRooms<TRes>
    implements CopyWith$Query$GetRooms<TRes> {
  _CopyWithImpl$Query$GetRooms(
    this._instance,
    this._then,
  );

  final Query$GetRooms _instance;

  final TRes Function(Query$GetRooms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? rooms = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetRooms(
        rooms: rooms == _undefined || rooms == null
            ? _instance.rooms
            : (rooms as List<Query$GetRooms$rooms>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes rooms(
          Iterable<Query$GetRooms$rooms> Function(
                  Iterable<CopyWith$Query$GetRooms$rooms<Query$GetRooms$rooms>>)
              _fn) =>
      call(
          rooms: _fn(_instance.rooms.map((e) => CopyWith$Query$GetRooms$rooms(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$GetRooms<TRes>
    implements CopyWith$Query$GetRooms<TRes> {
  _CopyWithStubImpl$Query$GetRooms(this._res);

  TRes _res;

  call({
    List<Query$GetRooms$rooms>? rooms,
    String? $__typename,
  }) =>
      _res;

  rooms(_fn) => _res;
}

const documentNodeQueryGetRooms = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetRooms'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'hotelId')),
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
        name: NameNode(value: 'rooms'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'hotelId'),
            value: VariableNode(name: NameNode(value: 'hotelId')),
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
            name: NameNode(value: 'hotelId'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'number'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'title'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'capacity'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'priceEur'),
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
Query$GetRooms _parserFn$Query$GetRooms(Map<String, dynamic> data) =>
    Query$GetRooms.fromJson(data);
typedef OnQueryComplete$Query$GetRooms = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetRooms?,
);

class Options$Query$GetRooms extends graphql.QueryOptions<Query$GetRooms> {
  Options$Query$GetRooms({
    String? operationName,
    required Variables$Query$GetRooms variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetRooms? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetRooms? onComplete,
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
                    data == null ? null : _parserFn$Query$GetRooms(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetRooms,
          parserFn: _parserFn$Query$GetRooms,
        );

  final OnQueryComplete$Query$GetRooms? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetRooms
    extends graphql.WatchQueryOptions<Query$GetRooms> {
  WatchOptions$Query$GetRooms({
    String? operationName,
    required Variables$Query$GetRooms variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetRooms? typedOptimisticResult,
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
          document: documentNodeQueryGetRooms,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetRooms,
        );
}

class FetchMoreOptions$Query$GetRooms extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetRooms({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetRooms variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetRooms,
        );
}

extension ClientExtension$Query$GetRooms on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetRooms>> query$GetRooms(
          Options$Query$GetRooms options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query$GetRooms> watchQuery$GetRooms(
          WatchOptions$Query$GetRooms options) =>
      this.watchQuery(options);

  void writeQuery$GetRooms({
    required Query$GetRooms data,
    required Variables$Query$GetRooms variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryGetRooms),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$GetRooms? readQuery$GetRooms({
    required Variables$Query$GetRooms variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryGetRooms),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetRooms.fromJson(result);
  }
}

class Query$GetRooms$rooms {
  Query$GetRooms$rooms({
    required this.id,
    required this.hotelId,
    required this.number,
    this.title,
    required this.capacity,
    required this.priceEur,
    required this.createdAt,
    this.$__typename = 'Room',
  });

  factory Query$GetRooms$rooms.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$hotelId = json['hotelId'];
    final l$number = json['number'];
    final l$title = json['title'];
    final l$capacity = json['capacity'];
    final l$priceEur = json['priceEur'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Query$GetRooms$rooms(
      id: (l$id as String),
      hotelId: (l$hotelId as String),
      number: (l$number as String),
      title: (l$title as String?),
      capacity: (l$capacity as int),
      priceEur: (l$priceEur as int),
      createdAt: fromJsonDateTime(l$createdAt),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String hotelId;

  final String number;

  final String? title;

  final int capacity;

  final int priceEur;

  final DateTime createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$hotelId = hotelId;
    _resultData['hotelId'] = l$hotelId;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$capacity = capacity;
    _resultData['capacity'] = l$capacity;
    final l$priceEur = priceEur;
    _resultData['priceEur'] = l$priceEur;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = toJsonDateTime(l$createdAt);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$hotelId = hotelId;
    final l$number = number;
    final l$title = title;
    final l$capacity = capacity;
    final l$priceEur = priceEur;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$hotelId,
      l$number,
      l$title,
      l$capacity,
      l$priceEur,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetRooms$rooms || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$hotelId = hotelId;
    final lOther$hotelId = other.hotelId;
    if (l$hotelId != lOther$hotelId) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$capacity = capacity;
    final lOther$capacity = other.capacity;
    if (l$capacity != lOther$capacity) {
      return false;
    }
    final l$priceEur = priceEur;
    final lOther$priceEur = other.priceEur;
    if (l$priceEur != lOther$priceEur) {
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

extension UtilityExtension$Query$GetRooms$rooms on Query$GetRooms$rooms {
  CopyWith$Query$GetRooms$rooms<Query$GetRooms$rooms> get copyWith =>
      CopyWith$Query$GetRooms$rooms(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetRooms$rooms<TRes> {
  factory CopyWith$Query$GetRooms$rooms(
    Query$GetRooms$rooms instance,
    TRes Function(Query$GetRooms$rooms) then,
  ) = _CopyWithImpl$Query$GetRooms$rooms;

  factory CopyWith$Query$GetRooms$rooms.stub(TRes res) =
      _CopyWithStubImpl$Query$GetRooms$rooms;

  TRes call({
    String? id,
    String? hotelId,
    String? number,
    String? title,
    int? capacity,
    int? priceEur,
    DateTime? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetRooms$rooms<TRes>
    implements CopyWith$Query$GetRooms$rooms<TRes> {
  _CopyWithImpl$Query$GetRooms$rooms(
    this._instance,
    this._then,
  );

  final Query$GetRooms$rooms _instance;

  final TRes Function(Query$GetRooms$rooms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? hotelId = _undefined,
    Object? number = _undefined,
    Object? title = _undefined,
    Object? capacity = _undefined,
    Object? priceEur = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetRooms$rooms(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        hotelId: hotelId == _undefined || hotelId == null
            ? _instance.hotelId
            : (hotelId as String),
        number: number == _undefined || number == null
            ? _instance.number
            : (number as String),
        title: title == _undefined ? _instance.title : (title as String?),
        capacity: capacity == _undefined || capacity == null
            ? _instance.capacity
            : (capacity as int),
        priceEur: priceEur == _undefined || priceEur == null
            ? _instance.priceEur
            : (priceEur as int),
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetRooms$rooms<TRes>
    implements CopyWith$Query$GetRooms$rooms<TRes> {
  _CopyWithStubImpl$Query$GetRooms$rooms(this._res);

  TRes _res;

  call({
    String? id,
    String? hotelId,
    String? number,
    String? title,
    int? capacity,
    int? priceEur,
    DateTime? createdAt,
    String? $__typename,
  }) =>
      _res;
}

class Variables$Query$GetRoom {
  factory Variables$Query$GetRoom({
    required String id,
    Enum$BookingStatus? bookingStatus,
  }) =>
      Variables$Query$GetRoom._({
        r'id': id,
        if (bookingStatus != null) r'bookingStatus': bookingStatus,
      });

  Variables$Query$GetRoom._(this._$data);

  factory Variables$Query$GetRoom.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('bookingStatus')) {
      final l$bookingStatus = data['bookingStatus'];
      result$data['bookingStatus'] = l$bookingStatus == null
          ? null
          : fromJson$Enum$BookingStatus((l$bookingStatus as String));
    }
    return Variables$Query$GetRoom._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Enum$BookingStatus? get bookingStatus =>
      (_$data['bookingStatus'] as Enum$BookingStatus?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('bookingStatus')) {
      final l$bookingStatus = bookingStatus;
      result$data['bookingStatus'] = l$bookingStatus == null
          ? null
          : toJson$Enum$BookingStatus(l$bookingStatus);
    }
    return result$data;
  }

  CopyWith$Variables$Query$GetRoom<Variables$Query$GetRoom> get copyWith =>
      CopyWith$Variables$Query$GetRoom(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetRoom || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$bookingStatus = bookingStatus;
    final lOther$bookingStatus = other.bookingStatus;
    if (_$data.containsKey('bookingStatus') !=
        other._$data.containsKey('bookingStatus')) {
      return false;
    }
    if (l$bookingStatus != lOther$bookingStatus) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$bookingStatus = bookingStatus;
    return Object.hashAll([
      l$id,
      _$data.containsKey('bookingStatus') ? l$bookingStatus : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$GetRoom<TRes> {
  factory CopyWith$Variables$Query$GetRoom(
    Variables$Query$GetRoom instance,
    TRes Function(Variables$Query$GetRoom) then,
  ) = _CopyWithImpl$Variables$Query$GetRoom;

  factory CopyWith$Variables$Query$GetRoom.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetRoom;

  TRes call({
    String? id,
    Enum$BookingStatus? bookingStatus,
  });
}

class _CopyWithImpl$Variables$Query$GetRoom<TRes>
    implements CopyWith$Variables$Query$GetRoom<TRes> {
  _CopyWithImpl$Variables$Query$GetRoom(
    this._instance,
    this._then,
  );

  final Variables$Query$GetRoom _instance;

  final TRes Function(Variables$Query$GetRoom) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? bookingStatus = _undefined,
  }) =>
      _then(Variables$Query$GetRoom._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (bookingStatus != _undefined)
          'bookingStatus': (bookingStatus as Enum$BookingStatus?),
      }));
}

class _CopyWithStubImpl$Variables$Query$GetRoom<TRes>
    implements CopyWith$Variables$Query$GetRoom<TRes> {
  _CopyWithStubImpl$Variables$Query$GetRoom(this._res);

  TRes _res;

  call({
    String? id,
    Enum$BookingStatus? bookingStatus,
  }) =>
      _res;
}

class Query$GetRoom {
  Query$GetRoom({
    required this.room,
    this.$__typename = 'Query',
  });

  factory Query$GetRoom.fromJson(Map<String, dynamic> json) {
    final l$room = json['room'];
    final l$$__typename = json['__typename'];
    return Query$GetRoom(
      room: Query$GetRoom$room.fromJson((l$room as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetRoom$room room;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$room = room;
    _resultData['room'] = l$room.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$room = room;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$room,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetRoom || runtimeType != other.runtimeType) {
      return false;
    }
    final l$room = room;
    final lOther$room = other.room;
    if (l$room != lOther$room) {
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

extension UtilityExtension$Query$GetRoom on Query$GetRoom {
  CopyWith$Query$GetRoom<Query$GetRoom> get copyWith => CopyWith$Query$GetRoom(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetRoom<TRes> {
  factory CopyWith$Query$GetRoom(
    Query$GetRoom instance,
    TRes Function(Query$GetRoom) then,
  ) = _CopyWithImpl$Query$GetRoom;

  factory CopyWith$Query$GetRoom.stub(TRes res) =
      _CopyWithStubImpl$Query$GetRoom;

  TRes call({
    Query$GetRoom$room? room,
    String? $__typename,
  });
  CopyWith$Query$GetRoom$room<TRes> get room;
}

class _CopyWithImpl$Query$GetRoom<TRes>
    implements CopyWith$Query$GetRoom<TRes> {
  _CopyWithImpl$Query$GetRoom(
    this._instance,
    this._then,
  );

  final Query$GetRoom _instance;

  final TRes Function(Query$GetRoom) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? room = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetRoom(
        room: room == _undefined || room == null
            ? _instance.room
            : (room as Query$GetRoom$room),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$GetRoom$room<TRes> get room {
    final local$room = _instance.room;
    return CopyWith$Query$GetRoom$room(local$room, (e) => call(room: e));
  }
}

class _CopyWithStubImpl$Query$GetRoom<TRes>
    implements CopyWith$Query$GetRoom<TRes> {
  _CopyWithStubImpl$Query$GetRoom(this._res);

  TRes _res;

  call({
    Query$GetRoom$room? room,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$GetRoom$room<TRes> get room =>
      CopyWith$Query$GetRoom$room.stub(_res);
}

const documentNodeQueryGetRoom = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'GetRoom'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'bookingStatus')),
        type: NamedTypeNode(
          name: NameNode(value: 'BookingStatus'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'room'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'id')),
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
            name: NameNode(value: 'hotelId'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'number'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'title'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'capacity'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'priceEur'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'bookings'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'status'),
                value: VariableNode(name: NameNode(value: 'bookingStatus')),
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
Query$GetRoom _parserFn$Query$GetRoom(Map<String, dynamic> data) =>
    Query$GetRoom.fromJson(data);
typedef OnQueryComplete$Query$GetRoom = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GetRoom?,
);

class Options$Query$GetRoom extends graphql.QueryOptions<Query$GetRoom> {
  Options$Query$GetRoom({
    String? operationName,
    required Variables$Query$GetRoom variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetRoom? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetRoom? onComplete,
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
                    data == null ? null : _parserFn$Query$GetRoom(data),
                  ),
          onError: onError,
          document: documentNodeQueryGetRoom,
          parserFn: _parserFn$Query$GetRoom,
        );

  final OnQueryComplete$Query$GetRoom? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$GetRoom
    extends graphql.WatchQueryOptions<Query$GetRoom> {
  WatchOptions$Query$GetRoom({
    String? operationName,
    required Variables$Query$GetRoom variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetRoom? typedOptimisticResult,
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
          document: documentNodeQueryGetRoom,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$GetRoom,
        );
}

class FetchMoreOptions$Query$GetRoom extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetRoom({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetRoom variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryGetRoom,
        );
}

extension ClientExtension$Query$GetRoom on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetRoom>> query$GetRoom(
          Options$Query$GetRoom options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query$GetRoom> watchQuery$GetRoom(
          WatchOptions$Query$GetRoom options) =>
      this.watchQuery(options);

  void writeQuery$GetRoom({
    required Query$GetRoom data,
    required Variables$Query$GetRoom variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryGetRoom),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$GetRoom? readQuery$GetRoom({
    required Variables$Query$GetRoom variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryGetRoom),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GetRoom.fromJson(result);
  }
}

class Query$GetRoom$room {
  Query$GetRoom$room({
    required this.id,
    required this.hotelId,
    required this.number,
    this.title,
    required this.capacity,
    required this.priceEur,
    required this.bookings,
    this.$__typename = 'Room',
  });

  factory Query$GetRoom$room.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$hotelId = json['hotelId'];
    final l$number = json['number'];
    final l$title = json['title'];
    final l$capacity = json['capacity'];
    final l$priceEur = json['priceEur'];
    final l$bookings = json['bookings'];
    final l$$__typename = json['__typename'];
    return Query$GetRoom$room(
      id: (l$id as String),
      hotelId: (l$hotelId as String),
      number: (l$number as String),
      title: (l$title as String?),
      capacity: (l$capacity as int),
      priceEur: (l$priceEur as int),
      bookings: (l$bookings as List<dynamic>)
          .map((e) =>
              Query$GetRoom$room$bookings.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String hotelId;

  final String number;

  final String? title;

  final int capacity;

  final int priceEur;

  final List<Query$GetRoom$room$bookings> bookings;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$hotelId = hotelId;
    _resultData['hotelId'] = l$hotelId;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$capacity = capacity;
    _resultData['capacity'] = l$capacity;
    final l$priceEur = priceEur;
    _resultData['priceEur'] = l$priceEur;
    final l$bookings = bookings;
    _resultData['bookings'] = l$bookings.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$hotelId = hotelId;
    final l$number = number;
    final l$title = title;
    final l$capacity = capacity;
    final l$priceEur = priceEur;
    final l$bookings = bookings;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$hotelId,
      l$number,
      l$title,
      l$capacity,
      l$priceEur,
      Object.hashAll(l$bookings.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetRoom$room || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$hotelId = hotelId;
    final lOther$hotelId = other.hotelId;
    if (l$hotelId != lOther$hotelId) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$capacity = capacity;
    final lOther$capacity = other.capacity;
    if (l$capacity != lOther$capacity) {
      return false;
    }
    final l$priceEur = priceEur;
    final lOther$priceEur = other.priceEur;
    if (l$priceEur != lOther$priceEur) {
      return false;
    }
    final l$bookings = bookings;
    final lOther$bookings = other.bookings;
    if (l$bookings.length != lOther$bookings.length) {
      return false;
    }
    for (int i = 0; i < l$bookings.length; i++) {
      final l$bookings$entry = l$bookings[i];
      final lOther$bookings$entry = lOther$bookings[i];
      if (l$bookings$entry != lOther$bookings$entry) {
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

extension UtilityExtension$Query$GetRoom$room on Query$GetRoom$room {
  CopyWith$Query$GetRoom$room<Query$GetRoom$room> get copyWith =>
      CopyWith$Query$GetRoom$room(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetRoom$room<TRes> {
  factory CopyWith$Query$GetRoom$room(
    Query$GetRoom$room instance,
    TRes Function(Query$GetRoom$room) then,
  ) = _CopyWithImpl$Query$GetRoom$room;

  factory CopyWith$Query$GetRoom$room.stub(TRes res) =
      _CopyWithStubImpl$Query$GetRoom$room;

  TRes call({
    String? id,
    String? hotelId,
    String? number,
    String? title,
    int? capacity,
    int? priceEur,
    List<Query$GetRoom$room$bookings>? bookings,
    String? $__typename,
  });
  TRes bookings(
      Iterable<Query$GetRoom$room$bookings> Function(
              Iterable<
                  CopyWith$Query$GetRoom$room$bookings<
                      Query$GetRoom$room$bookings>>)
          _fn);
}

class _CopyWithImpl$Query$GetRoom$room<TRes>
    implements CopyWith$Query$GetRoom$room<TRes> {
  _CopyWithImpl$Query$GetRoom$room(
    this._instance,
    this._then,
  );

  final Query$GetRoom$room _instance;

  final TRes Function(Query$GetRoom$room) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? hotelId = _undefined,
    Object? number = _undefined,
    Object? title = _undefined,
    Object? capacity = _undefined,
    Object? priceEur = _undefined,
    Object? bookings = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetRoom$room(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        hotelId: hotelId == _undefined || hotelId == null
            ? _instance.hotelId
            : (hotelId as String),
        number: number == _undefined || number == null
            ? _instance.number
            : (number as String),
        title: title == _undefined ? _instance.title : (title as String?),
        capacity: capacity == _undefined || capacity == null
            ? _instance.capacity
            : (capacity as int),
        priceEur: priceEur == _undefined || priceEur == null
            ? _instance.priceEur
            : (priceEur as int),
        bookings: bookings == _undefined || bookings == null
            ? _instance.bookings
            : (bookings as List<Query$GetRoom$room$bookings>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes bookings(
          Iterable<Query$GetRoom$room$bookings> Function(
                  Iterable<
                      CopyWith$Query$GetRoom$room$bookings<
                          Query$GetRoom$room$bookings>>)
              _fn) =>
      call(
          bookings: _fn(_instance.bookings
              .map((e) => CopyWith$Query$GetRoom$room$bookings(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Query$GetRoom$room<TRes>
    implements CopyWith$Query$GetRoom$room<TRes> {
  _CopyWithStubImpl$Query$GetRoom$room(this._res);

  TRes _res;

  call({
    String? id,
    String? hotelId,
    String? number,
    String? title,
    int? capacity,
    int? priceEur,
    List<Query$GetRoom$room$bookings>? bookings,
    String? $__typename,
  }) =>
      _res;

  bookings(_fn) => _res;
}

class Query$GetRoom$room$bookings {
  Query$GetRoom$room$bookings({
    required this.id,
    required this.guestName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    this.canceledAt,
    this.$__typename = 'Booking',
  });

  factory Query$GetRoom$room$bookings.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$guestName = json['guestName'];
    final l$startDate = json['startDate'];
    final l$endDate = json['endDate'];
    final l$status = json['status'];
    final l$createdAt = json['createdAt'];
    final l$canceledAt = json['canceledAt'];
    final l$$__typename = json['__typename'];
    return Query$GetRoom$room$bookings(
      id: (l$id as String),
      guestName: (l$guestName as String),
      startDate: fromJsonDateTime(l$startDate),
      endDate: fromJsonDateTime(l$endDate),
      status: fromJson$Enum$BookingStatus((l$status as String)),
      createdAt: fromJsonDateTime(l$createdAt),
      canceledAt: l$canceledAt == null ? null : fromJsonDateTime(l$canceledAt),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String guestName;

  final DateTime startDate;

  final DateTime endDate;

  final Enum$BookingStatus status;

  final DateTime createdAt;

  final DateTime? canceledAt;

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
    final l$createdAt = createdAt;
    _resultData['createdAt'] = toJsonDateTime(l$createdAt);
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
    final l$guestName = guestName;
    final l$startDate = startDate;
    final l$endDate = endDate;
    final l$status = status;
    final l$createdAt = createdAt;
    final l$canceledAt = canceledAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$guestName,
      l$startDate,
      l$endDate,
      l$status,
      l$createdAt,
      l$canceledAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetRoom$room$bookings ||
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
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension$Query$GetRoom$room$bookings
    on Query$GetRoom$room$bookings {
  CopyWith$Query$GetRoom$room$bookings<Query$GetRoom$room$bookings>
      get copyWith => CopyWith$Query$GetRoom$room$bookings(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$GetRoom$room$bookings<TRes> {
  factory CopyWith$Query$GetRoom$room$bookings(
    Query$GetRoom$room$bookings instance,
    TRes Function(Query$GetRoom$room$bookings) then,
  ) = _CopyWithImpl$Query$GetRoom$room$bookings;

  factory CopyWith$Query$GetRoom$room$bookings.stub(TRes res) =
      _CopyWithStubImpl$Query$GetRoom$room$bookings;

  TRes call({
    String? id,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
    Enum$BookingStatus? status,
    DateTime? createdAt,
    DateTime? canceledAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetRoom$room$bookings<TRes>
    implements CopyWith$Query$GetRoom$room$bookings<TRes> {
  _CopyWithImpl$Query$GetRoom$room$bookings(
    this._instance,
    this._then,
  );

  final Query$GetRoom$room$bookings _instance;

  final TRes Function(Query$GetRoom$room$bookings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? guestName = _undefined,
    Object? startDate = _undefined,
    Object? endDate = _undefined,
    Object? status = _undefined,
    Object? createdAt = _undefined,
    Object? canceledAt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$GetRoom$room$bookings(
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
        createdAt: createdAt == _undefined || createdAt == null
            ? _instance.createdAt
            : (createdAt as DateTime),
        canceledAt: canceledAt == _undefined
            ? _instance.canceledAt
            : (canceledAt as DateTime?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$GetRoom$room$bookings<TRes>
    implements CopyWith$Query$GetRoom$room$bookings<TRes> {
  _CopyWithStubImpl$Query$GetRoom$room$bookings(this._res);

  TRes _res;

  call({
    String? id,
    String? guestName,
    DateTime? startDate,
    DateTime? endDate,
    Enum$BookingStatus? status,
    DateTime? createdAt,
    DateTime? canceledAt,
    String? $__typename,
  }) =>
      _res;
}
