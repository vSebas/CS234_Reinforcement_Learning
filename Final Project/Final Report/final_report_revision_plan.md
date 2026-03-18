# Final Report Revision Plan

## Revision strategy

Do **two passes**:

1. **Submission triage**
   - Fix every broken citation / table / reference marker.
   - Ensure all tables and figures are referenced correctly.
   - Make the bibliography compile cleanly.
   - Verify author/contribution formatting.

2. **Narrative rewrite**
   - Reframe the paper around one clean story:
     - **Question:** can an offline DT improve downstream trajectory optimization through warm-starting?
     - **Finding:** better offline imitation did **not** yield solver-facing gains.
     - **Diagnosis:** the likely bottleneck is early lateral branch selection, not generic model instability.

That story is already present in your report, especially in the abstract, introduction, results, and discussion. It just needs to be made dominant.

---

# 1. Title

## Current state
The title is technically accurate:

> *Decision Transformer Warm-Starts for Minimum-Time Vehicle Trajectory Optimization with Obstacle Avoidance*

## Keep or change?
**Keep it**, unless you want something slightly sharper.

## Better alternatives
- **Decision Transformer Warm-Starts for Minimum-Time Vehicle Trajectory Optimization**
- **Evaluating Decision Transformer Warm-Starts for Nonlinear Vehicle Trajectory Optimization**
- **When Offline Sequence Modeling Does Not Improve Warm-Started Trajectory Optimization**

The third is stronger, but more “negative result” styled.

---

# 2. Author block and compliance block

## Current state
This is mostly fine. You list name, affiliation, email, and note enrollment status. The author contributions / code availability section also exists.

## Fixes
- Keep this.
- Just make sure the footnote about CS234 enrollment is exactly what the instructors want.
- If there were any mentor/research-advisor contributions beyond normal discussion, mention them only if the course policy requires it.

## Priority
**Low**, unless policy wording needs adjustment.

---

# 3. Abstract

## Current state
The abstract is actually one of the better parts. It is clear, honest, and already states the main result: offline improvement did not translate into solver-facing benefit.

## What to improve
The abstract is good, but it can be made **slightly more paper-like** and less implementation-log flavored.

### What to cut
- Long inventory phrases like “repair-data pipelines” and “benchmark scripts with acceptance gating and rollout diagnostics” can be shortened.

### What to emphasize
- problem,
- hypothesis,
- evaluation criterion,
- main empirical finding,
- diagnosis / implication.

## Suggested structure
1. One sentence on the problem.
2. One sentence on the method.
3. One sentence on how you evaluate it.
4. One sentence on the result.
5. One sentence on what was learned.

## Example direction
You want it to read more like:

> We study whether a Decision Transformer can generate warm-start trajectories that reduce solve time or iterations for nonlinear minimum-time vehicle trajectory optimization with obstacle avoidance. We train offline on solver-generated trajectories and evaluate downstream utility using acceptance, iterations, solve time, and total time rather than imitation loss alone. Although larger-context modeling and targeted repair fine-tuning substantially improve offline validation loss, these gains do not yield a clear end-to-end advantage under corrected deployment evaluations. The strongest evidence suggests that the remaining failure mode is early lateral branch selection under rollout. These results show that in this setting, offline sequence-model accuracy is not a reliable proxy for warm-start utility.

## Priority
**Medium-high**

---

# 4. Introduction

## Current state
This is one of the main places to rewrite.

The introduction has the right ingredients:
- practical question,
- downstream objective is solver benefit, not just imitation,
- setup is narrow and controlled,
- result is negative but informative.

But it also has the report’s main weaknesses:
- broken citation `(??)`, which is a major polish issue,
- narrow/internal framing,
- too much operational detail too early,
- not enough motivation for why a CS234 audience should care.

## What to change

### Current intro problem
It goes quickly from:
- “Can DT help warm-start trajectory optimization?”
to
- very specific repo/evaluation details.

That detail is useful, but it arrives too early.

### What the intro should do instead
Use this 4-paragraph structure:

#### Paragraph 1 — Broader motivation
Why warm-starting optimization with learned models is attractive:
- trajectory optimization is expensive,
- learned priors may help,
- but deployment in constrained systems is hard.

#### Paragraph 2 — Your specific problem
State:
- minimum-time raceline / vehicle trajectory optimization,
- obstacle avoidance,
- DT warm-start,
- downstream criterion is reduced solver work, not just imitation.

#### Paragraph 3 — Your experimental contribution
Briefly say what you built:
- direct-collocation optimizer,
- DT rollout policy,
- repair/failure-conditioned fine-tuning,
- deployment benchmark with acceptance gating.

#### Paragraph 4 — Main finding
State the conclusion cleanly:
- offline improved,
- downstream did not,
- likely failure mode is early lateral branch choice.

