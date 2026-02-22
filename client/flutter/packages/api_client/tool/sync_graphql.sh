#!/bin/bash
set -euxo pipefail

PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$PKG_DIR/../../../.." && pwd)"

SRC="$REPO_ROOT/graphql"
DST="$PKG_DIR/graphql"

rm -rf "$DST"
mkdir -p "$DST/operations"

cp "$SRC/schema.graphql" "$DST/schema.graphql"
cp "$SRC/operations/"*.graphql "$DST/operations/"

echo "✅ Synced GraphQL to $DST"