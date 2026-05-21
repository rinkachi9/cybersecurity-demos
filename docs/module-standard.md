# Module Standard

Kazdy modul demo powinien miec spójna strukture. Ten standard jest kryterium gotowosci dla dalszych prac.

## Minimalna struktura

```text
module-name/
  README.md
  metadata.yaml
  runbook.md
  terraform/
    versions.tf
    variables.tf
    main.tf
    outputs.tf
  evidence/
    README.md
  tests/
```

Nie kazdy modul musi miec Terraform lub testy od pierwszego dnia. Jezeli czegos brakuje, README powinien jasno oznaczac status i powod.

## README modulu

README powinien zawierac:

- Cel modulu.
- Ryzyko biznesowe i techniczne.
- Threat model albo abuse case.
- Architekture.
- Tryb vulnerable albo misconfigured, jezeli dotyczy.
- Mitigacje.
- Kroki uruchomienia.
- Kroki weryfikacji.
- Oczekiwane evidence.
- Cleanup.
- Koszty i ograniczenia.
- Mapowanie compliance.

## Metadata

Szablon znajduje sie w [docs/templates/metadata.yaml](./templates/metadata.yaml). Przyklad:

```yaml
id: gcp-cloud-armor-iap-cloud-run
domain: cloud-security
level: advanced
status: planned
estimated_cost: medium
tools:
  - terraform
  - gcloud
  - python
standards:
  - OWASP ASVS
  - NIST CSF
  - CIS GCP Benchmark
controls:
  - WAF
  - IAP
  - least privilege IAM
validation:
  automated: false
  evidence_required: true
```

## Evidence

Szablon znajduje sie w [docs/templates/evidence.md](./templates/evidence.md).

Evidence powinno byc lekkie i bez sekretow. Dopuszczalne artefakty:

- zanonimizowane logi,
- wyniki testow,
- zapytania BigQuery,
- zrzuty konfiguracji bez identyfikatorow wrazliwych,
- outputy `gcloud` po redakcji,
- opis oczekiwanego alertu.

## Terraform

Kazdy modul Terraform powinien miec:

- `required_version`,
- `required_providers`,
- zmienne zamiast placeholderow,
- walidacje zmiennych,
- outputy,
- opis uprawnien IAM,
- instrukcje `plan`, `apply`, `destroy`,
- ostrzezenie kosztowe, jezeli usluga jest platna.

Modul, ktory jest promowany do Etapu 3, musi dodatkowo miec:

- `terraform.tfvars.example`,
- `examples/minimal`,
- brak placeholderow typu `YOUR_*`,
- outputy potrzebne do integracji z pipeline albo runbookiem,
- walidator repozytorium rozszerzony o ten modul.

## Runbook

Szablon znajduje sie w [docs/templates/runbook.md](./templates/runbook.md). Runbook jest wymagany dla modulow operacyjnych, ktore dotykaja detekcji, remediacji, kontroli dostepu albo zmian mogacych blokowac srodowisko.

## Quality gates

Minimalny quality gate:

- Python syntax check.
- JavaScript syntax check, jezeli `node` jest dostepny.
- Markdown local link check.
- Sprawdzenie wymaganych plikow projektowych.
- Sprawdzenie `metadata.yaml` dla glownej listy modulow demonstracyjnych.
- Sprawdzenie `evidence/README.md` i `runbook.md`, jezeli metadata oznacza je jako wymagane.
- Docelowo: Terraform fmt/validate, Checkov, TFLint, Trivy, Gitleaks, ZAP.

## Web workshop baseline

Modul web security promowany do Etapu 4 powinien miec:

- wariant vulnerable i secure,
- jedna sciezke uruchomienia warsztatu,
- health endpoint,
- automatyczne PoC z trybem oczekiwan `vulnerable` i `secure`,
- evidence template dla wynikow ataku i mitigacji,
- walidator repozytorium sprawdzajacy minimalny kontrakt.

## GCP reference architecture baseline

Referencyjna architektura promowana do Etapu 5 powinna miec:

- kompletna kompozycje kilku security controls, nie pojedynczy zasob,
- Terraform z `versions.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars.example`,
- `examples/minimal`,
- diagram architektury jako kod,
- skrypt weryfikacyjny dla zachowan security controls,
- runbook operacyjny,
- evidence guide,
- walidator repozytorium sprawdzajacy minimalny kontrakt.

## Detection engineering baseline

Detekcja promowana do Etapu 6 powinna miec:

- osobny katalog per detection,
- `metadata.yaml` z data sources, MITRE ATT&CK, false positives i tuning,
- `README.md` z logika i ograniczeniami,
- `query.sql`,
- `sample-events.json`,
- `expected-result.json`,
- walidator repozytorium sprawdzajacy strukture i skladnie JSON.

## SOAR dry-run baseline

SOAR promowany do Etapu 6 powinien miec:

- deterministyczny risk scoring,
- remediacje domyslnie w trybie `dry_run`,
- sample events,
- expected results,
- lokalny test dry-run bez polaczenia z GCP,
- walidator repozytorium sprawdzajacy minimalny kontrakt.

## Supply chain baseline

Supply-chain modul promowany do Etapu 7 powinien miec:

- pipeline generujacy SBOM,
- skan podatnosci z artefaktem wynikowym,
- gate blokujacy wysokie/krytyczne podatnosci,
- provenance albo przyklad predicate,
- attestation albo przyklad payload,
- admission policy,
- evidence guide,
- runbook,
- CODEOWNERS dla security-sensitive paths,
- walidator repozytorium sprawdzajacy minimalny kontrakt.

## Portfolio baseline

Portfolio promowane do Etapu 8 powinno miec:

- showcase z 5/30/60/90 minute review paths,
- evidence matrix z poziomami dowodow,
- demo script dzialajacy bez Dockera i bez GCP,
- quickstart dla lokalnej walidacji,
- koszty i ograniczenia dla modulow runtime/cloud,
- decision records dla kluczowych wyborow,
- walidator repozytorium sprawdzajacy minimalny kontrakt.
