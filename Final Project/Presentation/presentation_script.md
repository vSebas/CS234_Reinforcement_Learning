# Final Video Script

This is the single script to use for the project video. It follows the current presentation deck in `Presentation/main.tex` and is written for a short spoken walkthrough.

## Title

Hi, I'm Sebastian Martinez, and this project is about using a Decision Transformer to generate a warm-start for minimum-time vehicle trajectory optimization.

I'll go through the planning problem, the optimization and learning setup, the experimental pipeline, and then the main results and what we learned from them.

## Problem

The planning problem here is minimum lap-time racing line optimization with static obstacle avoidance.

This is difficult because the vehicle is operating near the tire friction limits, and solver performance depends strongly on initialization quality. A poor initial guess can increase solve time, change the local optimum found, or make the solve much less reliable.

The project asks whether a learned warm start can reduce that solver work without removing the planner from the loop.

## Background

The planner is a minimum-time nonlinear program written in Frenet, or arc-length, coordinates, which describe the vehicle relative to the track centerline.

It uses spatial direct collocation, so the trajectory is optimized as a sequence of points along the track while enforcing the dynamics between neighboring points. In implementation, the nonlinear program is built in CasADi and solved with FATROP.

The dynamics model is a nonlinear single-track vehicle model configured to the 2018 and 2019 VW Golf GTI test vehicle used in earlier Stanford autonomous-racing work.

Overall, the planner minimizes lap time plus a small smoothness term while enforcing vehicle dynamics, track limits, forward progress, and obstacle-clearance constraints.

On the learning side, the project treats warm-start prediction as an offline reinforcement learning problem through sequence modeling: instead of learning online by trial and error, the DT is trained on optimizer-generated trajectories and conditioned on return-to-go, state, and action history.

## Methods

The learning part of the pipeline shown is a Decision Transformer trained on accepted planner trajectories. At test time, the DT predicts a candidate warm start for the same downstream planner.

The model input is return-to-go together with local state, track, and obstacle context. Return-to-go here is built from negative time increments, so larger return corresponds to less remaining lap time.

The model predicts warm-start controls and the corresponding rollout. The main improved model used context length 50, 6 transformer layers, 4 attention heads, and embedding size 192.

The loss function for the model uses action imitation plus an auxiliary next-state loss, and inference is autoregressive with a dynamics rollout in the loop.

## Experiments

The benchmark is narrowed to the Oval track with two scenario families: a no-obstacle evaluation set and a 1-to-4 obstacle evaluation set. The Oval track is a good fit here because it is the same style of benchmark used in the earlier Stanford GTI trajectory-optimization work, so it keeps the experiments close to the vehicle and track setting that motivates the project.

The downstream solver is FATROP for expert generation, repair segments, and the warm-started optimization problem.

The dataset includes several sources. The largest source is shift episodes, which are accepted full-lap solutions circularly shifted along the track. There are also hard-repair segments, post-projection repairs, and failure-conditioned repairs that target rollout states that are harder for the model.

The current FATROP-clean Oval dataset contains 31,710 shift episodes, 400 hard repairs, 1,000 post-projection repairs, and 300 failure-conditioned repairs.

The figure on the right shows a representative obstacle case comparing the baseline solution, the raw DT warm-start, and the final optimized trajectory.

## Trajectory Animation

This slide points to one of the optimizer trajectory animations used during debugging.

The purpose here is qualitative. It shows the kind of full-lap obstacle-aware motion the planner is solving for, and it helped verify that the solver outputs and the visualized motion were consistent.

For the video itself, the static preview is enough, and the full GIF can be opened separately if needed.

## Results and Interpretation

The most useful way to understand the results is as an incremental process rather than as a single final number.

The project started from a parent DT trained on nominal Oval trajectories and then improved the warm-start pipeline through targeted training and debugging steps. In later runs, the raw DT trajectories became more structured, handled obstacles more plausibly, and in some cases slightly reduced solver-only time.

That means the DT did learn useful trajectory structure. The remaining challenge was consistency: those raw trajectories were still not reliable enough to produce a robust end-to-end speedup.

Three changes mattered most:
- larger-context DT training improved nominal trajectory quality,
- repair datasets exposed the model to harder rollout states,
- rollout and evaluation fixes made the downstream behavior much easier to interpret.

The training curves support that story. Later fine-tuning runs were stable under the larger-context setup, and the later models produced more interpretable and more structured rollout behavior.

For the clearest corrected setting, the no-obstacle evaluation set reached 20 percent warm-start acceptance, with baseline solve time around 49 seconds and DT total time around 52 seconds. On the 1-to-4 obstacle evaluation set, acceptance was also 20 percent, with baseline solve time around 56 seconds and DT total time around 61 seconds.

So the model was generating real warm-start trajectories in both cases, but the total performance still left room for improvement. Across stricter evaluation settings, the same pattern remained: plausible raw DT trajectories, occasional solver-only benefit, but not yet reliable end-to-end gains.

A major project outcome was narrowing the remaining bottleneck enough that it became a concrete engineering target instead of an unexplained mismatch.

## Conclusions and Next Steps

To conclude, the project built a full experimental framework for learned warm-starts in constrained racing trajectory optimization. That includes expert generation, DT training, repair-data production, rollout diagnostics, and downstream benchmarking.

The overall outcome is encouraging. The DT learned meaningful trajectory structure and produced real warm-start signal. Just as importantly, the project showed that model selection in this setting has to be driven by deployment metrics like acceptance, iterations, and total time, not training loss alone.

The next step is focused: continue training on the difficult rollout states identified by the diagnostics so that promising raw DT trajectory quality becomes more consistently useful to the planner.

## References

The references are the vehicle-modeling paper from Subosits and Gerdes, the original Decision Transformer paper, and the ART warm-start paper that motivated the approach.
