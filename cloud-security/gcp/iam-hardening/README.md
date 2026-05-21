# IAM Hardening

Ten obszar pokazuje dojrzale zarzadzanie tozsamoscia w Google Cloud: least privilege, zarzadzanie grupami, tozsamosci workloadow i eliminacje statycznych kluczy service account.

## Moduly

- [Resource Access Management](./resource-access-management/README.md): custom roles, grupy, conditional IAM i granularny dostep do zasobow.
- [Workload Identity Federation](./workload-identity-federation/README.md): keyless authentication dla CI/CD bez kluczy JSON.

## Kierunek ekspercki

Docelowo ten obszar powinien miec:

- parametryzowane Terraform modules,
- walidacje warunkow IAM,
- przyklady GitHub/GitLab OIDC,
- testy potwierdzajace brak statycznych kluczy,
- runbook access review,
- mapowanie na CIS GCP, SOC2 i PCI-DSS.

