# ornith-ai/Ornith-1.5-35B-A3B benchmarks

| hardware    | cost | volume   | runs      |
| ----------- | ---- | -------- | --------- |
| 2x 3090     | .35  | ok       | slow      |
| 1x a6000    | .45  | very low | -         |
| 2x pro 4000 | .55  | good     | excellent |
| 1x 6000 ada | .60  | low      | decent    |
| 1x pro 5000 | .75  | good     | excellent |

## realistic context benchmark

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp 1 PRO 5000, MTP 2, 219tok/s 1.5M

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 5, 270tok/s 1.5M

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 6, 294tok/s 1.36M

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 8, 289tok/s 1.30M

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 7, 332tok/s 1.40M

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 2x PRO 4000, MTP 4, 271tok/s 960K

kv 5.4GiB
mtp 7 215tok/s
mtp 5 223tok/s

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 2x 3090, MTP 4, 78tok/s

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

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 A6000, MTP 5, 124tok/s 1.5M

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
