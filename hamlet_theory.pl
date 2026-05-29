% =========================================================
% 1. TRANSFORMATIONS AND ALGORITHMS
% =========================================================
t1 : [] => transformation(stat).
t2 : [] => transformation(rad).
t3 : [] => transformation(none).

a1 : [] => algorithm(anc).
a2 : [] => algorithm(cen).

% =========================================================
% 2. TRIGGERING CONDITIONS
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

g2 : transformation(T1), transformation(T2),
     prolog(T1 \== T2), algorithm(A) => pipeline([T1,T2], A).

% =========================================================
% 4. CONSTRAINTS
% =========================================================
c1  : rain       => mandatory_filter.
cv1 : v2x_hazard => mandatory_filter.

c2  : jetson           => invalid_rad.
cv2 : v2x_latency_high => invalid_rad.

c3  : [] => invalid_stat_cen.

cv3 : v2x_hazard => override_c3.

% =========================================================
% 5. CONFLICT RULES
% =========================================================
conflict([mandatory_filter], [pipeline([], A)]).
conflict([mandatory_filter], [pipeline([none], A)]).
conflict([mandatory_filter], [pipeline([none, T], A)]).
conflict([mandatory_filter], [pipeline([T, none], A)]).

conflict([invalid_rad], [pipeline([rad], A)]).
conflict([invalid_rad], [pipeline([T, rad], A)]).
conflict([invalid_rad], [pipeline([rad, T], A)]).

conflict([invalid_stat_cen], [pipeline([stat], cen)]).
conflict([invalid_stat_cen], [pipeline([T, stat], cen)]).
conflict([invalid_stat_cen], [pipeline([stat, T], cen)]).

conflict([override_c3], [invalid_stat_cen]).
conflict([override_c3], [pipeline([stat], anc)]).

% =========================================================
% 6. PREFERENCES
% =========================================================
sup(c1, g0).   sup(cv1, g0).

sup(c2, g1).   sup(cv2, g1).
sup(c2, g2).   sup(cv2, g2).

sup(c3, g1).   sup(c3, g2).

sup(cv3, c3).
sup(cv3, g1).
