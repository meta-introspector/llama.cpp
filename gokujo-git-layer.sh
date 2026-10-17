#!/bin/bash
# Gokujo Git Layer - Reads relative paths from all_aristo_git.txt
# This script feeds the Gokujo system with relative git paths

GIT_FILE="/mnt/data1/all_aristo_git.txt"
OUTPUT_LOG="/mnt/data1/gokujo-git-paths.log"
BATCH_SIZE=100  # Process paths in batches

if [ ! -f "$GIT_FILE" ]; then
    echo "Error: File $GIT_FILE not found!" >&2
    exit 1
fi

echo "=== Gokujo Git Layer Reader ==="
echo "Reading from: $GIT_FILE"
echo "Total entries: $(wc -l < "$GIT_FILE")"
echo ""

count=0
batch=0
processed_paths=()

while IFS= read -r line; do
    [ -z "$line" ] && continue
    
    # Extract the relative path (remove aristotle-* prefix if present)
    rel_path=$(echo "$line" | sed 's/^aristotle-[^/]*\///')
    
    # Process each path
    case "$rel_path" in
        *".lean")
            # Lean file - add to batch for processing
            processed_paths+=("$rel_path")
            ((batch++))
            printf "  [LEAN] %s\n" "$rel_path"
            ;;
        *)
            # Other file type
            processed_paths+=("$rel_path")
            ((batch++))
            printf "  [OTHER] %s\n" "$rel_path"
            ;;
    esac
    
    ((count++))
    
    # Print batch progress every 100 paths
    if [ $batch -ge 100 ]; then
        echo "... processed $count paths, batch size: $BATCH_SIZE"
        echo ""
        batch=0
    fi
done < "$GIT_FILE"

echo ""
echo "=== Summary ==="
echo "Total paths processed: $count"
lean_count=0
other_count=0
for p in "${processed_paths[@]}"; do
    case "$p" in
        *.lean)
            lean_count=$((lean_count+1))
            ;;
        *)
            other_count=$((other_count+1))
            ;;
esac
done

echo "Lean files: $lean_count"
echo "Other files: $other_count"
echo ""

echo "Relative paths collected:" > "$OUTPUT_LOG"
for p in "${processed_paths[@]}"; do
    echo "$p" >> "$OUTPUT_LOG"
done

echo "Wrote $((count)) paths to $OUTPUT_LOG"
echo "Done!"
