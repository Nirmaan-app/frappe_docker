#!/bin/bash
set -e

# Link the image's baked assets into the (volume-mounted) sites dir at startup,
# so the served frontend assets ALWAYS match the deployed image — even across
# redeploys where the named `sites` volume already exists from an older image.
#
# A named volume is only populated from the image the first time it is created;
# without this relink, sites/assets stays frozen at the first-ever deploy and
# users get stale/broken JS/CSS after each release.
ASSETS_PATH="/home/frappe/frappe-bench/sites/assets"
BAKED_PATH="/home/frappe/frappe-bench/assets"

if [ -d "$BAKED_PATH" ]; then
  echo "Linking baked assets into the sites volume..."
  rm -rf "$ASSETS_PATH"
  ln -sfn "$BAKED_PATH" "$ASSETS_PATH"
fi

exec "$@"
