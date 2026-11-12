"""Tests for the vLLM monitor metric parser."""

from __future__ import annotations

import importlib.machinery
import importlib.util
import unittest
from pathlib import Path

SCRIPT_PATH = Path(__file__).parents[1] / "vllm-monitor"
loader = importlib.machinery.SourceFileLoader("vllm_monitor", str(SCRIPT_PATH))
spec = importlib.util.spec_from_loader(loader.name, loader)
vllm_monitor = importlib.util.module_from_spec(spec)
loader.exec_module(vllm_monitor)
parse_metrics = vllm_monitor.parse_metrics


class TestParseMetrics(unittest.TestCase):
    def test_parses_tail_and_full_log_metrics(self):
        lines = [
            "INFO Using max model len 111111\n",
            "INFO Using max model len 222222\n",
            "INFO Available KV cache memory: 3.13 GiB\n",
            "INFO GPU KV cache size: 168,000 tokens\n",
            "INFO Avg generation throughput: 16.6 tokens/s, GPU KV cache usage: 20.2%, Prefix cache hit rate: 41.4%\n",
            "INFO Mean acceptance length: 2.66, Accepted throughput: 10.30 tokens/s, Drafted throughput: 18.60 tokens/s, Accepted: 103 tokens, Drafted: 186 tokens, Per-position acceptance rate: 0.726, 0.516, 0.419, Avg Draft acceptance rate: 55.4%\n",
        ]

        tail = [
            lines[4],
            lines[5],
        ]
        metrics = parse_metrics(tail, lines)

        expected = {
            "Model len": "111111",
            "KV Cache size": "168000",
            "KV cache memory": "3.13 GiB",
            "Generation throughput": "16.6 tok/s",
            "KV cache usage": "20.2%",
            "Prefix hit rate": "41.4%",
            "Mean acceptance length": "2.66",
            "Accepted throughput": "10.30 tok/s",
            "Drafted throughput": "18.60 tok/s",
            "Accepted tokens": "103 tok",
            "Drafted tokens": "186 tok",
            "Position acceptance": "72.6%, 51.6%, 41.9%",
            "Draft acceptance": "55.4%",
        }
        self.assertEqual({key: metrics[key] for key in expected}, expected)


if __name__ == "__main__":
    unittest.main()
