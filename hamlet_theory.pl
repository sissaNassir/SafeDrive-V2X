% =========================================================
% 1. SEARCH SPACE (Empty brackets [] are mandatory for axioms)
% =========================================================
t1 : [] => transformation(stat). % Statistical Outlier Removal
t2 : [] => transformation(rad).  % Radius Outlier Removal
a1 : [] => algorithm(anc).       % Anchor-based (PointPillars)
a2 : [] => algorithm(cen).       % Center-based (CenterPoint)

% =========================================================
% 2. SCENARIOS (Environmental and hardware triggering conditions)
% =========================================================
p1 : [] => rain.               % SOTIF Triggering Condition
p2 : [] => jetson.             % FuSa Hardware Constraint (Embedded ECU)
p3 : [] => v2x_hazard.         % Cooperative V2X Trigger (Hazard Warning)
p4 : [] => v2x_latency_high.   % Cooperative V2X Trigger (Network Delay)

% =========================================================
% 3. GENERATION ENGINE (Combinatorial pipeline construction)
% =========================================================
% g0: Empty pipeline
g0 : algorithm(Z) => pipeline([], Z).
% g1: Multi-step pipeline (filter concatenation)
g1 : transformation(X), transformation(Y), algorithm(Z), prolog(X \== Y) => pipeline([X, Y], Z).
% g2: Single-filter pipeline
g2 : transformation(X), algorithm(Z) => pipeline([X], Z).

% =========================================================
% 4. SAFETY CONSTRAINTS (Native ASPIC+ Rebuttals)
% Instead of custom conflict rules, we use strong negation "-" 
% to conclude that a specific pipeline MUST NOT be generated.
% =========================================================

% A. Functional Safety (FuSa): Jetson forbids 'rad' due to latency (ISO 26262 Pt. 11)
c2_1 : jetson, transformation(rad), algorithm(A) => -pipeline([rad], A).
c2_2 : jetson, transformation(rad), transformation(Y), algorithm(A) => -pipeline([rad, Y], A).
c2_3 : jetson, transformation(X), transformation(rad), algorithm(A) => -pipeline([X, rad], A).

% B. SOTIF / V2X1: Rain or Hazard signal makes filtering mandatory for ANY algorithm (A)
c1 : rain, algorithm(A) => -pipeline([], A).
cv2x1 : v2x_hazard, algorithm(A) => -pipeline([], A).

% C. V2X2: High network latency dynamically forbids heavy 'rad' filter
cv2x2_1 : v2x_latency_high, transformation(rad), algorithm(A) => -pipeline([rad], A).
cv2x2_2 : v2x_latency_high, transformation(rad), transformation(Y), algorithm(A) => -pipeline([rad, Y], A).
cv2x2_3 : v2x_latency_high, transformation(X), transformation(rad), algorithm(A) => -pipeline([X, rad], A).

% D. Architectural Compatibility: 'stat' and 'cen' are mutually incompatible
c3_1 : transformation(stat), algorithm(cen) => -pipeline([stat], cen).
c3_2 : transformation(stat), transformation(Y), algorithm(cen) => -pipeline([stat, Y], cen).
c3_3 : transformation(X), transformation(stat), algorithm(cen) => -pipeline([X, stat], cen).

% =========================================================
% 5. PREFERENCES (Safety constraints defeat generation rules)
% This ensures that unsafe arguments are always labeled as OUT.
% =========================================================
sup(c2_1, g2). sup(c2_2, g1). sup(c2_3, g1).

sup(c1, g0).
sup(cv2x1, g0).

sup(cv2x2_1, g2). sup(cv2x2_2, g1). sup(cv2x2_3, g1).

sup(c3_1, g2). sup(c3_2, g1). sup(c3_3, g1).
