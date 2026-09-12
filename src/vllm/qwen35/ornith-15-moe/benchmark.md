# ornith-ai/Ornith-1.5-35B-A3B benchmarks

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
 ==================================================
```

### ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 7, 332tok/s 1.40M

vllm updated to v0.28 from 0.27.1
kv mem 16.5GiB

```
================================================
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  96.19
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.08
Output token throughput (tok/s):         332.67
Peak output token throughput (tok/s):    93.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          4491.00
---------------Time to First Token--------------
Mean TTFT (ms):                          4066.07
Median TTFT (ms):                        3855.75
P99 TTFT (ms):                           5456.94
-----Time per Output Token (excl. 1st token)----
Mean TPOT (ms):                          1.99
Median TPOT (ms):                        1.64
P99 TPOT (ms):                           3.42
---------------Inter-token Latency--------------
Mean ITL (ms):                           12.11
Median ITL (ms):                         12.47
P99 ITL (ms):                            13.64
---------------Speculative Decoding-------------
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
================================================
```
