**# Milestone Receipt — AI Two-Plane Governance v1**

**Date: 2026-02-12**

**Status: CLOSED (structural enforcement in DB)**



**## Goal**

**Separate AI into two planes:**

**- Plane A: Client-safe AI outputs**

**- Plane B: Internal learning / rich findings (non-leaky)**



**## Objects**

**Base (Plane B):**

**- audit.ai\_findings**



**Client Surface (Plane A):**

**- api.v\_client\_ai\_findings (sanitized allowlist view)**



**Tenant Authority:**

**- audit.tenants**

**- audit.user\_tenants**



**## Enforcement (DB Law)**

**### audit.ai\_findings**

**- RLS: enabled = true, forced = true**

**- Direct grants: revoked for public/anon/authenticated**

**- Policies:**

  **- INSERT: deny (authenticated)**

  **- UPDATE: deny (authenticated)**

  **- DELETE: deny (authenticated)**

  **- SELECT: tenant-scoped via audit.user\_tenants mapping**



**### api.v\_client\_ai\_findings**

**- Only sanitized columns exposed (no raw findings JSON):**

  **id, tenant\_id, subject\_ref, finding\_type, severity, summary,**

  **recommended\_action, confidence, model, model\_version, created\_at**

**- authenticated: SELECT granted**

**- public/anon: no access**



**## Proof (Observed)**

**Client-safe view returns a record with real tenant scope:**



**- id: 77ed6057-c719-4ee8-8780-299a4bf3b887**

**- tenant\_id: 11111111-1111-1111-1111-111111111111**

**- finding\_type: status**

**- severity: info**

**- summary: "All signals OK"**

**- model: rules-engine-v1**

**- model\_version: rules-engine-v1**



**## Result**

**Guided AI is now structurally enforced:**

**- Rich internal findings remain governed and non-leaky.**

**- Client-facing AI outputs are strictly allowlisted.**

**- Tenant authority is real (not placeholder-based).**

**- No UI behavior is required to maintain safety.**



**END.**

**'@**



