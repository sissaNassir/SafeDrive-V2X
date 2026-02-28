# Safe-V2X: SOTIF-Compliant ML Pipelines via Arg2P

This repository provides the formal logic implementation and verification traces for the research paper:  
**"Explainable Functional Safety for Autonomous Driving: Integrating V2X and SOTIF Constraints into the CRISP-DM Cycle"**.

## 📌 Overview

The **Safe-V2X** repository implements an operational methodology for safety-aware AutoML in Autonomous Driving (AD). By integrating **ISO 26262** (Functional Safety) and **ISO 21448** (SOTIF) constraints directly into the ML lifecycle, we bridge the gap between performance-driven AutoML and safety-critical certification.

Following the principle that demonstrating a robust logical methodology for ricalculating V2X constraints is more valuable for safety-critical conferences than model training alone, this project leverages **Structured Argumentation (ASPIC+)** to formally guarantee the absence of unreasonable risk in combinatorial search spaces.

## 🛠 Project Components

* **`hamlet_theory.pl`**: The core ASPIC+ theory using native **Arg2P** syntax. It defines:
    * **LiDAR Search Space**: Combinatorial combinations of pre-processing filters and detection algorithms.
    * **Dynamic V2X Constraints**: Specifically the `cv2x` rule, which mandates perception filters upon receiving cooperative hazard warnings.
    * **Safety Rebuttals**: Logic-based rebuttals (using strong negation `-`) that automatically prune configurations violating hardware latency (FuSa) or robustness (SOTIF) requirements.
* **`execution_trace.txt`**: A comprehensive verification log showing the generation and resolution of **33 distinct arguments**. This serves as the "evidence of verification" required by ISO 21448 Clause 10.

## 📊 Formal Verification Results

The Arg2P engine identifies the **Grounded Extension** (the set of safe, accepted pipelines) in real-time:
* **V2X Adaptability**: Argument **A10** in the trace confirms that receiving a `v2x_hazard` premise successfully triggers rebuttals against non-filtered pipelines.
* **Area 2 Elimination**: Hazardous configurations (e.g., high-latency filters on embedded Jetson ECUs) are formally identified as `OUT` (rejected).
* **Performance**: The system resolves the entire conflict graph in **<1ms**, meeting the strict latency requirements for real-time V2X cooperative perception.



## 🚀 Reproduction Steps

1.  **Software**: Download the **Arg2P IDE (v0.6.1)** from the official [releases page](https://github.com/tuProlog/arg2p-kt/releases). Requires Java 11+.
2.  **Load Theory**: Open `hamlet_theory.pl` in the Arg2P editor.
3.  **Settings**: 
    * Set **Labelling Mode** to `grounded`.
    * Set **Ordering Principle** to `last`.
4.  **Execute**: Run the query `buildLabelSets.` to compute the safe search space.

## 📚 References & Credits

This work builds upon the foundational research of logic-based AutoML and structured argumentation:

1.  **Original HAMLET Framework**: [QueueInc/HAMLET-DATAPLAT2022](https://github.com/QueueInc/HAMLET-DATAPLAT2022) (Foundational implementation for Human-centric AutoML via Logic and Argumentation).
2.  **Arg2P Technology**: Calegari, R., Pisano, G., et al. (2022). *"Arg2P: An argumentation framework for explainable intelligent systems,"* Journal of Logic and Computation.
3.  **SOTIF Standard**: ISO 21448:2022, *"Road vehicles — Safety of the intended functionality"*.
4.  **Proposed Methodology**: Silvia Zandoli, Luca Foschini, *"Explainable Functional Safety for Autonomous Driving: Integrating V2X and SOTIF Constraints into the CRISP-DM Cycle"* VTC 2026.

---
