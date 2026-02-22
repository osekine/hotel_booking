#!/bin/bash
set -euxo pipefail

echo ${PWD}

tool/sync_graphql.sh
dart run build_runner build --delete-conflicting-outputs
dart run tool/gen_barrel.dart

echo ""
echo "✅ GraphQL codegen complete."
echo "Barrel: lib/src/graphql/generated/graphql_api.dart"