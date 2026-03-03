% =========================================================
% 1. TRANSFORMATIONS AND ALGORITHMS
% =========================================================
t1 : [] => transformation(stat). % Statistical Outlier Removal
t2 : [] => transformation(rad). % Radius Outlier Removal
t3 : [] => transformation(none). % No filter baseline

a1 : [] => algorithm(anc). % Anchor-based (PointPillars)
a2 : [] => algorithm(cen). % Center-based (CenterPoint)

% =========================================================
% 2. TRIGGERING CONDITIONS (ODD & Hardware)
% =========================================================
p1 : [] => rain.
p2 : [] => jetson.
p3 : [] => v2x_hazard.
p4 : [] => v2x_latency_high.

% =========================================================
% 3. PIPELINE GENERATION
% =========================================================
g0 : algorithm(A) => pipeline([], A).

g1 : transformation(T), algorithm(A) => pipeline([T], A).

% NOTE THE == OPERATOR HERE:
g2 : transformation(T1), transformation(T2), T1 == T2, algorithm(A) => pipeline([T1,T2], A).

% =========================================================
% 4. SAFETY CONSTRAINTS (Abstract Requirements)
% =========================================================
c1 : rain => mandatory_filter.
cv1 : v2x_hazard => mandatory_filter.

c2 : jetson => invalid_rad.
cv2 : v2x_latency_high => invalid_rad.

c3 : [] => invalid_stat_cen.

% =========================================================
% 5. CONFLICT RULES (Explainable Mappings)
% =========================================================
% Mandatory filter
conflict([mandatory_filter], [pipeline([], A)]).
conflict([mandatory_filter], [pipeline([none], A)]).

% Invalid rad (single and in combination)
conflict([invalid_rad], [pipeline([rad], A)]).
conflict([invalid_rad], [pipeline([T, rad], A)]).
conflict([invalid_rad], [pipeline([rad, T], A)]).

% Invalid stat + cen (single and in combination)
conflict([invalid_stat_cen], [pipeline([stat], cen)]).
conflict([invalid_stat_cen], [pipeline([T, stat], cen)]).
conflict([invalid_stat_cen], [pipeline([stat, T], cen)]).

% =========================================================
% 6. PREFERENCES
% =========================================================
sup(c1, g0). sup(cv1, g0).
sup(c2, g1). sup(cv2, g1).
sup(c2, g2). sup(cv2, g2).
sup(c3, g1). sup(c3, g2).
