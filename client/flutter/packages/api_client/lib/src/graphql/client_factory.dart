import 'package:graphql_flutter/graphql_flutter.dart';

DateTime fromJsonDateTime(Object? json) => DateTime.parse(json! as String);
Object toJsonDateTime(DateTime value) => value.toUtc().toIso8601String();

class GraphQLClientFactory {
  final String graphqlUrl;
  GraphQLClientFactory({required this.graphqlUrl});

  GraphQLClient create() {
    final link = HttpLink(graphqlUrl);
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
