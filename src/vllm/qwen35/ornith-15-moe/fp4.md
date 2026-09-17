# ornith-ai/Ornith-1.5-35B-A3B-NVFP4

## links

https://huggingface.co/ornith-ai/Ornith-1.5-35B-A3B-NVFP4

## hardware

32GB minimum
5090 too small
48GB blackwell recommended

## image

ghcr.io/rthomazel/interface/vllm/qwen35:v0.1.0 or latest

## docker flags

-p 8000:8000 -p 22:22 --shm-size=16g --cap-add=SYS_PTRACE --cap-add=SYS_NICE --security-opt=seccomp=unconfined --ulimit=memlock=-1

## long context

default is 262k

VLLM_ALLOW_LONG_MAX_MODEL_LEN=1
HF_OVERRIDES=true
FACTOR=2

## default generation config

TEMPERATURE=0.6

## disk

model 23Gb
disk 8Gb
volume 26Gb

## Speculative decoding

built in MTP head

SC_NUM_SPECULATIVE_TOKENS=7

## startup script

these might have path issues.
not necessary, only used for b12x backend, not working.

```
/usr/local/bin/uv pip install --system "vllm[b12x]"
```

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
MODEL_NAME=ornith-ai/Ornith-1.5-35B-A3B-NVFP4
TENSOR_PARALLEL_SIZE=1
TMUX_START=true
ALIASES=true
PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

> use optimized moe nvpf4 backend on SM120/SM121, +5%
> see https://github.com/vllm-project/vllm/pull/52018
> does NOT work, avoid

EXTRA_ARGS="--moe-backend b12x"

> set to debug if needed

HF_HUB_VERBOSITY=info
VLLM_LOGGING_LEVEL=info
TRANSFORMERS_VERBOSITY=info

> very verbose omit if not debugging

TORCH_LOGS="+inductor"

> if it hangs on two gpus

NCCL_P2P_DISABLE=1 # maybe not needed on 1 card
EXTRA_ARGS=--disable-custom-all-reduce

# benchmarks

| hardware    | cost | volume | runs      |
| ----------- | ---- | ------ | --------- |
| 2x 3090     | .35  | ok     | slow      |
| 2x pro 4000 | .55  | good   | excellent |
| 1x 6000 ada | .60  | low    | decent    |
| 1x pro 5000 | .75  | good   | excellent |

best GPU: 1 RTX pro 5000
pro 5000 runs 30% faster than pro 4000 and only 10% more expensive

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

## 1 RTX PRO 5000

219tok/s
temp 1
MTP 2
context 1.5M

```
Output token throughput (tok/s):         219.95
Mean TTFT (ms):                          3857.68
Mean TPOT (ms):                          3.58
Mean ITL (ms):                           10.10
Acceptance rate (%):                     90.84
Acceptance length:                       2.82
Drafts:                                  11360
Draft tokens:                            22720
Accepted tokens:                         20639
Per-position acceptance (%):
  Position 0:                            95.53
  Position 1:                            86.15
```

270tok/s
temp .6
MTP 5
context 1.5M

```
Output token throughput (tok/s):         270.71
Mean TTFT (ms):                          3796.57
Mean TPOT (ms):                          2.75
Mean ITL (ms):                           12.32
Acceptance rate (%):                     69.74
Acceptance length:                       4.49
Drafts:                                  7133
Draft tokens:                            35665
Accepted tokens:                         24872
Per-position acceptance (%):
  Position 0:                            91.67
  Position 1:                            77.86
  Position 2:                            65.09
  Position 3:                            59.33
  Position 4:                            54.73
```

289tok/s
temp .6
MTP 8
context 1.30M

```
Output token throughput (tok/s):         289.07
Mean TTFT (ms):                          4228.50
Mean TPOT (ms):                          2.40
Mean ITL (ms):                           15.44
Acceptance rate (%):                     67.91
Acceptance length:                       6.43
Drafts:                                  4978
Draft tokens:                            39824
Accepted tokens:                         27045
Per-position acceptance (%):
  Position 0:                            97.45
  Position 1:                            93.95
  Position 2:                            91.08
  Position 3:                            78.47
  Position 4:                            48.25
  Position 5:                            46.52
  Position 6:                            46.24
  Position 7:                            41.32
```

294tok/s
temp .6
MTP 6
context 1.36M

```
Output token throughput (tok/s):         294.66
Mean TTFT (ms):                          3832.42
Mean TPOT (ms):                          2.44
Mean ITL (ms):                           12.56
Acceptance rate (%):                     69.33
Acceptance length:                       5.16
Drafts:                                  6205
Draft tokens:                            37230
Accepted tokens:                         25811
Per-position acceptance (%):
  Position 0:                            92.47
  Position 1:                            84.85
  Position 2:                            65.16
  Position 3:                            61.79
  Position 4:                            58.13
  Position 5:                            53.57
```

332tok/s
temp .6
MTP 7
context 1.40M
vllm updated to v0.28 from 0.27.1
kv mem 16.5GiB

```
Output token throughput (tok/s):         332.67
Mean TTFT (ms):                          4066.07
Mean TPOT (ms):                          1.99
Mean ITL (ms):                           12.11
Acceptance rate (%):                     72.29
Acceptance length:                       6.06
Drafts:                                  5282
Draft tokens:                            36974
Accepted tokens:                         26729
Per-position acceptance (%):
Parent commit (@-):
  Position 0:                            96.57
  Position 1:                            91.40
  Position 2:                            79.67
  Position 3:                            68.10
  Position 4:                            63.73
  Position 5:                            53.96
  Position 6:                            52.61
```

