"""Tests for the vLLM monitor metric parser."""

from __future__ import annotations

import importlib.machinery
import importlib.util
import re
import unittest
from pathlib import Path
from typing import Iterable

SCRIPT_PATH = Path(__file__).parents[1] / "vllm-monitor"
loader = importlib.machinery.SourceFileLoader("vllm_monitor", str(SCRIPT_PATH))
spec = importlib.util.spec_from_loader(loader.name, loader)
vllm_monitor = importlib.util.module_from_spec(spec)
loader.exec_module(vllm_monitor)
parse_metrics = vllm_monitor.parse_metrics

METRIC_PATTERNS = {
    "Generation throughput": re.compile(r"Avg generation throughput:\s*([\d.]+)\s*tokens/s"),
    "KV cache usage": re.compile(r"GPU KV cache usage:\s*([\d.]+)%"),
    "KV Cache size": re.compile(r"GPU KV cache size:\s*([\d,]+)\s+tokens"),
    "KV cache memory": re.compile(r"Available KV cache memory:\s*([\d.]+\s+GiB)"),
    "Model len": re.compile(r"Using max model len\s+([\d,]+)"),
    "Prefix hit rate": re.compile(r"Prefix cache hit rate:\s*([\d.]+)%"),
    "Mean acceptance length": re.compile(r"Mean acceptance length:\s*([\d.]+)"),
    "Accepted throughput": re.compile(r"Accepted throughput:\s*([\d.]+)\s*tokens/s"),
    "Drafted throughput": re.compile(r"Drafted throughput:\s*([\d.]+)\s*tokens/s"),
    "Accepted tokens": re.compile(r"Accepted:\s*(\d+)\s*tokens"),
    "Drafted tokens": re.compile(r"Drafted:\s*(\d+)\s*tokens"),
    "Draft acceptance": re.compile(r"Avg Draft acceptance rate:\s*([\d.]+)%"),
}
POSITION_PATTERN = re.compile(r"Per-position acceptance rate:\s*([\d.,\s]+)")

def parse_metrics(lines: Iterable[str], all_lines: Iterable[str] | None = None) -> dict[str, str]:
    metrics: dict[str, str] = {}
    if all_lines is not None:
        whole_log_patterns = (
            METRIC_PATTERNS["KV Cache size"],
            METRIC_PATTERNS["KV cache memory"],
        )
        lines = [
            *lines,
            *(line for line in all_lines if any(pattern.search(line) for pattern in whole_log_patterns)),
        ]
        model_len_line = next(
            (line for line in all_lines if METRIC_PATTERNS["Model len"].search(line)),
            None,
        )
        if model_len_line:
            lines.append(model_len_line)
    for line in lines:
        for label, pattern in METRIC_PATTERNS.items():
            match = pattern.search(line)
            if match:
                value = match.group(1)
                suffix = " tokens/s" if "throughput" in label.lower() else "%" if "rate" in label.lower() or "usage" in label.lower() else ""
                value = value.replace(",", "")
                metrics[label] = f"{value}{suffix}"
        match = POSITION_PATTERN.search(line)
        if match:
            values = [float(value) * 100 for value in re.findall(r"\d+(?:\.\d+)?", match.group(1))]
            metrics["Position acceptance"] = ", ".join(f"{value:.1f}%" for value in values)
    return metrics


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
            "Generation throughput": "16.6 tokens/s",
            "KV cache usage": "20.2%",
            "Prefix hit rate": "41.4%",
            "Mean acceptance length": "2.66",
            "Accepted throughput": "10.30 tokens/s",
            "Drafted throughput": "18.60 tokens/s",
            "Accepted tokens": "103",
            "Drafted tokens": "186",
            "Position acceptance": "72.6%, 51.6%, 41.9%",
            "Draft acceptance": "55.4",
        }
        self.assertEqual({key: metrics[key] for key in expected}, expected)


if __name__ == "__main__":
    unittest.main()
