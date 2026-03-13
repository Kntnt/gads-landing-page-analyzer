#!/usr/bin/env bash
# fetch-markdown.sh – Try to fetch a Markdown version of a URL.
#
# Usage: fetch-markdown.sh <url>
#
# Tries five strategies in order:
#   1. HTTP Link header with rel="alternate"; type="text/markdown"
#   2. Append ?format=md (or &format=md) query parameter
#   3. Strip trailing slash and append .md (only if URL has a path beyond /)
#   4. If URL path ends with /, append index-commonmark.md
#   5. Parse HTML for <link rel="alternate" type="text/markdown" href="…" />
#
# On success: prints the Markdown content to stdout and exits 0.
# On failure: exits 1 (caller should fall back to WebFetch).

set -euo pipefail

URL="$1"

is_markdown() {
  local content="$1"
  # Reject HTML pages accidentally returned as 200
  if echo "$content" | head -5 | grep -qi '<!doctype\|<html'; then
    return 1
  fi
  # Accept if it looks like Markdown (has at least one heading or link)
  if echo "$content" | grep -qE '^#{1,6} |^\[.+\]\(.+\)|\*\*|^- '; then
    return 0
  fi
  # Accept if it's plain text longer than 200 chars (likely Markdown without formatting)
  local len
  len=$(echo "$content" | wc -c)
  if [ "$len" -gt 200 ]; then
    return 0
  fi
  return 1
}

try_url() {
  local target="$1"
  local content
  content=$(curl -fsSL --max-time 10 -H "Accept: text/markdown, text/plain;q=0.9" "$target" 2>/dev/null) || return 1
  if is_markdown "$content"; then
    echo "$content"
    return 0
  fi
  return 1
}

# ── Strategy 1: Check HTTP Link header ──────────────────────────────
link_url=$(curl -fsSL --max-time 10 -o /dev/null -D - "$URL" 2>/dev/null \
  | grep -i '^link:' \
  | grep -i 'rel="alternate"' \
  | grep -i 'type="text/markdown"' \
  | sed -E 's/.*<([^>]+)>.*/\1/' \
  | head -1) || true

if [ -n "$link_url" ]; then
  # Resolve relative URLs
  case "$link_url" in
    http*) ;;
    /*) link_url="$(echo "$URL" | sed -E 's|(https?://[^/]+).*|\1|')$link_url" ;;
    *)  link_url="$(echo "$URL" | sed -E 's|/[^/]*$|/|')$link_url" ;;
  esac
  if try_url "$link_url"; then
    exit 0
  fi
fi

# ── Strategy 2: Add format=md query parameter ───────────────────────
if echo "$URL" | grep -q '?'; then
  format_url="${URL}&format=md"
else
  format_url="${URL}?format=md"
fi
if try_url "$format_url"; then
  exit 0
fi

# ── Strategy 3: Append .md (only if URL has a path beyond /) ────────
path=$(echo "$URL" | sed -E 's|https?://[^/]+||')
if [ -n "$path" ] && [ "$path" != "/" ]; then
  md_url=$(echo "$URL" | sed -E 's|/$||')".md"
  if try_url "$md_url"; then
    exit 0
  fi
fi

# ── Strategy 4: Append index-commonmark.md if path ends with / ──────
if [ -z "$path" ] || echo "$path" | grep -q '/$'; then
  idx_url=$(echo "$URL" | sed -E 's|/$||')"/index-commonmark.md"
  if try_url "$idx_url"; then
    exit 0
  fi
fi

# ── Strategy 5: Parse HTML for <link rel="alternate" type="text/markdown"> ──
html=$(curl -fsSL --max-time 10 "$URL" 2>/dev/null) || true
if [ -n "$html" ]; then
  alt_href=$(echo "$html" \
    | tr '\n' ' ' \
    | grep -oiE '<link[^>]+rel="alternate"[^>]+type="text/markdown"[^>]+>' \
    | grep -oiE 'href="[^"]+"' \
    | sed -E 's/href="([^"]+)"/\1/' \
    | head -1) || true

  # Also try reverse attribute order
  if [ -z "$alt_href" ]; then
    alt_href=$(echo "$html" \
      | tr '\n' ' ' \
      | grep -oiE '<link[^>]+type="text/markdown"[^>]+rel="alternate"[^>]+>' \
      | grep -oiE 'href="[^"]+"' \
      | sed -E 's/href="([^"]+)"/\1/' \
      | head -1) || true
  fi

  if [ -n "$alt_href" ]; then
    case "$alt_href" in
      http*) ;;
      /*) alt_href="$(echo "$URL" | sed -E 's|(https?://[^/]+).*|\1|')$alt_href" ;;
      *)  alt_href="$(echo "$URL" | sed -E 's|/[^/]*$|/|')$alt_href" ;;
    esac
    if try_url "$alt_href"; then
      exit 0
    fi
  fi
fi

# ── All strategies failed ───────────────────────────────────────────
exit 1
