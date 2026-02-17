# platform

Shared CI/CD infrastructure for the golden path. Contains reusable GitHub Actions workflows, composite actions, and dev environment scripts.

## Quick Start

Bootstrap your dev environment:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/tstell90/platform/main/scripts/bootstrap.sh)
```

## Reusable Workflows

Use these in your project's `.github/workflows/ci.yml`:

```yaml
jobs:
  ci:
    uses: tstell90/platform/.github/workflows/_python-ci.yml@v1
    with:
      python-version: "3.12"
    secrets: inherit

  deploy-dev:
    needs: ci
    if: github.ref == 'refs/heads/dev'
    uses: tstell90/platform/.github/workflows/_databricks-deploy.yml@v1
    with:
      environment: dev
    secrets: inherit
```

### Available Workflows

| Workflow | Description | Key Inputs |
|---|---|---|
| `_python-ci.yml` | Lint + type-check + test | `python-version`, `run-mypy` |
| `_databricks-deploy.yml` | Deploy Databricks Asset Bundles | `environment`, `bundle-target` |
| `_terraform-plan-apply.yml` | Terraform plan/apply | `environment`, `plan-only` |
| `_dbt-run.yml` | dbt build & test | `dbt-command`, `dbt-args`, `environment` |

### Composite Actions

| Action | Description |
|---|---|
| `actions/setup-python-uv` | Install uv + Python + sync deps (used internally by workflows) |

## Versioning

Pinned via git tags. Consumers reference `@v1`, `@v1.2.0`, or commit SHA.

```yaml
uses: tstell90/platform/.github/workflows/_python-ci.yml@v1
```
