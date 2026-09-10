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

## ornith-ai/Ornith-1.5-35B-A3B-NVFP4 PRO 5000, MTP 2, tok/s 1.5M

temp 1.0

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

temp 0.6

```
realistic
============ Serving Benchmark Result ============
Successful requests:                     8
Failed requests:                         0
Maximum request concurrency:             1
Benchmark duration (s):                  121.69
Total input tokens:                      400000
Total generated tokens:                  32000
Request throughput (req/s):              0.07
Output token throughput (tok/s):         262.96
Peak output token throughput (tok/s):    104.00
Peak concurrent requests:                2.00
Total token throughput (tok/s):          3550.01
---------------Time to First Token----------------
Mean TTFT (ms):                          484.89
Median TTFT (ms):                        489.08
P99 TTFT (ms):                           493.09
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          3.68
Median TPOT (ms):                        3.64
P99 TPOT (ms):                           4.24
---------------Inter-token Latency----------------
Mean ITL (ms):                           10.05
Median ITL (ms):                         10.11
P99 ITL (ms):                            10.43
---------------Speculative Decoding---------------
Acceptance rate (%):                     86.45
Acceptance length:                       2.73
Drafts:                                  11727
Draft tokens:                            23454
Accepted tokens:                         20277
Per-position acceptance (%):
  Position 0:                            95.66
  Position 1:                            77.25
==================================================
```