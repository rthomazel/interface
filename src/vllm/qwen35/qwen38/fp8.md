# Qwen/Qwen3.8-27B-FP8

https://huggingface.co/Qwen/Qwen3.8-27B-FP8

## links

https://github.com/vllm-project/recipes/blob/main/Qwen/Qwen3.5.md

## hardware

48GB minimum
2x 5090 recommended

## image

ghcr.io/rthomazel/interface/vllm/qwen35:v0.0.6 or latest

## docker flags

-p 8000:8000 -p 22:22 --shm-size=16g --cap-add=SYS_PTRACE --cap-add=SYS_NICE --security-opt=seccomp=unconfined --ulimit=memlock=-1

## long context

default is 262k

--max-model-len 1010000
--hf-overrides '{"text_config": {"rope_parameters": {"mrope_interleaved": true, "mrope_section": [11, 11, 10], "rope_type": "yarn", "rope_theta": 10000000, "partial_rotary_factor": 0.25, "factor": 4.0, "original_max_position_embeddings": 262144}}}'

524000, update factor to 2.0. Keep other params the same, They are architectural.

### preserved thinking

keep preserve thinking off unless your client supports it, otherwise turn it on.
--default-chat-template-kwargs '{"preserve_thinking": false}'

### thinking tuning per request

add to litellm JSON params

```
## control thinking on/off
"extra_body": {
    "chat_template_kwargs": {
    "enable_thinking": false,
    "preserve_thinking": false
    }
}
```

```
## how much thinking. Setting a max helps with overall control, but not required.
## effort: low, medium, xhigh, none
"max_tokens": 16384,
"extra_body": {
  "thinking_token_budget": 10000,
  "reasoning_effort": "medium"
}
```

## default generation config

TEMPERATURE=1.0
TOP_P=0.95
TOP_K=20
MIN_P=0.0
PRESENCE_PENALTY=0.0
REPETITION_PENALTY=1.0

### ideas to tweak

A — current
T=1.0, top_p=.95, top_k=20, min_p=0

B — more deterministic
T=.8, top_p=.95, top_k=20, min_p=0

C — focused
T=.8, top_p=.95, top_k=20, min_p=.05

## disk

model 31Gb
disk 10Gb
volume 40Gb

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

> set to debug if needed

HF_HUB_VERBOSITY=info
VLLM_LOGGING_LEVEL=info
TRANSFORMERS_VERBOSITY=info

> very verbose omit if not debugging

TORCH_LOGS="+inductor"

> if it hangs on two gpus

NCCL_P2P_DISABLE=1 # maybe not needed on 1 card
EXTRA_ARGS=--disable-custom-all-reduce

# unsloth/Qwen3.8-27B-NVFP4

https://huggingface.co/unsloth/Qwen3.8-27B-NVFP4

hard to run on 2 RTX 4000 PRO

# Qwen/Qwen3.8-27B benchmarks

all benchmarks are fast

| n   | RTX card    | $/h  | VRAM  | MTP | tok/s | KV   | quant   | status | competitive    |
| --- | ----------- | ---- | ----- | --- | ----- | ---- | ------- | ------ | -------------- |
| 2   | PRO 4000 BW | 0.49 | 48 GB | 3   | 66    | 165K | fp8     | done   | no, slow       |
| 2   | PRO 4000 BW | 0.49 | 48 GB | 3   | 75    | 432K | nvfp4   | done   | yes, cost      |
| 1   | 4090 48 GB  | 0.59 | 48 GB | 3   | 72    | 514K | nvfp4   | done   | maybe          |
| 1   | 4090 48 GB  | 0.59 | 48 GB | 4   | 85    | 498K | awqint4 | done   | no, quality    |
| 1   | PRO 5000 BW | 0.73 | 48 GB | 5   | 83    | 417K | nvfp4   | done   | no, same price |
| 2   | 5090 BW     | 0.76 | 64 GB | 4   | 91    | 480K | fp8     | done   | yes, best ⭐    |

