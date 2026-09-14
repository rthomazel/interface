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

> set to debug if needed

HF_HUB_VERBOSITY=info
VLLM_LOGGING_LEVEL=info
TRANSFORMERS_VERBOSITY=info

> very verbose omit if not debugging

TORCH_LOGS="+inductor"

> if it hangs on two gpus

NCCL_P2P_DISABLE=1 # maybe not needed on 1 card
EXTRA_ARGS=--disable-custom-all-reduce
