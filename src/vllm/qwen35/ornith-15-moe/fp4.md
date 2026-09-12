# ornith-ai/Ornith-1.5-35B-A3B-NVFP4

## links

https://huggingface.co/ornith-ai/Ornith-1.5-35B-A3B-NVFP4

## hardware

32GB minimum
5090 probably too small
48GB blackwell recommended

## image

ghcr.io/rthomazel/interface/vllm/qwen35:v0.1.0

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
disk 10Gb
volume 26Gb

## Speculative decoding

built in MTP head

SC_NUM_SPECULATIVE_TOKENS=7

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

> set to debug if needed

HF_HUB_VERBOSITY=info
VLLM_LOGGING_LEVEL=info
TRANSFORMERS_VERBOSITY=info

> very verbose omit if not debugging

TORCH_LOGS="+inductor"

> if it hangs on two gpus

NCCL_P2P_DISABLE=1 # maybe not needed on 1 card
EXTRA_ARGS=--disable-custom-all-reduce
