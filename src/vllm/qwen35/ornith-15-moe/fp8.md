# ornith-ai/Ornith-1.5-35B-A3B-FP8

## links

https://huggingface.co/ornith-ai/Ornith-1.5-35B-A3B-FP8

## hardware VRAM

48GB too small
50GB minimum to run
64Gb recommended

## image

ghcr.io/rthomazel/interface/vllm/qwen35:v0.29.0 or latest

## docker flags

-p 8000:8000 -p 22:22 --shm-size=16g --cap-add=SYS_PTRACE --cap-add=SYS_NICE --security-opt=seccomp=unconfined --ulimit=memlock=-1

## long context

default is 262k

VLLM_ALLOW_LONG_MAX_MODEL_LEN=1
HF_OVERRIDES=true
FACTOR=2

## default generation config

TEMPERATURE=0.8

## disk

model 40Gb
disk 8Gb
volume 44Gb

## Speculative decoding

built in MTP head

SC_NUM_SPECULATIVE_TOKENS=4

## env

VLLM_API_KEY=sk-keepit69
HF_HOME=/workspace/.huggingface
HF_TOKEN=\***\*\*\*\*\*\***
XDG_CACHE_HOME=/workspace/.cache
VLLM_CACHE_ROOT=/workspace/.cache/vllm
TORCH_HOME=/workspace/.cache/torch
TRITON_CACHE_DIR=/workspace/.cache/triton
FLASHINFER_WORKSPACE_DIR=/workspace/.cache/flashinfer
TORCHINDUCTOR_CACHE_DIR=/workspace/.cache/torchinductor
MODEL_NAME=ornith-ai/Ornith-1.5-35B-A3B-FP8
TENSOR_PARALLEL_SIZE=1
TMUX_START=true
ALIASES=true
PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
VLLM_MARLIN_USE_ATOMIC_ADD=1

# benchmarks

| hardware    | cost | volume | runs |
| ----------- | ---- | ------ | ---- |
| 1x pro 6000 | .75  | good   |      |
| 2x 5090     | .9   | good   |      |

### realistic context benchmark

native model context 262K
average prefix cache hit rate (0.8)
262\*.2 =~ 50K (tokens recomputed from scratch each turn)

ssh into instance

```
vllm bench serve \
  --base-url http://127.0.0.1:8000 \
  --model "$VLLM_MODEL_NAME" \
  --num-prompts 8 \
  --random-input-len 50000 \
  --random-output-len 4000 \
  --max-concurrency 1 \
  --header "Authorization=Bearer $VLLM_API_KEY" \
  --temperature 0.6 \
  --top-p 0.95 \
  --top-k 20
```

## 1 RTX PRO 6000 Max Q

kv 42 GiB
3M context
MTP 5

```
Output token throughput (tok/s):         234.40
Mean TTFT (ms):                          3278.02
Mean TPOT (ms):                          3.45
Mean ITL (ms):                           13.17
Acceptance rate (%):                     56.29
Acceptance length:                       3.81
Drafts:                                  8391
Draft tokens:                            41955
Accepted tokens:                         23616
Per-position acceptance (%):
  Position 0:                            84.60
  Position 1:                            65.12
  Position 2:                            55.96
  Position 3:                            38.65
  Position 4:                            37.11
```

## 2 RTX 5090

GPU_MEMORY_UTILIZATION=0.88
kv 2.24 GiB
380K
MTP 5

```
Output token throughput (tok/s):         249.39
Mean TTFT (ms):                          6020.27
Mean TPOT (ms):                          2.51
Mean ITL (ms):                           10.96
Acceptance rate (%):                     67.18
Acceptance length:                       4.36
Drafts:                                  7342
Draft tokens:                            36710
Accepted tokens:                         24661
Per-position acceptance (%):
  Position 0:                            91.45
  Position 1:                            79.28
  Position 2:                            61.26
  Position 3:                            55.52
  Position 4:                            48.38
```
