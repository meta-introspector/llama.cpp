#!/bin/bash
# analyze-llama-locate.sh
# Parse the all-llama-cpp-locate.txt file to extract patches, forks, branches, and other llama.cpp artifacts

LOCATE_FILE="/mnt/data1/time-2026/10-october/16/llama.cpp/all-llama-cpp-locate.txt"

echo "=== Llama.cpp Locate Analysis ==="
echo "Input file: $LOCATE_FILE"
echo "Total lines: $(wc -l < "$LOCATE_FILE")"
echo ""

echo "=== PATCHES ==="
grep "\.patch$" "$LOCATE_FILE" | sort -u

echo ""
echo "=== DIFF FILES ==="
grep "\.diff$" "$LOCATE_FILE" | sort -u

echo ""
echo "=== BRANCH HEADERS ==="
grep "/HEAD$" "$LOCATE_FILE" | head -20

echo ""
echo "=== PULL REQUEST BRANCHES ==="
grep "/refs/heads/" "$LOCATE_FILE" | cut -d: -f1 | sort -u | head -20

echo ""
echo "=== FORKS ==="
grep -i "fork" "$LOCATE_FILE" | head -10

echo ""
echo "=== GIT MODULES ==="
grep "\.git/modules/" "$LOCATE_FILE" | head -10

echo ""
echo "=== BRANCH NAMES ==="
grep "/refs/heads/" "$LOCATE_FILE" | sed 's|.*/refs/heads/||' | sort -u