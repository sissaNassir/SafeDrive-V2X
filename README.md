# Safe-V2X: SOTIF-Compliant ML Pipelines via Arg2P

This repository contains the formal logic implementation and verification traces for the research paper:  
**"Towards SOTIF-Compliant ML Pipelines: Integrating ISO 21448 Safety Constraints into the CRISP-DM Cycle"**.

## 📌 Overview

The **Safe-V2X** repository provides an operational implementation of safety-aware AutoML for Autonomous Driving (AD). By integrating **ISO 26262** (Functional Safety) and **ISO 21448** (SOTIF) constraints directly into the ML lifecycle, we bridge the gap between high-performance AutoML and safety-critical certification.

Following the principle that demonstrating a robust logical methodology for recalculating V2X constraints is more valuable for safety-critical conferences than model training alone, this project leverages **Structured Argumentation (ASPIC+)** to formally guarantee the absence of unreasonable risk in combinatorial search spaces.

## 🛠 Project Components

* **`hamlet_theory.pl`**: The core ASPIC+ theory using native **Arg2P** syntax. It defines:
    * **LiDAR Search Space**: Combinations of pre-processing filters (Statistical, Radius) and detection algorithms (PointPillars, CenterPoint).
    * **Dynamic V2X Constraints**: Specifically the `cv2x` rule, which mandates perception filters upon receiving cooperative hazard warnings.
    * **Safety Rebuttals**: Strong negation (`-`) used to defeat configurations that violate hardware latency (FuSa) or environmental robustness (SOTIF) requirements.
* **`execution_trace.txt`**: A comprehensive verification log showing the generation and resolution of **33 distinct arguments**. This serves as the "evidence of verification" for safety cases.

## 📊 Formal Verification Results

The Arg2P engine identifies the **Grounded Extension** (the set of safe, accepted pipelines) by pruning unsafe candidates:
* **V2X Adaptability**: Argument **A10** in the trace confirms that receiving a `v2x_hazard` premise successfully triggers rebuttals against non-filtered pipelines.
* **Area 2 Elimination**: Hazardous configurations (e.g., high-latency filters on embedded Jetson ECUs) are automatically moved to the `OUT` (rejected) set.
* **Real-Time Performance**: The system resolves the entire combinatorial conflict graph in **<1ms**, meeting the strict latency requirements of V2X cooperative perception.



## 🚀 Reproduction Steps

1.  **Engine**: Download the **Arg2P IDE (v0.6.1)** from the [official repository](https://github.com/tuProlog/arg2p-kt/releases).
2.  **Load**: Open `hamlet_theory.pl` in the editor.
3.  **Settings**: Set Labelling Mode to `grounded` and Ordering Principle to `last`.
4.  **Execute**: Run the query `buildLabelSets.` to see the Grounded Extension results.

## 📚 References & Credits

This work extends the logic-based AutoML methodology and utilizes the following foundational technologies:

1.  **Original HAMLET Implementation**: [QueueInc/HAMLET-DATAPLAT2022](https://github.com/QueueInc/HAMLET-DATAPLAT2022).
2.  **Arg2P Framework**: Calegari, R., Pisano, G., et al. (2022). *"Arg2P: An argumentation framework for explainable intelligent systems,"* Journal of Logic and Computation.
3.  **SOTIF Standard**: ISO 21448:2022, *"Road vehicles — Safety of the intended functionality"*.
4.  **Research Paper**: S. Zandoli, L. Foschini, *"Towards SOTIF-Compliant ML Pipelines: Integrating ISO 21448 Safety Constraints into the CRISP-DM Cycle,"* VTC 2026.

---
