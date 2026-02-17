# Platform Repo — Claude Code Context

This is a shared platform repo containing reusable GitHub Actions workflows and composite actions.
It is NOT an application — it is infrastructure that other repos reference.

## Structure

- `.github/workflows/_*.yml` — Reusable workflows (prefixed with `_` to distinguish from triggerable workflows)
- `actions/setup-python-uv/` — Composite action for Python + uv setup
- `scripts/` — Dev machine bootstrap and validation scripts

## Reusable Workflows

| Workflow | Purpose |
|---|---|
| `_python-ci.yml` | Lint (ruff), type-check (mypy), test (pytest) |
| `_databricks-deploy.yml` | Validate + deploy Databricks Asset Bundles |
| `_terraform-plan-apply.yml` | Terraform plan on PR, apply on merge |
| `_dbt-run.yml` | dbt build/test via Databricks |

## Conventions

- All workflows use `workflow_call` trigger
- All workflows accept a `working-directory` input (default: `.`)
- Python workflows use the `setup-python-uv` composite action
- Consumers pin to git tags: `uses: tstell90/platform/.github/workflows/_python-ci.yml@v1`
- Versioning follows semver — breaking changes require major version bump

## When editing workflows

- Test changes by creating a test repo that calls the workflow from a branch
- Never change input names or remove inputs without a major version bump
- Keep workflows focused — one concern per workflow
