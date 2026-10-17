# Gokujo Integration Steps for llama.cpp

## ✅ Phase 1: Nix Build (Complete - Structure Fixed)
- Flake.nix updated to include llama-worker-twin package
- Scope.nix updated for proper build configuration
- Development environment ready

## 🔄 Phase 2: Fork Discovery (Complete)
### Key Forks Identified:
1. **Ollama Fork** (`/mnt/data1/2023/10/30/ollama-build/llama/llama.cpp-fork`) - HIGH priority
2. **Go Integration** (`/mnt/data1/2023/09/16/LocalAI/go-llama/llama.cpp`) - MEDIUM
3. **Stable Go** (`/mnt/data1/2023/09/16/LocalAI/go-llama-stable/llama.cpp`) - MEDIUM
4. **Ollama Main** (`/mnt/data1/2023/10/30/ollama/llama.cpp`) - LOW

### Patches Found:
- ROCM patch: `/mnt/data1/2023/11/09/llama.cpp/ollama-flake/rocm.patch`
- CUDA patch: `/mnt/data1/2023/12/03/go/pkg/mod/github.com/go-skynet/go-llama.cpp@v0.0.0-20230916071220-b471eb7d8c93/patches/1902-cuda.patch`
- Scheduler patch: `/home/mdupont/twitterstorm-worktrees/fallow-integration-full/patches/recovery-20261001/coprime-scheduler-wip.patch`

### Branches Found:
- `master`, `broken`, `bugfix`, `feature/*`, `cuda`, `patch`, `introspector-grammar`, `compc`, `main`

## 🔧 Phase 3: Patch Rebasing (In Progress)
### Applied Patches:
- **coprime-scheduler-wip.patch** - Scheduler improvements with workerIndex parameterization
- **rocm.patch** - ROCM GPU compilation fixes
- **1902-cuda.patch** - CUDA binding model creation functions

## 🚀 Phase 4: Runtime Extraction and Gokujo Code Injection

### 4.1 Runtime Components Identified:
```
src/
├── llama.cpp          (main entry point)
├── llama.h            (header)
├── llama-bindings.h   (bindings interface)
├── ggml/              (GGML integration)
│   └── src/
│       ├── ggml-alloc.c
│       ├── ggml-backend.c
│       └── ggml-cuda.c
└── examples/
    ├── llava_clip.cpp
    └── server.cpp
```

### 4.2 Runtime Values to Extract:
```c
struct RuntimeMetrics {
    double inference_time;
    int tokens_generated;
    int context_size;
    int threads_used;
    double temperature;
    std::string model_name;
    std::map<std::string, double> performance_metrics;
};
```

### 4.3 Gokujo Code Injection Plan:
```cpp
// llama.cpp with Gokujo integration
#include "gokujo_layer.h"

namespace gokujo {
    class LlamaGokujoLayer : public GokujoLayer {
    public:
        virtual std::string getLayerName() const override {
            return "LlamaGokujo";
        }
        
        virtual bool processFile(const std::string& filepath) override {
            // Process Lean files for mathematical reasoning
            return filepath.ends_with(".lean");
        }
        
        virtual std::vector<std::string> getDependencies() const override {
            return {"Core", "Analytic", "Compute", "Verification"};
        }
        
        virtual void onLayerActivated() override {
            // Initialize Gokujo layer
        }
    };
}
```

## 🔌 Phase 5: FFI Bindings

### 5.1 FFI Interface (`llama_twin_ffi.h`):
```c
FFIReasoningResult ffi_generate_proof_sketch(const char* theorem);
FFIReasoningResult ffi_generate_conjecture(const char* area);
bool ffi_validate_proof_step(const char* proof, const char* step);
const char* ffi_translate_to_lean(const char* natural);
```

### 5.2 FFI Implementation (`llama_twin_ffi.cpp`):
Bridge Lean Worker Twin to llama.cpp inference engine.

## 🔄 Phase 6: lib-zos FFI

### 6.1 lib-zos Bridge (`lib-zos_ffi.h`):
```c
bool initialize_lib_zos_ffi(const char* config_path);
bool register_zos_worker(const char* worker_id, const char* endpoint);
bool submit_result_to_zos(const char* task_id, const char* result_data);
```

### 6.2 Integration (`lib_zos_ffi.cpp`):
Bridge between Llama Worker Twin and lib-zos distributed system.

## 🧪 Phase 7: Testing and Validation

### 7.1 Integration Tests:
- Nix build verification
- FFI compilation check
- Runtime integration test
- Performance validation

### 7.2 Performance Benchmarks:
- Inference time measurements
- Token generation rate
- Memory usage profiling
- Layer activation overhead

## 🚀 Phase 8: Deployment

### 8.1 Build Artifacts:
Deployment package with all necessary files for production.

### 8.2 Production Configuration:
YAML config for containerized deployment with resource limits.

## 🎯 Success Criteria:
- Nix build passes
- FFI bindings compile successfully  
- Gokujo layer integrated into llama.cpp
- lib-zos FFI operational
- All features implemented and tested
- Performance benchmarks met
- Production-ready deployment achieved