## What to remove from the intro
Move these details later:
- exact start-state assumptions,
- exact gate definitions,
- IPOPT/FATROP practical split,
- shard names and training run naming.

Those belong in setup / method / evaluation.

## Add a contributions paragraph
Your intro needs a crisp end-of-introduction contributions block such as:

> This project makes three contributions. First, it implements an end-to-end DT warm-start pipeline for nonlinear minimum-time vehicle trajectory optimization with obstacle avoidance. Second, it develops targeted repair-data interventions, including post-projection and failure-conditioned fine-tuning, to address rollout-induced errors. Third, it shows through corrected deployment evaluations that improved offline modeling does not automatically translate into reduced solver work, and identifies early lateral branch selection as the dominant remaining bottleneck.

That would immediately improve the paper.

## Priority
**Very high**

---

# 5. Background / Related Work

## Current state
This is one of the weakest sections. It is too short, and it still contains broken references. The bibliography is also thin for a project like this.

## What this section needs to do
Right now it likely reads like “here are a few papers I know.”
It needs to read like “here is the literature space, and here is exactly where this report sits.”

## Recommended subsection structure

### 2.1 Sequence modeling / Decision Transformer
Discuss DT as offline sequence modeling for control, with Chen et al. as the anchor.

### 2.2 Learning-based warm-starting for trajectory optimization
This is where your ART references become useful. The uploaded trajectory-transformer papers repeatedly frame warm-starting as a way to combine learned priors with constraint-enforcing downstream optimization.

### 2.3 Trajectory optimization for autonomous vehicles / racing
Use the vehicle optimization papers you already cite to explain why high-quality initializations matter in nonlinear racing problems.

### 2.4 Your position
Clarify:
- unlike pure policy learning, you still rely on an optimizer,
- unlike prior positive warm-start papers, your result is a controlled negative result,
- your contribution is not “best performance,” but a careful end-to-end evaluation showing the gap between offline loss and deployment utility.

## Important stylistic change
Do **not** write related work as a bibliography dump.
Write it around contrasts:

- **pure learned control** vs **learned warm-start + optimizer**,
- **offline accuracy** vs **deployment utility**,
- **spacecraft warm-start papers with positive results** vs **your vehicle setting with a negative result**.

## Good source language to emulate
The uploaded ART papers do this well: they explain why learning-based warm-starting is appealing, then position their method relative to pure learning and optimization-only baselines.

## Priority
**Very high**

---

# 6. Problem Setup

## Current state
This section is necessary, but it should be made cleaner and more conceptual.

The report already states the fixed start assumptions, Oval-track focus, and obstacle/no-obstacle benchmark families.

## What to improve
The key risk here is overloading the reader with implementation specifics before they understand the actual OCP.

## What should be in this section
- state what is optimized,
- what the vehicle model roughly is,
- what constraints matter,
- what “warm-start” means in your pipeline,
- what benchmark family is used.

## Add one equation block if missing
Even if concise, this section should have a compact optimization statement:
- minimize time / objective,
- subject to dynamics,
- control/state bounds,
- obstacle avoidance.

This will make the report feel more like a proper technical paper and less like a lab note.

## Priority
**High**

---

# 7. Method / Approach

## Current state
This section likely contains the right technical content, but the report currently spreads the method over multiple later sections:
- method,
- data pipeline,
- evaluation protocol,
- debugging/diagnosis.

## Main rewrite goal
Make the method section answer one clean question:

> What exactly is the proposed warm-start pipeline?

## Recommended internal structure

### 4.1 Baseline optimizer
Brief description of direct collocation + downstream NLP solver.

### 4.2 DT warm-start model
Explain:
- input representation,
- autoregressive rollout,
- return-conditioning or objective-conditioning if used,
- what trajectory tokens are predicted.

### 4.3 Acceptance gate / projection / fallback
This is important, but write it conceptually:
- unsafe or poor-quality rollouts are rejected,
- optional projection is applied,
- solver then refines the warm-start.

Do not drown this section in metric names yet.

### 4.4 Repair-data interventions
This is one of the more novel parts of your report and should be framed more confidently:
- shift shard,
- hard-repair,
- post-projection repair,
- failure-conditioned repair.

Explain the logic:
- nominal data teaches the base distribution,
- repair shards target rollout-induced off-manifold states,
- failure-conditioned repairs target specific deployment bottlenecks.

That is actually a strong story.

## What to cut
Do not narrate the full project chronology here.
Only describe the final method and the major interventions you want the reader to understand.

## Priority
**Very high**

---

# 8. Data and Training Pipeline

## Current state
This section has useful information, including shard sizes and the logic behind failure-conditioned repairs. It also contains a broken “Table ??” reference.

