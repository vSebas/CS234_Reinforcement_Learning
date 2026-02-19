# Experiment Instructions

## Setup
```bash
cd Assignment3/starter_code
```

## 1. PPO Training (Section 1)
```bash
python ppo_hopper.py --seed 1
python ppo_hopper.py --seed 2
python ppo_hopper.py --seed 3
python ppo_hopper.py --early-termination --seed 1
python ppo_hopper.py --early-termination --seed 2
python ppo_hopper.py --early-termination --seed 3

python plot.py --directory results --seeds 1,2,3 --output results/hopper.png
```
**Outputs:** `results/Hopper-v4-early-termination={True/False}-seed={seed}/`
- `model.zip`, `scores.npy`, `scores.png`, `log.txt`

## 2. RLHF Training (Section 2)
```bash
python run_rlhf.py --seed 1
python run_rlhf.py --seed 2
python run_rlhf.py --seed 3

python plot.py --rlhf-directory results_rlhf --output results_rlhf/hopper_rlhf.png --seeds 1,2,3
```
**Outputs:** `results_rlhf/Hopper-v4-rlhf-seed={seed}/`
- `model.zip`, `original_scores.npy`, `learned_scores.npy`, `original_scores.png`, `learned_scores.png`

## 3. DPO Training (Section 3)
```bash
python run_dpo.py --seed 1 --algo sft
python run_dpo.py --seed 2 --algo sft
python run_dpo.py --seed 3 --algo sft
python run_dpo.py --seed 1 --algo dpo
python run_dpo.py --seed 2 --algo dpo
python run_dpo.py --seed 3 --algo dpo

python plot.py --dpo-directory results_dpo --output results_dpo/hopper_dpo.png --seeds 1,2,3
```
**Outputs:** `results_dpo/Hopper-v4-{sft/dpo}-seed={seed}/`
- `{sft/dpo}.pt`, `scores.npy`, `scores.png`

## 4. Copy plots to LaTeX
```bash
cp results/hopper.png ../latex/img/
cp results_rlhf/hopper_rlhf.png ../latex/img/
cp results_dpo/hopper_dpo.png ../latex/img/
```
