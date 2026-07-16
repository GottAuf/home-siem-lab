# 07 - Detection Engineering

## Objective

This document defines the detection engineering methodology adopted throughout the project. It establishes a repeatable process for designing, implementing, validating, tuning, and maintaining security detections to ensure consistent, reliable, and measurable monitoring capabilities.

The objective is not simply to enable security features, but to produce detections that are accurate, reproducible, and operationally useful.

---

# Detection Engineering

Detection engineering is the process of developing analytics that identify malicious or suspicious activity from collected telemetry.

Unlike infrastructure deployment, detection engineering focuses on the quality of security monitoring rather than the monitoring platform itself. A successful detection provides analysts with sufficient context to identify, investigate, and respond to security events while minimizing unnecessary alert noise.

Every detection implemented during this project follows a standardized engineering lifecycle.

---

# Detection Engineering Lifecycle

```text
Requirements
      │
      ▼
Detection Design
      │
      ▼
Implementation
      │
      ▼
Validation
      │
      ▼
Investigation
      │
      ▼
ATT&CK Mapping
      │
      ▼
Tuning
      │
      ▼
Regression Testing
      │
      ▼
Continuous Improvement
```

Detection development is iterative. Each stage informs the next, allowing detections to evolve as new threats, telemetry, or operational requirements emerge.

---

# Detection Design

Every detection begins by defining the security problem it is intended to solve.

At a minimum, the following questions should be answered:

* What behavior should be detected?
* Why is the behavior significant?
* Which telemetry source provides evidence of the activity?
* What conditions distinguish normal behavior from suspicious behavior?

Clearly defining the detection objective prevents unnecessary complexity and reduces false positives.

---

# Detection Implementation

Once the detection requirements have been established, the necessary monitoring capability is configured.

Implementation should prioritize:

* Simplicity
* Maintainability
* Minimal deviation from vendor defaults
* Version-controlled configuration

Each implementation should have a clearly defined purpose and avoid unnecessary customization.

---

# Detection Validation

A detection is not considered complete until it has been validated.

Validation consists of generating controlled activity that exercises the detection under known conditions and confirming that the expected alert is produced.

Successful validation confirms:

* Required telemetry is collected.
* Detection logic executes correctly.
* Alerts are generated consistently.
* Alert metadata contains sufficient investigative context.

Configuration without validation provides little assurance that a detection is functioning as intended.

---

# Detection Investigation

Every validated detection should be reviewed from the perspective of a security analyst.

The investigation should determine:

* What triggered the detection?
* Which rule generated the alert?
* What contextual information is available?
* Can the alert be understood without additional investigation?
* Would the alert support an effective incident response?

The objective is to evaluate the usefulness of the detection rather than simply confirming that an alert exists.

---

# MITRE ATT&CK Mapping

Where applicable, detections should be mapped to the MITRE ATT&CK framework.

Mappings provide standardized descriptions of adversary behavior and improve understanding of detection coverage.

Each mapping should identify:

* ATT&CK tactic
* ATT&CK technique
* Detection objective
* Known limitations

Mappings should describe attacker behavior rather than operating system events alone.

---

# Detection Tuning

Initial implementations rarely produce optimal results.

Following validation, detections should be refined to improve operational effectiveness.

Areas for evaluation include:

* False positives
* Duplicate alerts
* Missing context
* Alert severity
* Detection reliability

The objective of tuning is to improve signal quality while reducing unnecessary analyst workload.

---

# Regression Testing

Every detection should remain effective following platform upgrades, configuration changes, or rule modifications.

Regression testing verifies that previously validated detections continue to operate as expected.

Validation scenarios should be repeatable and produce consistent results across multiple executions.

Automated testing is preferred wherever practical.

---

# Detection Quality

Detection effectiveness should be evaluated using qualitative and operational measures rather than alert volume alone.

Important characteristics include:

* Accuracy
* Reliability
* Reproducibility
* Investigative value
* Maintainability
* Performance

High-quality detections provide analysts with actionable information while minimizing operational noise.

---

# Guiding Principles

The following principles guide all detection engineering activities throughout the project.

### Validation Before Trust

No detection is considered complete until it has been successfully validated.

### Simplicity

Detection logic should remain as simple as possible while meeting operational requirements.

### Repeatability

Validation procedures should produce consistent and reproducible results.

### Continuous Improvement

Detections should evolve based on operational experience, environmental changes, and emerging threats.

### Evidence-Based Decisions

Changes to detections should be supported by observed behavior, validation results, or measurable operational improvements.

---

# Outcome

This document establishes the engineering methodology that will be applied to every detection capability implemented throughout the project.

Each subsequent implementation—including File Integrity Monitoring, Security Configuration Assessment, Vulnerability Detection, Log Collection, Custom Detection Rules, and Active Response—will follow the lifecycle defined in this document to ensure consistency, repeatability, and operational effectiveness.

