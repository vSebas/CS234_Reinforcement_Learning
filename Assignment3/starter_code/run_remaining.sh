#!/bin/bash

set -e  # Exit on error

echo "=== Starting remaining experiments ==="

# RLHF (remaining)
echo ">>> Running RLHF seed 2"
python run_rlhf.py --seed 2

echo ">>> Running RLHF seed 3"
python run_rlhf.py --seed 3

# SFT
echo ">>> Running SFT seed 1"
python run_dpo.py --algo sft --seed 1

echo ">>> Running SFT seed 2"
python run_dpo.py --algo sft --seed 2

echo ">>> Running SFT seed 3"
python run_dpo.py --algo sft --seed 3

# DPO
echo ">>> Running DPO seed 1"
python run_dpo.py --algo dpo --seed 1

echo ">>> Running DPO seed 2"
python run_dpo.py --algo dpo --seed 2

echo ">>> Running DPO seed 3"
python run_dpo.py --algo dpo --seed 3

# Generate plots
echo "=== Generating plots ==="
python plot.py --rlhf-directory results_rlhf --output results_rlhf/hopper_rlhf.png --seeds 1,2,3
python plot.py --dpo-directory results_dpo --output results_dpo/hopper_dpo.png --seeds 1,2,3

# Copy to latex folder
echo "=== Copying plots to latex/img ==="
cp results_rlhf/hopper_rlhf.png ../latex/img/
cp results_dpo/hopper_dpo.png ../latex/img/

echo "=== All done! ==="