## 2 RTX PRO 4000

mtp 7 215tok/s

mtp 5 223tok/s

271tok/s - nice but unable to reproduce
temp .6
MTP 4
context 960K
vllm 28 - image 0.1
kv 5.4GiB

```
Output token throughput (tok/s):         271.71
Mean TTFT (ms):                          4627.25
Mean TPOT (ms):                          2.52
Mean ITL (ms):                           10.28
Acceptance rate (%):                     76.86
Acceptance length:                       4.07
Drafts:                                  7856
Draft tokens:                            31424
Accepted tokens:                         24153
Per-position acceptance (%):
  Position 0:                            95.19
  Position 1:                            85.20
  Position 2:                            76.74
  Position 3:                            50.32
```

220tok/s
220K context
vllm 29 - image 0.2
kv 1.7GiB
EXTRA_ARGS="--disable-custom-all-reduce"
GPU_MEMORY_UTILIZATION=0.87
MAX_NUM_SEQS=32

```
lost bench numbers here, what I remember above
```

226tok/s
270K
temp .6
MTP 4
kv 1.65GiB

vllm 28 - v0.1.0
MAX_NUM_BATCHED_TOKENS=32768
EXTRA_ARGS="--disable-custom-all-reduce --enable-chunked-prefill"
GPU_MEMORY_UTILIZATION=0.87

```
Output token throughput (tok/s):         226.19
Mean TTFT (ms):                          4976.10
Mean TPOT (ms):                          3.18
Mean ITL (ms):                           11.73
Acceptance rate (%):                     67.19
Acceptance length:                       3.69
Drafts:                                  8678
Draft tokens:                            34712
Accepted tokens:                         23322
Per-position acceptance (%):
scheduling-processo
  Position 0:                            88.19
  Position 1:                            79.52
  Position 2:                            56.59
  Position 3:                            44.45
```

231tok/2
context 275K
kv 1.65
VLLM_MARLIN_USE_ATOMIC_ADD=1 # seems to help a bit
vllm 28 - v0.1.0
MAX_NUM_BATCHED_TOKENS=32768
EXTRA_ARGS="--disable-custom-all-reduce --enable-chunked-prefill"
GPU_MEMORY_UTILIZATION=0.87

```
Output token throughput (tok/s):         231.45
Mean TTFT (ms):                          5029.81
Mean TPOT (ms):                          3.06
Mean ITL (ms):                           11.68
Acceptance rate (%):                     70.17
Acceptance length:                       3.81
Drafts:                                  8409
Draft tokens:                            33636
Accepted tokens:                         23604
Per-position acceptance (%):
scheduling-processo
  Position 0:                            88.70
  Position 1:                            79.31
  Position 2:                            61.14
  Position 3:                            51.55
```

234tok/s
vllm 29 - v0.2
295K
kv 1.76GiB
EXTRA_ARGS="--disable-custom-all-reduce"
GPU_MEMORY_UTILIZATION=0.87
VLLM_MARLIN_USE_ATOMIC_ADD=1

```
Output token throughput (tok/s):         234.70
Mean TTFT (ms):                          5004.12
Mean TPOT (ms):                          3.01
Mean ITL (ms):                           10.38
Acceptance rate (%):                     61.27
Acceptance length:                       3.45
Drafts:                                  9275
Draft tokens:                            37100
Accepted tokens:                         22733
Per-position acceptance (%):
scheduling-78bf964c
  Position 0:                            83.40
  Position 1:                            68.73
  Position 2:                            52.71
  Position 3:                            40.26
```

242tok/s
vllm 29 - v0.2
287K
kv 1.72GiB
GPU_MEMORY_UTILIZATION=0.87
VLLM_MARLIN_USE_ATOMIC_ADD=1

```
Output token throughput (tok/s):         242.22
Mean TTFT (ms):                          4967.77
Mean TPOT (ms):                          2.89
Mean ITL (ms):                           10.39
Acceptance rate (%):                     64.87
Acceptance length:                       3.59
Drafts:                                  8902
Draft tokens:                            35608
Accepted tokens:                         23099
Per-position acceptance (%):
  Position 0:                            88.00
  Position 1:                            77.18
  Position 2:                            60.53
  Position 3:                            33.77
```

## 2 RTX 3090

78tok/s
temp .6
MTP 4

required env, else crashes with `AssertionError: auto_functionalized was not removed`
EXTRA_ARGS="--linear-backend marlin"
not optimized further, maybe dflash, maybe different MTP

```
Output token throughput (tok/s):         78.76
Mean TTFT (ms):                          9824.60
Mean TPOT (ms):                          10.24
Mean ITL (ms):                           33.66
Acceptance rate (%):                     57.12
Acceptance length:                       3.28
Drafts:                                  9744
Draft tokens:                            38976
Accepted tokens:                         22264
Per-position acceptance (%):
  Position 0:                            67.68
  Position 1:                            60.56
  Position 2:                            53.14
  Position 3:                            47.11
```

## 1 RTX A6000

124tok/s
temp .6
MTP 5
context 1.5M
kv mem 17.4GiB
not optimized could try lower MTP

```
Output token throughput (tok/s): 123.95
Mean TTFT (ms): 4824.31
Mean TPOT (ms): 6.86
Mean ITL (ms): 22.46
Acceptance rate (%): 45.39
Acceptance length: 3.27
Drafts: 9786
Draft tokens: 48930
Accepted tokens: 22211
Per-position acceptance (%):
Position 0: 82.71
Position 1: 46.16
Position 2: 37.25
Position 3: 32.42
Position 4: 28.43
```
