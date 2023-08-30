#!/usr/bin/env bash
#
# Generate WooCommerce stubs from the source directory.
#
set -e

# Get version from cli argument.
VERSION=$1
NEW=true
if [ -z "$VERSION" ]; then
    echo "Version argument missing. Regenerate current."
    NEW=false
else
    echo "Update to $VERSION. commit and push changes."
fi

git checkout master
git pull

# Update WooCommerce via Composer.
if [ "$NEW" = true ]; then
    rm -rf ./woocommerce
    composer require om4/woocommerce-dist:"$VERSION" --dev
fi
composer update

# Collect sttubs.
HEADER=$'/**\n * Generated stub declarations for WooCommerce.\n * @see https://woocommerce.com\n * @see https://github.com/om4/woocommerce-stubs\n */'

FILE="woocommerce-stubs.php"
FILE_PKGS="woocommerce-packages-stubs.php"

test -f "$FILE"
test -f "$FILE_PKGS"
test -d "woocommerce"

# Exclude globals.
"$(dirname "$0")/vendor/bin/generate-stubs" \
    --force \
    --finder=finder.php \
    --header="$HEADER" \
    --functions \
    --classes \
    --interfaces \
    --traits \
    --constants \
    --include-inaccessible-class-nodes \
    --out="$FILE"

# There are no WC functions to read these constants.
# See define_constants() in includes/class-woocommerce.php
#printf '\n%s\n' "define('WC_VERSION', '0.0.0');" >>"$FILE"
printf '\nnamespace {\n%s\n}\n' "define('WC_VERSION', '0.0.0');" >>"$FILE"

# Packages.
"$(dirname "$0")/vendor/bin/generate-stubs" \
    --force \
    --finder=finder-packages.php \
    --header="$HEADER" \
    --functions \
    --classes \
    --interfaces \
    --traits \
    --include-inaccessible-class-nodes \
    --out="$FILE_PKGS"
# FIXME Add modern core arguments.
##sed -e 's#^\s*public function feedback(\$string#&, ...$args#' -i "$FILE_PKGS"

# commit and push changes.
if [ "$NEW" = true ]; then
    git add --all
    git commit -m "Generate stubs for WooCommerce $VERSION"
    git tag "$VERSION"

    git push --tags
    git push

    echo "Version $VERSION imported"
fi
