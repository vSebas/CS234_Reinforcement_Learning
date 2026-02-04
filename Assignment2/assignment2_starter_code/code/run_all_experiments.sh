#!/bin/bash

cd /home/saveasmtz/Documents/CS234/Assignment2/assignment2_starter_code/code

# Cartpole experiments (seeds 1, 2, 3)
for seed in 1 2 3; do
    echo "Running cartpole seed $seed no-baseline..."
    python3 main.py --env-name cartpole --seed $seed --no-baseline

    echo "Running cartpole seed $seed baseline..."
    python3 main.py --env-name cartpole --seed $seed --baseline

    echo "Running cartpole seed $seed ppo..."
    python3 main.py --env-name cartpole --seed $seed --ppo
done

# Pendulum experiments (seeds 1, 2, 3)
for seed in 1 2 3; do
    echo "Running pendulum seed $seed no-baseline..."
    python3 main.py --env-name pendulum --seed $seed --no-baseline

    echo "Running pendulum seed $seed baseline..."
    python3 main.py --env-name pendulum --seed $seed --baseline

    echo "Running pendulum seed $seed ppo..."
    python3 main.py --env-name pendulum --seed $seed --ppo
done

# Cheetah experiments (seed 1 only)
echo "Running cheetah seed 1 no-baseline..."
python3 main.py --env-name cheetah --seed 1 --no-baseline

echo "Running cheetah seed 1 baseline..."
python3 main.py --env-name cheetah --seed 1 --baseline

echo "Running cheetah seed 1 ppo..."
python3 main.py --env-name cheetah --seed 1 --ppo

echo "All experiments completed!"
