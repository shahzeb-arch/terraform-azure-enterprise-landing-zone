# Module Standards & Conventions

This is the single source of truth for how every module in this repo is written.
**Every new module MUST follow this pattern** so the codebase stays consistent and
easy to recall.

## Folder layout

```
modules/<category>/<resourceName>/
├── main.tf       # resources only
├── variable.tf   # all input variables
├── output.tf     # all outputs
└── README.md     # what it is + production usage (this template)
```

Categories: `foundation`, `networking`, `compute` (more added as the ELZ grows:
`security`, `monitoring`, `identity`, `management`, `data`).

## Naming rules

| Thing | Rule | Example |
|---|---|---|
| Folder name | camelCase for resource modules | `virtualNetwork`, `routeTable` |
| File names | singular: `main.tf`, `variable.tf`, `output.tf` | — |
| Resource label | always `this` for a single primary resource | `azurerm_subnet.this` |
| Variables | snake_case, always have `description` | `resource_group_name` |
| Optional inputs | use `default` + `optional()` (inside objects only) | — |

## Quality rules (non-negotiable)

1. No hardcoded values in `main.tf` — expose them as variables with safe defaults.
2. Every variable has a `description`; add `validation` where values are constrained.
3. Secure-by-default (e.g. `encryption_at_host`, `secure_boot`, `vtpm` = `true`).
4. `sensitive = true` for secrets (passwords, keys).
5. Outputs always include at least `id` and `name`.

## README template (copy this for every module)

```md
# <Resource Name>

## What it is
1-2 lines: what this Azure resource does in plain language.

## When to use it (production)
- bullet points

## Resources created
- azurerm_xxx

## Usage example
​```hcl
module "example" { ... }
​```

## Inputs
| Name | Description | Type | Default | Required |

## Outputs
| Name | Description |

## Production notes
- best practices / gotchas
```
