data "aws_partition" "current" {}

locals {
  key_algorithm     = "RSA_2048"
  signing_algorithm = "SHA256WITHRSA"

  subordinate_common_name = "sub.${var.acmca_common_name}"
}

# https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html

### Root ###
resource "aws_acmpca_certificate_authority" "main" {
  usage_mode = "GENERAL_PURPOSE"
  type       = "ROOT"
  enabled    = true

  certificate_authority_configuration {
    key_algorithm     = local.key_algorithm
    signing_algorithm = local.signing_algorithm

    subject {
      common_name = var.acmca_common_name
    }
  }
}

resource "aws_acmpca_certificate" "main" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.main.arn
  certificate_signing_request = aws_acmpca_certificate_authority.main.certificate_signing_request
  signing_algorithm           = local.signing_algorithm

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 10
  }
}

resource "aws_acmpca_certificate_authority_certificate" "main" {
  certificate_authority_arn = aws_acmpca_certificate_authority.main.arn

  certificate       = aws_acmpca_certificate.main.certificate
  certificate_chain = aws_acmpca_certificate.main.certificate_chain
}

### Subordinate ###
resource "aws_acmpca_certificate_authority" "subordinate" {
  usage_mode = "GENERAL_PURPOSE"
  type       = "SUBORDINATE"
  enabled    = true

  certificate_authority_configuration {
    key_algorithm     = local.key_algorithm
    signing_algorithm = local.signing_algorithm

    subject {
      common_name = local.subordinate_common_name
    }
  }
}

resource "aws_acmpca_certificate" "subordinate" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.main.arn
  certificate_signing_request = aws_acmpca_certificate_authority.subordinate.certificate_signing_request
  signing_algorithm           = local.signing_algorithm

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen0/V1"

  validity {
    type  = "YEARS"
    value = 3
  }
}

resource "aws_acmpca_certificate_authority_certificate" "subordinate" {
  certificate_authority_arn = aws_acmpca_certificate_authority.subordinate.arn

  certificate       = aws_acmpca_certificate.subordinate.certificate
  certificate_chain = aws_acmpca_certificate.subordinate.certificate_chain
}

### Customer Gateway ###
resource "aws_acm_certificate" "customer_gateway" {
  domain_name               = "gateway.${local.subordinate_common_name}"
  certificate_authority_arn = aws_acmpca_certificate_authority.subordinate.arn

  lifecycle {
    create_before_destroy = true
  }
}
