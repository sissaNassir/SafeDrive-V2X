% =========================================================
% 1. TRANSFORMATIONS AND ALGORITHMS
% =========================================================
% Available preprocessing transformations
t1 : [] => transformation(stat).     % Statistical Outlier Removal
t2 : [] => transformation(rad).      % Radius Outlier Removal
t3 : [] => transformation(none).     % No filter baseline

% Available detection backends
a1 : [] => algorithm(anc).           % Anchor-based / PointPillars-like
a2 : [] => algorithm(cen).           % Center-based / CenterPoint-like


% =========================================================
% 2. TRIGGERING CONDITIONS (ODD & Hardware)
% =========================================================
% Environmental and platform facts
p1 : [] => rain.
p2 : [] => jetson.

% V2X emergency facts
% NOTE:
% - In the static scenario, comment out p3 and p4.
% - In the V2X emergency scenario, keep them enabled.
p3 : [] => v2x_hazard.
p4 : [] => v2x_latency_high.


% =========================================================
% 3. PIPELINE GENERATION
% =========================================================
% g0 = no preprocessing
g0 : algorithm(A) => pipeline([], A).

% g1 = single preprocessing step
g1 : transformation(T), algorithm(A) => pipeline([T], A).

% g2 = two-step preprocessing pipeline with different transformations.
% The guard T1 \== T2 prevents duplicated pairs such as [stat, stat].
g2 : transformation(T1), transformation(T2),
     prolog(T1 \== T2), algorithm(A) => pipeline([T1,T2], A).


% =========================================================
% 4. CONSTRAINTS
% =========================================================

% c1:
% In rain, a filter is mandatory.
% This eliminates pipelines with no effective filtering.
c1  : rain => mandatory_filter.

% cv1:
% In V2X hazard conditions, filtering is also mandatory.
% This reinforces c1 under emergency.
cv1 : v2x_hazard => mandatory_filter.

% c2:
% On the Jetson target, radius-based outlier removal is forbidden
% because it is too computationally expensive for real-time execution.
c2  : jetson => invalid_rad.

% cv2:
% In V2X high-latency conditions, radius-based filtering is also forbidden.
% This reinforces c2 under emergency.
cv2 : v2x_latency_high => invalid_rad.

% c3:
% Nominal compatibility/default-policy rule:
% in normal operation, stat+cen is excluded by default.
% This constraint can be overridden only in V2X emergency mode.
c3  : [] => invalid_stat_cen.

% cv3:
% Emergency V2X override:
% when a V2X hazard is received, override the nominal compatibility rule c3.
% This allows the low-latency stat+cen configuration to become admissible.
cv3 : v2x_hazard => override_c3.


% =========================================================
% 5. CONFLICT RULES
% =========================================================

% mandatory_filter conflicts with no-filter pipelines.
conflict([mandatory_filter], [pipeline([], A)]).
conflict([mandatory_filter], [pipeline([none], A)]).

% Also reject multi-step pipelines that contain "none",
% since they still represent the absence of an effective filter.
conflict([mandatory_filter], [pipeline([none, T], A)]).
conflict([mandatory_filter], [pipeline([T, none], A)]).

% invalid_rad conflicts with every pipeline containing rad.
conflict([invalid_rad], [pipeline([rad], A)]).
conflict([invalid_rad], [pipeline([T, rad], A)]).
conflict([invalid_rad], [pipeline([rad, T], A)]).

% invalid_stat_cen conflicts with every stat+cen configuration.
conflict([invalid_stat_cen], [pipeline([stat], cen)]).
conflict([invalid_stat_cen], [pipeline([T, stat], cen)]).
conflict([invalid_stat_cen], [pipeline([stat, T], cen)]).

% override_c3 neutralizes invalid_stat_cen in V2X emergency.
conflict([override_c3], [invalid_stat_cen]).

% override_c3 also attacks the nominal stat+anc configuration.
% This encodes the V2X emergency low-latency policy:
% under hazard conditions, choose stat+cen instead of stat+anc.
conflict([override_c3], [pipeline([stat], anc)]).


% =========================================================
% 6. PREFERENCES
% =========================================================

% Safety constraints defeat pipeline-generation arguments.
sup(c1, g0).   sup(cv1, g0).

sup(c2, g1).   sup(cv2, g1).
sup(c2, g2).   sup(cv2, g2).

sup(c3, g1).   sup(c3, g2).

% In V2X emergency, cv3 has priority over the nominal compatibility rule c3.
sup(cv3, c3).

% In V2X emergency, cv3 also has priority over generated g1 pipelines
% when attacking the nominal stat+anc configuration.
sup(cv3, g1).
