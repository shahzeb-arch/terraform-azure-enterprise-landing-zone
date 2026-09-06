locals {
  prefix  = lower("${var.org}-${var.env}-${var.region}")
  base    = var.workload != null ? "${local.prefix}-${var.workload}" : local.prefix
  suffix  = var.suffix != null ? "-${var.suffix}" : ""
  slug    = "${local.base}${local.suffix}"
  slug_rg = replace(local.slug, "-", "")
}
