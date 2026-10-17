#!/bin/bash
# rebase-llama-patches.sh
# Rebase llama.cpp patches from forks and branches

LLAMA_DIR="/mnt/data1/time-2026/10-october/16/llama.cpp"
PATCH_DIR="$LLAMA_DIR/patches"
mkdir -p "$PATCH_DIR"

echo "=== Llama.cpp Patch Rebasing ==="
echo "Llama directory: $LLAMA_DIR"
echo "Patch directory: $PATCH_DIR"
echo ""

# List of patches to process
PATCHES=(
    "/mnt/data1/2023/11/09/llama.cpp/ollama-flake/rocm.patch"
    "/mnt/data1/2023/12/03/go/pkg/mod/github.com/go-skynet/go-llama.cpp@v0.0.0-20230916071220-b471eb7d8c93/patches/1902-cuda.patch"
    "/home/mdupont/twitterstorm-worktrees/fallow-integration-full/patches/recovery-20261001/coprime-scheduler-wip.patch"
)

for patch in "${PATCHES[@]}"; do
    if [ -f "$patch" ]; then
        echo "=== Processing: $(basename $patch) ==="
        cp "$patch" "$PATCH_DIR/$(basename $patch)"
        echo "  Copied to: $PATCH_DIR/$(basename $patch)"
        
        # Try to apply
        cd "$LLAMA_DIR"
        if git apply --check "$PATCH_DIR/$(basename $patch)" 2>/dev/null; then
            echo "  ✅ Patch applies cleanly"
        else
            echo "  ⚠️  Patch needs rebasing"
        fi
    else
        echo "=== Missing: $patch ==="
    fi
done

echo ""
echo "=== Patches in $PATCH_DIR ==="
ls -la "$PATCH_DIR/"