## What to keep
Keep:
- final active dataset regime,
- shard counts,
- training run progression,
- failure-conditioned data logic.

## What to improve

### Convert process into a compact table
You should absolutely have a clean table with columns like:

| Run | Data used | Purpose | Val loss | Best deployment note |
|---|---|---:|---:|---|
| Parent large-context | shift | nominal base model | ... | baseline for later FT |
| Lateral-weighted FT | shift + repair | emphasize lateral stability | ... | modest/no deployment gain |
| Post-projection FT | shift + projection repair | adapt to wrapper corrections | ... | best pre-failure-conditioned deployment |
| Failure-conditioned FT | shift + targeted failure repair | attack early lateral failure | ... | best offline, no clear downstream win |

This would dramatically improve readability.

### Explicitly state the main lesson
The report already states it, but it should be more prominent:

- offline validation improved steadily,
- deployment quality did not track it reliably.

## Priority
**High**

---

# 9. Evaluation Protocol

## Current state
Conceptually strong. You separate offline and deployment metrics, and you describe benchmark scope and caveats. This is good.

## What to improve
This section needs to become **cleaner and more authoritative**.

### Keep
- solver success rate,
- iterations,
- solve time,
- total DT time,
- acceptance rate,
- fallback count,
- projection metrics.

### Improve
Group metrics into 3 classes:

#### Deployment utility
- solve time,
- total time,
- iterations.

#### Feasibility / acceptance
- success rate,
- warm-start acceptance,
- fallback rate.

#### Diagnostic quality
- projection fraction,
- projection magnitude,
- max-step magnitude.

That grouping will help a lot.

### Caveats section
The caveats are valuable and honest:
- repeated-start confound,
- lap-time field mismatch,
- acceptance depends on rejection gate.

Keep them, but shorten the prose slightly and make them look like a formal validity paragraph rather than project notes.

## Priority
**Medium-high**

---

# 10. Results

## Current state
This is the most important section, and it has solid substance. The core results are already there:
- best offline model was failure-conditioned FT,
- offline ranking did not match deployment ranking,
- no DT variant clearly beat baseline once inference time is included,
- corrected relaxed-gate diagnostics showed some acceptance but no solver work reduction.

## Main rewrite goal
Turn this into a **results section organized by claims**, not chronology.

## Recommended structure

### 7.1 Claim 1: Offline modeling improved substantially
Use the validation losses and training summary.

### 7.2 Claim 2: Offline gains did not translate into downstream solver benefit
Use the projection ablation and total-time numbers.

### 7.3 Claim 3: Relaxing the gate increased acceptance but still did not reduce solver work
Use corrected relaxed-gate results.

### 7.4 Claim 4: The dominant remaining failure mode is early lateral branch selection
Bridge to discussion/diagnosis.

## Add one summary figure/table
You need one compact “main results” table. A reader should be able to see in one glance:

| Model | Offline val loss | Default-gate acceptance | Iteration change | Solve-time change | Total-time change | Main note |
|---|---:|---:|---:|---:|---:|---|

That would do more work than a lot of current prose.

## What to remove
Reduce overly detailed run-by-run procedural narration unless it supports a key claim.

## Priority
**Very high**

---

# 11. Debugging and Diagnosis

## Current state
This is probably the report’s strongest distinctive content. The discussion around repeated `e_clip`, early lateral instability, and wrong-side / too-aggressive rollout behavior is the part that makes the report interesting instead of merely disappointing.

## How to use it better
Right now, this material should be used more strategically.

## Recommended move
Keep diagnosis as a separate section, but make it shorter and more decisive.

### Suggested structure
- **What confounds were removed**
- **What remained after fixing them**
- **What the final evidence points to**

### Strong final sentence for that section
Something like:

> After removing major evaluation confounds, the evidence no longer supports the view that warm-start failure is caused primarily by strict thresholds or generic instability. Instead, the dominant remaining failure mode is early lateral branch selection: the model often commits too early to the wrong side or too aggressively in magnitude, after which clipping and validation reject the rollout.

That is much stronger than a chronological debugging narrative.

## Priority
**High**

---

# 12. Discussion

## Current state
Good content. It already says:
- offline loss can improve without warm-start utility improving,
- the bottleneck is specific,
- accepted relaxed-gate rollouts can still be solver-harmful.

## What to improve
Make discussion less repetitive with conclusion.

## Recommended structure
Use the discussion for interpretation:
- what the result says about offline imitation metrics,
- what it says about wrapper acceptance,
- why the failure-conditioned intervention still matters despite no final win.

Do **not** repeat the full metric summary again.

## Priority
**Medium**

---

# 13. Limitations

