# nvidia/Qwen3.8-27B-NVFP4

https://huggingface.co/nvidia/Qwen3.8-27B-NVFP4

## links

https://github.com/vllm-project/recipes/blob/main/Qwen/Qwen3.5.md

## hardware

48GB minimum

## image

ghcr.io/rthomazel/interface/vllm/qwen35:v0.2.1 or latest

## docker flags

-p 8000:8000 -p 22:22 --shm-size=16g --cap-add=SYS_PTRACE --cap-add=SYS_NICE --security-opt=seccomp=unconfined --ulimit=memlock=-1

## long context

default is 262k

VLLM_ALLOW_LONG_MAX_MODEL_LEN=1
HF_OVERRIDES=true
FACTOR=2

### preserved thinking

if your client supports it turn it on.
PRESERVE_THINKING=true

### thinking tuning per request

add to litellm JSON params

```
## control thinking on/off
"extra_body": {
    "chat_template_kwargs": {
    "enable_thinking": false,
    }
}
```

## disk

model 22Gb
disk 8Gb
volume 25Gb

## env

VLLM_API_KEY=sk-keepit69
HF_HOME=/workspace/.huggingface
VLLM_ALLOW_LONG_MAX_MODEL_LEN=0
HF_TOKEN=\***\*\*\*\*\*\***
XDG_CACHE_HOME=/workspace/.cache
VLLM_CACHE_ROOT=/workspace/.cache/vllm
TORCH_HOME=/workspace/.cache/torch
TRITON_CACHE_DIR=/workspace/.cache/triton
FLASHINFER_WORKSPACE_DIR=/workspace/.cache/flashinfer
TORCHINDUCTOR_CACHE_DIR=/workspace/.cache/torchinductor
MODEL_NAME=nvidia/Qwen3.8-27B-NVFP4
TENSOR_PARALLEL_SIZE=1
TMUX_START=true
ALIASES=true

> if it hangs on two gpus

NCCL_P2P_DISABLE=1 # maybe not needed on 1 card
EXTRA_ARGS=--disable-custom-all-reduce

# benchmarks

## FP4 / INT4

This model is pretty heavy needs Pro 5000 or 2 5090.

todo
- nvidia/Qwen3.8-27B-NVFP4 -- seems to be 20% faster than other quants
- 1 4090 48 .6$/h low volume
- 2 4090 .8$/h low volume
- 2 pro 4000 .55$/h
- 2 5090 .95$/h
- 1 pro 5000 .7$/h

### cyankiwi/Qwen3.6-27B-AWQ-INT4 RTX 4090 48Gb, MTP 3, 82tok/s, 511K

Output token throughput (tok/s): 82.01
Mean TTFT (ms): 1564.14
Acceptance rate (%): 73.40
Acceptance length: 3.20
Per-position acceptance (%):
Position 0: 84.44
Position 1: 72.58
Position 2: 63.18

### cyankiwi/Qwen3.6-27B-AWQ-INT4 RTX 4090 48Gb, MTP 4, 85tok/s, 498K

Output token throughput (tok/s): 84.80
Mean TTFT (ms): 1598.19
Mean TPOT (ms): 10.24
Mean ITL (ms): 36.75
Acceptance rate (%): 64.85
Acceptance length: 3.59
Draft tokens: 22804
Per-position acceptance (%):
Position 0: 86.35
Position 1: 69.53
Position 2: 58.60
Position 3: 44.92

### unsloth/Qwen3.8-27B-NVFP4 2 RTX PRO 4000, MTP 3, 75tok/s, 432K

GPU utilization 92%
MTP 2: 10% slower, despite higher acceptance. same acceptance length.

```
Output token throughput (tok/s):         76.73
Mean TTFT (ms):                          1300.93
Mean TPOT (ms):                          11.77
Mean ITL (ms):                           34.32
Acceptance rate (%):                     63.97
Acceptance length:                       2.92
Draft tokens:                            21054
  Position 0:                            72.87
  Position 1:                            62.95
  Position 2:                            56.10
```

### unsloth/Qwen3.8-27B-NVFP4 RTX 4090 48Gb, MTP 2, 61tok/s, 522K

Output token throughput (tok/s): 61.58
Mean TTFT (ms): 1437.58
Acceptance rate (%): 71.04
Acceptance length: 2.42
Per-position acceptance (%):
Position 0: 76.18
Position 1: 65.89

### unsloth/Qwen3.8-27B-NVFP4 RTX 4090 48Gb, MTP 3, 72tok/s, 514K

Output token throughput (tok/s): 72.03
Mean TTFT (ms): 1389.47
Acceptance rate (%): 66.11
Acceptance length: 2.98
Per-position acceptance (%):
Position 0: 77.93
Position 1: 64.58
Position 2: 55.83

### unsloth/Qwen3.8-27B-NVFP4 RTX 5000 48Gb, MTP 3, 78tok/s, 433K

Output token throughput (tok/s): 78.09
Mean TTFT (ms): 820.51
Acceptance length: 3.16
Acceptance rate (%): 71.86
Per-position acceptance (%):
Position 0: 79.46
Position 1: 71.14
Position 2: 64.98

### unsloth/Qwen3.8-27B-NVFP4 RTX 5000 48Gb, MTP 5, 83tok/s, 417K

Output token throughput (tok/s): 83.27
Mean TTFT (ms): 786.59
Mean TPOT (ms): 11.25
Mean ITL (ms): 40.80
Acceptance rate (%): 52.68
Acceptance length: 3.63
Draft tokens: 28215
Position 0: 73.12
Position 1: 59.33
Position 2: 49.28
Position 3: 42.94
Position 4: 38.74

## nvidia/Qwen3.8-27B-NVFP4 2x pro 4000, MTP 4, 27tok/s, 270K

very low result, unusual.
tricky to run, several OOMs. KV size 4.8GiB
GPU_MEMORY_UTILIZATION=0.81
PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
MAX_NUM_BATCHED_TOKENS=32K

```
Output token throughput (tok/s):         27.45
Mean TTFT (ms):                          1106.39
Mean TPOT (ms):                          35.38
Mean ITL (ms):                           126.35
Acceptance rate (%):                     64.40
Acceptance length:                       3.58
Drafts:                                  5730
Draft tokens:                            22920
Accepted tokens:                         14760
Per-position acceptance (%):
  Position 0:                            74.76
  Position 1:                            66.79
  Position 2:                            62.01
  Position 3:                            54.03
```
