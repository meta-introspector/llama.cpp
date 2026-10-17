# Llama Worker Twin for llama.cpp

## Overview

This directory contains the **Llama Worker Twin** integration for the llama.cpp project. It provides:

- AI-enhanced mathematical reasoning capabilities
- Proof sketch generation
- Mathematical conjecture generation
- Proof step validation
- Natural language to Lean pseudocode translation

## Structure

```
lean-worker-twin/
├── README.md              # This file
├── flake.nix             # Nix build configuration
├── lean-worker.toml      # Worker configuration
├── src/
│   └── llama_worker_twin.lean  # Core Lean 4 module
└── examples/
    └── basic_usage.lean  # Example usage
```

## Features

### Proof Assistance
- Generate proof sketches for mathematical theorems
- Validate proof steps for correctness
- Provide mathematical conjecture suggestions

### Integration
- Seamless integration with Lean Workers Union
- Gokujo Layer Architecture compatible
- Custom URL generation for results

### Configuration
- Configurable model paths and parameters
- Worker lifecycle management
- Dependency tracking

## Building and Running

### Using Nix (Recommended)

```bash
cd /mnt/data1/time-2026/10-october/16/llama.cpp/lean-worker-twin
nix build .#llama-worker-twin
nix build .#checks.test
```

### Manual Lean 4 Setup

```bash
# Install Lean 4
elan install leanprover/lean4

# Build the module
lake build

# Run examples
lake run examples/basic_usage.lean
```

## License

MIT - See the main llama.cpp repository for licensing details.