### fast benchmark

ssh into instance

```
vllm bench serve \
  --base-url http://127.0.0.1:8000 \
  --model "$VLLM_MODEL_NAME" \
  --num-prompts 20 \
  --random-input-len 4096 \
  --random-output-len 1024 \
  --max-concurrency 1 \
  --header "Authorization=Bearer $VLLM_API_KEY" \
  --temperature 1.0 \
  --top-p 0.95 \
  --top-k 20
```

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
  --temperature 1.0 \
  --top-p 0.95 \
  --top-k 20
```

## FP8

best:
Qwen/Qwen3.8-27B-FP8 2 RTX 5090, MTP 4, 91tok/s, 480K

### Qwen/Qwen3.8-27B-FP8 2 RTX PRO 4000, MTP 3, 66tok/s, 165K

2 and 4 also tested, 3 seemed better

```
Peak output token throughput (tok/s):    25.00
Mean TTFT (ms):                          2522.55
Mean TPOT (ms):                          12.65
Mean ITL (ms):                           40.50
Acceptance rate (%):                     73.47
Acceptance length:                       3.20
Draft tokens:                            19179
  Position 0:                            83.42
  Position 1:                            72.91
  Position 2:                            64.07
```

### Qwen/Qwen3.8-27B-FP8 2 RTX 5090, MTP 3, 72tok/s, 550K

Output token throughput (tok/s): 72.10
Mean TTFT (ms): 2168.54
Mean TPOT (ms): 11.76
Mean ITL (ms): 36.00
Acceptance rate (%): 68.81
Acceptance length: 3.06
Per-position acceptance (%):
Position 0: 76.56
Position 1: 68.76
Position 2: 61.10

### Qwen/Qwen3.8-27B-FP8 2 RTX 5090, MTP 5, 90tok/s, 492K

Output token throughput (tok/s): 90.29
Mean TTFT (ms): 1342.35
Mean TPOT (ms): 9.77
Mean ITL (ms): 32.36
Acceptance rate (%): 46.35
Acceptance length: 3.32
Per-position acceptance (%):
Position 0: 59.76
Position 1: 51.28
Position 2: 44.69
Position 3: 39.32
Position 4: 36.70

### Qwen/Qwen3.8-27B-FP8 fp16 KV, dflash, 8k batch, 2 RTX 5090, MTP 7 eager, 127tok/s, 226K

not good with higher context, feels slower than 70tok/s

KV_CACHE_DTYPE=auto
SC_NUM_SPECULATIVE_TOKENS=7
SC_MODEL=incoai/Qwen3.8-27B-DFlash2
SC_METHOD=dflash
MAX_NUM_BATCHED_TOKENS=8192
SC_ENFORCE_EAGER=true

```
Output token throughput (tok/s):         127.09
Mean TTFT (ms):                          1787.39
Mean TPOT (ms):                          6.13
Mean ITL (ms):                           26.38
Acceptance rate (%):                     47.33
Acceptance length:                       4.31
Accepted tokens:                         15752
Per-position acceptance (%):
  Position 0:                            71.62
  Position 1:                            55.72
  Position 2:                            48.17
  Position 3:                            43.10
  Position 4:                            40.13
  Position 5:                            37.51
  Position 6:                            35.09
```

### Qwen/Qwen3.8-27B-FP8 2 RTX 5090, MTP 4, 91tok/s, 480K

MAX_NUM_BATCHED_TOKENS=8192 seems to improve TTFT dramatically

```
Output token throughput (tok/s):         90.90
Mean TTFT (ms):                          2505.14
Mean TPOT (ms):                          8.56
Mean ITL (ms):                           32.06
Acceptance rate (%):                     68.80
Acceptance length:                       3.75
Drafts:                                  5464
Draft tokens:                            21856
Accepted tokens:                         15037
Per-position acceptance (%):
  Position 0:                            84.35
  Position 1:                            74.34
  Position 2:                            62.76
  Position 3:                            53.75
```