## Current state
Good and credible. You explicitly mention:
- small smoke benchmarks,
- IPOPT-heavy diagnostics,
- hand-designed acceptance thresholds,
- lap-time field interpretation,
- small final failure-conditioned shard.

## What to improve
Only stylistic tightening.

### Good move
Convert the bullet list into shorter prose or keep bullets but make them parallel and concise.

### Add one final sentence
Something like:

> These limitations weaken the strength of any positive claim, but they do not undermine the central negative result: across corrected evaluations, offline gains did not produce a convincing solver-facing advantage.

## Priority
**Low-medium**

---

# 14. Conclusion

## Current state
Reasonable, but it can be sharper. It already restates:
- the pipeline was implemented,
- bugs/confounds were fixed,
- offline improved,
- downstream did not,
- likely bottleneck is early lateral behavior.

## What to change
Make it shorter and more memorable.

### Current issue
It reads a bit like a project closeout summary.

### Better conclusion pattern
Use 3 concise paragraphs:

1. **What you did**
2. **What you found**
3. **What future work should target**

### Stronger final line
End on the scientific lesson, not only the project state:

> In this setting, deployment metrics were more informative than offline imitation loss, and future progress will likely require targeting early lateral decision quality rather than further improving average sequence prediction alone.

## Priority
**High**

---

# 15. Figures and tables

## Current state
You have at least:
- a representative optimizer trajectory figure,
- a training loss figure,
- tables for results,
but some table references are broken.

## What to do
You need fewer but stronger visuals.

## Recommended final set
- **Figure 1:** system/pipeline diagram  
  DT rollout → projection/gate → optimizer → metrics.
- **Figure 2:** training / validation loss progression across runs.
- **Table 1:** training runs and datasets.
- **Table 2:** main deployment comparison.
- **Optional Figure 3:** one qualitative accepted vs rejected lateral rollout example.

## Most important figure missing
A simple pipeline schematic would help a lot. Right now the reader has to reconstruct the flow from text.

## Priority
**High**

---

# 16. References

## Current state
The references section is currently too small for the paper’s scope, and some citation integration is broken.

## Must-fix items
- Fix all unresolved citations:
  - `(??)`
  - `(¨ ?)`
  - `Table ??`
- Ensure Wachter & Biegler compiles correctly in text.
- Expand the bibliography.

## Add more references in these buckets
- Decision Transformer / offline sequence modeling.
- Warm-starting trajectory optimization with transformers.
- Vehicle trajectory optimization / racing optimization.
- Possibly one or two model-based imitation / planning references if relevant.

The ART-style papers you uploaded are useful models for how to frame warm-starting claims and contributions, even though they are in spacecraft settings.

## Priority
**Very high**

---

# 17. What to cut

These are the first things I would compress:

- Excessive run-name detail in the main prose.
- Too much chronology about what happened over the quarter.
- Repetition of “offline improved but deployment did not” in too many sections.
- Detailed gate/projection metric jargon before the reader understands the setup.

---

# 18. What to add

These are the highest-value additions:

### Add 1: Contributions paragraph at end of intro
This is missing in a strong form.

### Add 2: Main results summary table
This is probably the single most useful addition.

### Add 3: One-sentence thesis at start of results
Something like:

> The central empirical result is that offline sequence-model improvements did not yield a measurable solver-facing benefit under corrected deployment evaluation.

### Add 4: One schematic of the pipeline
This would make the report much easier to follow.

---

# 19. Priority order for rewriting

If time is limited, do it in this order:

## Tier 1 — mandatory
1. Fix all broken references and placeholders.
2. Rewrite the introduction.
3. Rewrite related work.
4. Create one strong main-results table.
5. Tighten the conclusion.

## Tier 2 — strong improvement
6. Reorganize results around claims rather than chronology.
7. Compress diagnosis into a clearer “final bottleneck” section.
8. Add a contributions paragraph.
9. Add a pipeline figure.

## Tier 3 — polish
10. Tighten discussion and limitations.
11. Smooth jargon and naming.
12. Check caption quality and section transitions.

---

# 20. Recommended final narrative

This is the exact paper story I would force every section to support:

> We evaluate whether a Decision Transformer trained offline on solver-generated trajectories can provide useful warm-starts for nonlinear minimum-time vehicle trajectory optimization with obstacle avoidance. We build an end-to-end pipeline with autoregressive rollout, projection/gating, repair-data fine-tuning, and downstream benchmarking. Although larger-context training and targeted repair-data interventions substantially improve offline validation loss, these improvements do not translate into reduced solver iterations or total runtime under corrected deployment evaluation. The final evidence suggests that the dominant remaining failure mode is early lateral branch selection, showing that offline sequence accuracy is an unreliable proxy for solver-facing utility in this setting.

That is a solid final report story.
