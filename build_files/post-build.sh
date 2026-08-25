#!/usr/bin/env bash
set -euo pipefail

# myrakuOS post-build stage.
# The RakuOS base post-build logic must be kept in sync with upstream.
# This placeholder intentionally fails rather than silently claiming to
# preserve overlay behavior if the upstream script has not been imported.
echo "ERROR: upstream RakuOS base post-build logic must be imported before build" >&2
exit 1
