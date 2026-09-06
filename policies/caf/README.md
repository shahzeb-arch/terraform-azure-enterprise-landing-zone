# Microsoft CAF Policy Initiatives

This folder documents recommended [Azure Landing Zone](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) policy initiatives and how to assign them via the governance layer.

## Built-in CAF-aligned initiatives

| Initiative | Definition ID | Purpose |
|------------|---------------|---------|
| Azure Security Benchmark | `/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-8471-7860b76b1a7e` | Security controls aligned to Microsoft cloud security benchmark |
| CIS Microsoft Azure Foundations | `/providers/Microsoft.Authorization/policySetDefinitions/612b5212-9160-4962-907f-2b2521087200` | CIS benchmark compliance |
| ISO 27001 | `/providers/Microsoft.Authorization/policySetDefinitions/088c51d8-2639-4d52-b943-597ced5769eb` | ISO 27001 alignment |
| NIST SP 800-53 R4 | `/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d249c5` | US federal compliance |
| PCI DSS 3.2.1 | `/providers/Microsoft.Authorization/policySetDefinitions/06a78e20-9358-41c9-9237-f3beff5a783a` | Payment card industry |
| SOC 2 Type 2 | `/providers/Microsoft.Authorization/policySetDefinitions/55c15d9d-0b47-4b00-89df-412a581a0d18` | SOC 2 controls |

## Assign via governance module

Use `environment/<env>/governance` with the `policy-assignment` module:

```hcl
policy_assignments = {
  "caf_security_benchmark" = {
    name                 = "caf-security-benchmark"
    display_name         = "CAF - Azure Security Benchmark"
    policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-8471-7860b76b1a7e"
    scope_type           = "subscription"
    enforce              = true
  }
}
```

## Custom initiatives

Place custom initiative JSON references under `policies/initiatives/` and create them with `modules/governence/initiative`, then assign via `modules/governence/policy-assignment`.

## Deployment order

1. Deploy `modules/governence/policy` for custom definitions (if needed)
2. Deploy `modules/governence/initiative` for custom bundles
3. Assign at management group or subscription scope via governance layer
4. Enable remediation identities where policies require `Modify` or `DeployIfNotExists`
