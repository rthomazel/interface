# ornith-ai/Ornith-1.5-35B-A3B benchmarks

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
  --temperature 0.6 \
  --top-p 0.95 \
  --top-k 20
```

### realistic context benchmark

native model context 262K
average prefix cache hit rate (0.8)
262*.2 =~ 50K (tokens recomputed from scratch each turn)

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

## shisa-ai/Ornith-1.5-35B-A3B-MTP-FP8 temp 1.0 2x 5090, MTP off, 211tok/157tok/s 1.85M

spec decode config off

```
fast
Output token throughput (tok/s):         211.44
Mean TTFT (ms):                          621.38
Mean TPOT (ms):                          4.13
Mean ITL (ms):                           4.13
```

```
realistic
============ Serving Benchmark Result ============
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  202.80
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.04
Output token throughput (tok/s):         157.79
Peak output token throughput (tok/s):    228.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          2130.14
---------------Time to First Token----------------
Mean TTFT (ms):                          7743.75
Median TTFT (ms):                        7773.78
P99 TTFT (ms):                           7793.70
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          4.40
Median TPOT (ms):                        4.40
P99 TPOT (ms):                           4.41
---------------Inter-token Latency----------------
Mean ITL (ms):                           4.42
Median ITL (ms):                         4.42
P99 ITL (ms):                            4.95
==================================================
```

## ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp 1 PRO 5000, MTP 2, 219tok/s 1.5M

```
realistic
============ Serving Benchmark Result ============
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  145.49
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.05
Output token throughput (tok/s):         219.95
Peak output token throughput (tok/s):    104.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          2969.36
---------------Time to First Token----------------
Mean TTFT (ms):                          3857.68
Median TTFT (ms):                        3767.82
P99 TTFT (ms):                           4527.99
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          3.58
Median TPOT (ms):                        3.56
P99 TPOT (ms):                           3.96
---------------Inter-token Latency----------------
Mean ITL (ms):                           10.10
Median ITL (ms):                         10.13
P99 ITL (ms):                            10.52
---------------Speculative Decoding---------------
Acceptance rate (%):                     90.84
Acceptance length:                       2.82
Drafts:                                  11360
Draft tokens:                            22720
Accepted tokens:                         20639
Per-position acceptance (%):
  Position 0:                            95.53
  Position 1:                            86.15
==================================================
```

## ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 5, 270tok/s 1.5M

```
realistic
============ Serving Benchmark Result ============
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  118.21
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.07
Output token throughput (tok/s):         270.71
Peak output token throughput (tok/s):    85.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          3654.61
---------------Time to First Token----------------
Mean TTFT (ms):                          3796.57
Median TTFT (ms):                        3736.31
P99 TTFT (ms):                           4281.99
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          2.75
Median TPOT (ms):                        2.54
P99 TPOT (ms):                           4.13
---------------Inter-token Latency----------------
Mean ITL (ms):                           12.32
Median ITL (ms):                         12.42
P99 ITL (ms):                            13.08
---------------Speculative Decoding---------------
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
==================================================
```

## ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 6, 294tok/s 1.36M

```
realistic
============ Serving Benchmark Result ============
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  108.60
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.07
Output token throughput (tok/s):         294.66
Peak output token throughput (tok/s):    84.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          3977.96
---------------Time to First Token----------------
Mean TTFT (ms):                          3832.42
Median TTFT (ms):                        3776.36
P99 TTFT (ms):                           4268.39
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          2.44
Median TPOT (ms):                        1.96
P99 TPOT (ms):                           4.28
---------------Inter-token Latency----------------
Mean ITL (ms):                           12.56
Median ITL (ms):                         12.69
P99 ITL (ms):                            13.49
---------------Speculative Decoding---------------
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
==================================================
```

## ornith-ai/Ornith-1.5-35B-A3B-NVFP4 temp .6 PRO 5000, MTP 8, 289tok/s 1.30M

```
realistic
============ Serving Benchmark Result ============
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  110.70
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.07
Output token throughput (tok/s):         289.07
Peak output token throughput (tok/s):    69.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          3902.41
---------------Time to First Token----------------
Mean TTFT (ms):                          4228.50
Median TTFT (ms):                        3834.00
P99 TTFT (ms):                           6888.98
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          2.40
Median TPOT (ms):                        2.18
P99 TPOT (ms):                           3.32
---------------Inter-token Latency----------------
Mean ITL (ms):                           15.44
Median ITL (ms):                         15.66
P99 ITL (ms):                            16.29
---------------Speculative Decoding---------------
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