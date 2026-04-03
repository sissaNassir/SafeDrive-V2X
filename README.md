# Safe-V2X: SOTIF-Compliant ML Pipelines via Arg2P

This repository provides the formal logic implementation and verification traces for the research paper:
**"Explainable Functional Safety for Autonomous Vehicles: Integrating V2X and SOTIF Constraints"** (VTC 2026).

## 📌 Overview

The **Safe-V2X** repository implements an operational methodology for safety-aware AutoML in Autonomous Driving (AD). By integrating **ISO 26262** (Functional Safety) and **ISO 21448** (SOTIF) constraints directly into the ML lifecycle, we bridge the gap between performance-driven AutoML and safety-critical certification.

Rather than relying purely on end-to-end model training, this project emphasizes the value of a deterministic, logical methodology. We leverage **Structured Argumentation (ASPIC+)** to dynamically evaluate V2X constraints, formally guaranteeing the absence of unreasonable risk in combinatorial search spaces under stringent real-time conditions.

## 🛠 Project Components

* `hamlet_theory.pl`: The core ASPIC+ theory using native **Arg2P** syntax. It defines:
    * **LiDAR Search Space:** Combinatorial generation of pre-processing filters and 3D detection architectures.
    * **Dynamic V2X Constraints:** Rules mapping environmental conditions (e.g., rain, V2X hazard warnings, network latency) to abstract safety requirements (`mandatory_filter`, `invalid_rad`).
    * **Meta-Logical Conflict Rules:** Explainable safety rules (using `conflict/2` mappings) that automatically prune configurations violating hardware latency (FuSa) or robustness (SOTIF) requirements, replacing opaque strong negation with bidirectional traceability.
* `execution_trace.txt`: A comprehensive verification log showing the generation and resolution of **47 distinct arguments**. This serves as the direct "evidence of verification" required by ISO 21448 Clause 10.

## 📊 Formal Verification Results

The Arg2P engine identifies the **Grounded Extension** (the set of safe, certifiable pipelines) dynamically:

* **Combinatorial Pruning:** The system collapses 47 potential arguments into a single safe state (`[pipeline([stat], anc)]`), formally proving the rejection of all unsafe configurations.
* **Area 2 Elimination:** Known hazardous configurations (e.g., using an empty pipeline under rain, or heavy filters on embedded Jetson ECUs during high latency) are explicitly attacked and labeled as **OUT**.
* **Performance:** The logical engine filters the combinatorial search space and recalculates constraints in **0.20 ms**, strictly satisfying the real-time V2X cooperative perception limits.

## 🚀 Reproduction Steps

1.  **Software:** Download the [Arg2P IDE (v0.6.1)](https://github.com/tuprolog/arg2p-kt/releases) from the official releases page. (Requires Java 11+).
2.  **Load Theory:** Open `hamlet_theory.pl` in the Arg2P editor.
3.  **Settings:**
    * Set **Labelling Mode** to `grounded`.
    * Set **Ordering Principle** to `last`.
4.  **Execute:** Run the query `buildLabelSets.` to compute the safe search space and view the argumentation graph.

## 📚 References & Credits

This work builds upon the foundational research of logic-based AutoML and structured argumentation:

* **Proposed Methodology:** Silvia Zandoli, Luca Foschini, *"Explainable Functional Safety for Autonomous Vehicles: Integrating V2X and SOTIF Constraints"* (submitted at VTC 2026).
* **Original HAMLET Framework:** [QueueInc/HAMLET-DATAPLAT2022](https://github.com/QueueInc/HAMLET-DATAPLAT2022) (Foundational implementation for Human-centric AutoML via Logic and Argumentation).
* **Arg2P Technology:** Calegari, R., Pisano, G., et al. (2021). *"Arg2P: An argumentation framework for explainable intelligent systems,"* Journal of Logic and Computation.
* **SOTIF Standard:** ISO 21448:2022, *"Road vehicles — Safety of the intended functionality"*.
