High-Level Flow (Text Diagram)

[Customer & System Events]
  ├─ Savings actions (deposits, misses)
  ├─ Loan repayments (on-time, late, partial)
  ├─ Ajo/Esusu turns (attendance, defaults)
  ├─ Transactions (inflows/outflows, merchants)
  ├─ KYC & device (ID, BVN, SIM swaps, device IDs)
  ├─ Agent & complaints (tickets, fraud flags)
  └─ External data (credit bureau, utilities)
          |
          v
[Ingestion]
  ├─ App/webhooks → event bus (Kafka/Kinesis)
  └─ Batch ETL (Airflow/Prefect)
          |
          v
[Processing & Feature Store]
  ├─ Stream calc (Flink/Spark Streaming)
  ├─ Daily batch metrics (SQL/DBT)
  └─ Persist features (Feast/Feature Tables)
          |
          v
[Scoring Service (API)] — FastAPI/Node
  ├─ Rule layer (hard stops/overrides)
  ├─ Points/weights (interpretable sum)
  └─ (Optional) ML model (XGBoost, sklearn)
          |
          v
[Risk Score 0–100 per customer]
  ├─ Score value
  ├─ Top ↑ and Top ↓ drivers (explainability)
  └─ Timestamp + version
          |
          v
[Consumers]
  ├─ Underwriting/loan engine
  ├─ Limits & pricing
  ├─ Alerts & interventions (SMS/agent)
  └─ Dashboards (Metabase/Superset)

(Audit & Governance alongside)
  ├─ Decision logs & overrides
  ├─ PII encryption & NDPR compliance
  └─ Model registry & drift monitors

What to Track (Key Features)

Savings: on-time rate (30/90/180d), growth %, variability (CV), days since last deposit

Loans: days late avg, #missed in 365d, pre/partial payments

Ajo/Esusu: missed turns ratio, group default flags

Transactions: net inflow trend, spikes, merchant mix

Device & Access: SIM swap recent, device consistency, multi-account/device

KYC: completeness (BVN, ID, address, face-match)

Agents/Support: complaints, dispute frequency, fraud flags

Social/Referrals: performance of referred users

Apply time decay so recent behaviour weighs more; cap/clip outliers.

Scoring Architecture (Interpretable Hybrid)

Rule Layer (Overrides)

Missing KYC ⇒ HIGH RISK (manual review/deny)

SIM swap + multi-account ⇒ escalate

Points/Weights LayerWeighted sum of normalized features → map to 0–100.

(Optional) ML LayerCalibrate PD (probability of default) with GBDT; blend with points:final = 0.7 * points_scaled + 0.3 * ml_scaled (adjust later).

Starter Weights (Tune Later)

On-time savings rate (30d): +20

Savings growth (90d): +10

Repayment timeliness (loan history): +25

Missed repayments (365d): −15

Ajo missed turns ratio: −8

KYC completeness: +10

Device/SIM risk flags: −6

Complaints/agent flags: −6

Compute: score_raw = Σ (norm(feature_i) * weight_i) → min/max scale to 0–100.

Normalization hints:

Rates/ratios: already 0–1

Counts/days: min–max or log scale then clamp to [0,1]

Flags: 1 (bad) or 0 (good), multiply by negative weight

Risk Bands → Business Actions

0–29 High: deny new loans, guarantor, manual review

30–54 Medium: small loans, shorter tenor, closer monitoring

55–74 Low: standard limits/pricing

75–100 Preferred: higher limits, lower fees, fast-track

Also map to Ajo benefits (priority turns, lower admin fees).

Update Cadence & Triggers

Realtime: repayment events, missed payment, KYC change, SIM swap

Daily (00:05): rolling metrics refresh (30/90/180d windows)

Weekly: model performance, drift checks, retrain candidacy

Immediate review triggers:

Score drop >20 within 7 days

New loan request with score <40

Fraud flag + large transaction

Monitoring & Feedback

Dashboards: score distribution, default rate by band, top flags

Model KPIs: AUC, PR, calibration; PSI for drift

Human-in-the-loop: store overrides & rationales; feed back to training labels

Privacy, Compliance, Security (Nigeria NDPR)

Minimize PII; AES‑256 at rest, TLS in transit

Store explanations with each decision (top up/down drivers)

Log all automated actions & overrides; retain ≥ 2 years

Tech Stack (Pragmatic)

Ingestion: Kafka/Kinesis, webhooks

Processing/Feature Store: Flink/Spark Streaming, Feast

Storage: Postgres (OLTP), ClickHouse/BigQuery (analytics)

Modeling: Python (sklearn/XGBoost), MLflow registry

Serving: FastAPI / Node.js (real-time scoring)

Dashboards: Metabase / Superset / Grafana

Jobs/ETL: Airflow / Prefect

Alerts: Slack/Email/Twilio

Auth/ID: Cognito / Keycloak

MVP (low-cost): Firebase/Auth + Postgres + Python scorer (cron) + Metabase.

Example: Simple Scoring (Pseudocode)

weights = {
  'on_time_rate_30d': 20,
  'repayment_timeliness_score': 25,
  'savings_growth_90d': 10,
  'missed_repayments_365d': -15,
  'ajo_missed_ratio': -8,
  'kyc_complete': 10,
  'device_flag': -6,
  'complaint_flag': -6,
}

# features_norm contains values in [0,1]; negatives already oriented (1 = worse)
raw = sum(features_norm[f] * w for f, w in weights.items() if f in features_norm)
# scale to 0..100 (min_raw and max_raw set from business rules or historical data)
score = max(0, min(100, 100 * (raw - min_raw) / (max_raw - max_raw)))

Set min_raw/max_raw using historical percentiles (e.g., 5th/95th) to avoid outlier influence.

SQL Example: on_time_rate_30d

-- payments(user_id, due_date, paid_date)
WITH last_30 AS (
  SELECT user_id,
         COUNT(*) FILTER (
           WHERE due_date BETWEEN now() - interval '30 days' AND now()
         ) AS due_count,
         COUNT(*) FILTER (
           WHERE paid_date IS NOT NULL
             AND paid_date <= due_date
             AND due_date BETWEEN now() - interval '30 days' AND now()
         ) AS on_time_count
  FROM payments
  GROUP BY user_id
)
SELECT user_id,
       CASE WHEN due_count = 0 THEN 0
            ELSE on_time_count::float / due_count
       END AS on_time_rate_30d
FROM last_30;

Explainability (store per decision)

Top 3 ↑ drivers (features increasing score)

Top 3 ↓ drivers (features reducing score)

Versioned weight set / model hash + timestamp

Deployment Roadmap

Phase 1 (0–3 mo): implement rules + points engine, daily batch features, score API, dashboard.Phase 2 (3–9 mo): add ML model, drift monitoring, retraining pipeline, external data.Phase 3 (>9 mo): move to streaming updates, automated playbooks, personalized offers.

Actionable Next Steps (choose)

Define exact normalization rules per feature (spec).

Ship a Python scoring microservice (FastAPI + Docker).

Build SQL jobs for rolling metrics.

Draft admin dashboard (score distribution, band defaults, alert feed).

