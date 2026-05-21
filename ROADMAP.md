# Expert Roadmap

## Cel docelowy

Repozytorium ma byc eksperckim portfolio Security Engineering, Cloud Security Architecture i DevSecOps. Docelowo powinno pokazywac nie tylko znajomosc mechanizmow GCP i OWASP, ale tez sposob pracy architekta: threat modeling, IaC, walidacje, evidence, operacyjne playbooki, detekcje, remediacje i mapowanie na ryzyka biznesowe.

## Ocena obecnego stanu

Projekt ma dobry zakres tematyczny i czytelny kierunek: Web Security, GCP Security, SecOps, DevSecOps i best practices. Najmocniejsze obszary to szerokie pokrycie mechanizmow GCP, obecne przyklady Terraform, SOAR workflow, Security Data Lake, OWASP lab oraz materialy edukacyjne.

Glowne luki, ktore trzeba zamknac, zeby projekt wygladal ekspercko:

- Brak jednolitego standardu modulu: czesc katalogow ma README i kod, ale brakuje powtarzalnej struktury "risk -> exploit -> mitigation -> automation -> evidence".
- Terraform jest w formie demonstracyjnej: duzo placeholderow, brak `variables.tf`, `outputs.tf`, wersji providerow, backendu, walidacji i srodowisk.
- Brak centralnej walidacji repozytorium: nie ma quality gate, ktory potwierdza, ze PoC, Python, YAML, linki i przyklady sa spójne.
- Brak warstwy dowodowej: demo opisuje architekture, ale nie zbiera artefaktow typu log queries, expected findings, screenshots, test outputs, runbook outputs.
- Brak priorytetyzacji: repo ma szeroki zakres, ale nie wskazuje sciezki "najpierw uruchom to, potem to".
- Czesc PoC wymaga dopracowania technicznego: np. OWASP exploit script byl nieuruchamialny przez blad skladni.

## Definicja poziomu eksperckiego

Modul uznajemy za ekspercki, jezeli spelnia nastepujace kryteria:

- Ma jawny threat model lub abuse case.
- Ma dzialajacy wariant podatny albo ryzykowny oraz wariant zabezpieczony.
- Ma automatyczna walidacje security control.
- Ma IaC albo deklaratywny manifest dla infrastruktury.
- Ma minimalne uprawnienia IAM opisane i wymuszone w kodzie.
- Ma logi, detekcje albo metryki, ktore pokazuja jak wykryc naruszenie.
- Ma procedure uruchomienia, weryfikacji i sprzatania.
- Ma mapowanie na standardy: OWASP ASVS/SAMM, NIST CSF, CIS GCP, SOC2, PCI-DSS lub GDPR.

## Etap 1: Fundament jakości i operacyjności

Cel: zrobic z repozytorium powtarzalny, sprawdzalny projekt, a nie tylko zbior opisow.

Zakres:

- Dodac centralna roadmapę i assessment.
- Dodac standard modulu i checklisty gotowosci.
- Poprawic nieuruchamialne PoC.
- Dodac walidator repozytorium.
- Dodac workflow CI dla podstawowej walidacji.
- Uporzadkowac ignorowane artefakty lokalne.

Kryteria akceptacji:

- `python3 scripts/audit/validate_repository.py` przechodzi lokalnie.
- Pythonowe PoC kompiluja sie bez bledow.
- Lokalne linki w Markdown sa poprawne.
- README prowadzi do roadmapy, assessmentu i standardu modulu.

Status: baseline zrealizowany. Repo ma centralna roadmapę, assessment, standard modulu, lokalny walidator, CI quality gate i poprawiony OWASP PoC.

## Etap 2: Standaryzacja modulow demo

Cel: kazdy modul ma wygladac jak gotowy material dla senior security review, warsztatu albo rozmowy technicznej.

Zakres:

- Dla kazdego modulu dodac sekcje:
  - problem i ryzyko,
  - threat model,
  - architektura,
  - kroki uruchomienia,
  - kroki ataku lub scenariusz awarii,
  - mitigacja,
  - automatyczna walidacja,
  - expected evidence,
  - cleanup.
- Dodac `metadata.yaml` dla modulow: domena, poziom trudnosci, wymagane narzedzia, koszt GCP, standardy compliance, status.
- Dodac `runbook.md` tam, gdzie modul dotyczy operacji Security/SecOps.
- Dodac `evidence/README.md` jako miejsce na wynikowe logi, zapytania i przyklady alertow.

Priorytet modulow:

1. OWASP Top 10 Lab.
2. Workload Identity Federation.
3. Cloud Armor + IAP + Cloud Run.
4. Security Data Lake.
5. SOAR leaked key playbook.
6. GKE security.
7. VPC Service Controls.

Status: baseline zrealizowany. Wszystkie glowne moduly demonstracyjne maja `metadata.yaml` oraz `evidence/README.md`. Moduly operacyjne wysokiego priorytetu dostaly rowniez `runbook.md`. Walidator sprawdza teraz minimalny kontrakt Etapu 2.

## Etap 3: Terraform jako produkt, nie szkic

Cel: IaC ma byc walidowalne, parametryzowane i gotowe do bezpiecznego uruchomienia w kontrolowanym projekcie testowym.

Zakres:

- Dodac `versions.tf`, `variables.tf`, `outputs.tf` i `README.md` w kazdym module Terraform.
- Zastapic placeholdery `YOUR_*` zmiennymi z walidacja.
- Dodac `examples/minimal` dla modulow infrastruktury.
- Dodac `terraform fmt`, `terraform validate`, `tflint` i `checkov` w CI.
- Dodac `cost-notes.md` dla uslug platnych: Cloud IDS, SWP, GKE, BigQuery, Cloud Armor.
- Rozdzielic moduly demonstracyjne od kompozycji srodowiska testowego.
- Dodac bezpieczne destroy/cleanup instructions.

Kryteria akceptacji:

- Kazdy modul Terraform ma jawne providery i zmienne.
- CI waliduje format i podstawowa skladnie.
- Checkov/Tfsec maja swiadome suppressions tylko z uzasadnieniem.

Status: rozpoczęty. Modul Workload Identity Federation zostal przepisany jako productized IaC baseline: ma `versions.tf`, `variables.tf`, `outputs.tf`, walidowane zmienne, brak placeholderow, przyklad `examples/minimal`, outputy dla GitHub Actions i walidator egzekwujacy ten minimalny standard.

## Etap 4: Web Security Lab na poziomie warsztatowym

Cel: OWASP lab ma dzialac jako samodzielny, powtarzalny warsztat secure coding.

Zakres:

- Dodac Docker Compose z trybem vulnerable i secure.
- Rozdzielic aplikacje na warstwy: routes, auth, db, security controls.
- Dodac testy automatyczne dla SQLi, XSS, BAC/IDOR, SSRF, CSRF i insecure deserialization jezeli pasuje do stacku.
- Dodac OWASP ZAP baseline scan.
- Dodac mapowanie do OWASP Top 10 2021 i OWASP ASVS.
- Dodac intentional vulnerabilities z flagami, zeby demo bylo bezpieczne poza lokalnym srodowiskiem.

Kryteria akceptacji:

- Jedna komenda uruchamia lab.
- Jedna komenda wykonuje testy ataku.
- Secure mode blokuje wszystkie zaimplementowane PoC.

Status: baseline zrealizowany bez runtime testu Dockera. OWASP lab ma Dockerfile, Docker Compose dla trybu vulnerable i secure, health endpoint, rozszerzony PoC z asercjami oraz dodatkowy scenariusz IDOR/Broken Object-Level Authorization. Walidator repozytorium egzekwuje minimalny kontrakt warsztatu. Kontenery nie zostaly uruchomione w tej iteracji zgodnie z decyzja, zeby nie startowac Dockera.

## Etap 5: GCP reference architecture

Cel: pokazac kompletna architekture cloud-native dla bezpiecznej aplikacji, nie tylko pojedyncze controls.

Zakres:

- Zbudowac Secure Cloud Run Architecture:
  - Cloud Run z ingress przez Load Balancer,
  - Cloud Armor WAF,
  - IAP,
  - Secret Manager,
  - Serverless NEG,
  - minimalne IAM,
  - log sink do BigQuery.
- Dodac wariant "public misconfiguration" i remediacje.
- Dodac diagram C4: context, container, deployment.
- Dodac testy weryfikacyjne: WAF blocks, IAP required, direct Cloud Run blocked, logs exported.

Kryteria akceptacji:

- Demo da sie wdrozyc do izolowanego projektu GCP.
- Kazdy security control ma weryfikowalny test.
- Kazdy test ma oczekiwany wynik i przyklad logu.

Status: baseline zrealizowany bez wdrozenia do GCP. Dodany zostal modul `Secure Cloud Run Edge` z Cloud Run, Serverless NEG, HTTPS Load Balancer, Cloud Armor, IAP, restricted ingress, logowaniem backendu, outputami, minimalnym przykladem, runbookiem, evidence i skryptem weryfikacyjnym. Walidator repozytorium egzekwuje minimalny kontrakt referencyjnej architektury.

## Etap 6: Detection Engineering i SOAR

Cel: przeniesc repo z "security controls" do "security operations".

Zakres:

- Ustrukturyzowac detection rules jako katalog reguly:
  - opis,
  - MITRE ATT&CK mapping,
  - data sources,
  - false positives,
  - tuning,
  - SQL,
  - test data.
- Dodac sample events do testowania BigQuery SQL lokalnie lub w BigQuery sandbox.
- Rozwinac SOAR:
  - enrichment,
  - risk scoring,
  - human approval path,
  - auto-remediation,
  - notification,
  - audit trail.
- Dodac playbooki dla public bucket, leaked service account key, suspicious IAM grant i anomalous egress.

Kryteria akceptacji:

- Kazda detekcja ma testowy event i oczekiwany alert.
- SOAR ma symulacje lokalna albo kontrolowany dry-run.
- Remediacje maja tryb `dry_run`.

Status: baseline zrealizowany bez wdrozenia do GCP. Security Data Lake ma teraz detection-as-code dla brute force, low-and-slow beaconing i GCS exfiltration: kazda detekcja ma `metadata.yaml`, `README.md`, `query.sql`, `sample-events.json` i `expected-result.json`. SOAR ma deterministyczny enrichment, domyslny dry-run remediation, sample events, expected results oraz lokalny test `python3 secops/soar-architecture/tests/test_dry_run.py`.

## Etap 7: Supply Chain Security

Cel: pokazac dojrzaly DevSecOps i SLSA-style supply chain.

Zakres:

- GitHub Actions z OIDC do GCP bez kluczy JSON.
- Cloud Build z artifact provenance.
- SBOM dla obrazow i aplikacji.
- Trivy/Gitleaks/Checkov/ZAP jako spójny pipeline.
- Binary Authorization z attestation.
- Polityki dopuszczenia wdrozen dla GKE/Cloud Run.
- Branch protection i CODEOWNERS dla security-sensitive paths.

Kryteria akceptacji:

- Pipeline nie uzywa statycznych sekretow.
- Artefakt ma SBOM i wynik skanowania.
- Deploy wymaga pozytywnej attestacji.

Status: baseline zrealizowany bez budowania obrazow i bez wdrozenia. GCP Native Supply Chain ma Cloud Build pipeline dla SBOM, SARIF, vulnerability gate, push po pozytywnym skanie i Binary Authorization attestation. Dodane zostaly admission policy, SLSA provenance example, attestation payload example, runbook, evidence guide update, GitHub SBOM/SARIF template oraz CODEOWNERS. Walidator repozytorium egzekwuje minimalny kontrakt Etapu 7.

## Etap 8: Portfolio, narracja i dowody

Cel: repo ma byc czytelne dla rekrutera technicznego, architekta security i inzyniera, ktory chce uruchomic demo.

Zakres:

- Dodac `docs/showcase.md` z rekomendowana sciezka prezentacji 30/60/90 minut.
- Dodac status matrix modulow.
- Dodac diagramy architektury jako kod.
- Dodac "decision records" dla kluczowych wyborow.
- Dodac sekcje kosztow i ograniczen.
- Dodac quickstarty.

Kryteria akceptacji:

- Czytelnik w 5 minut wie, co projekt pokazuje.
- Czytelnik w 30 minut moze uruchomic co najmniej jedno demo.
- Czytelnik w 60 minut widzi pelny lancuch: attack -> detection -> response -> evidence.

Status: baseline zrealizowany bez uruchamiania Dockera i bez wdrozenia do GCP. Dodane zostaly `docs/showcase.md`, `docs/evidence-matrix.md`, `docs/demo-script.md`, `docs/quickstart.md`, `docs/costs-and-limitations.md` oraz pierwsze ADR-y w `docs/decision-records/`. Walidator repozytorium egzekwuje minimalny kontrakt Etapu 8: sciezki prezentacji 5/30/60/90 minut, matryce dowodow, dry-run demo, ograniczenia kosztowe i decyzje architektoniczne.

## Etap 9: Reusable security controls jako productized IaC

Cel: rozszerzyc standard Etapu 3 poza pierwszy modul WIF i referencyjna architekture, zaczynajac od kontrolki, ktora jest często uzywana w wielu architekturach: Cloud Armor WAF.

Zakres:

- Przepisac Cloud Armor WAF jako reuzywalny Terraform module.
- Dodac `versions.tf`, `variables.tf`, `outputs.tf` i `terraform.tfvars.example`.
- Dodac `examples/minimal`.
- Dodac walidowane zmienne dla WAF rules, rate limiting, Adaptive Protection, bot management i custom CEL rules.
- Dodac output `security_policy_self_link` do integracji z backend service.
- Dodac lokalny test kontraktu modulu bez laczenia z GCP.
- Rozszerzyc centralny walidator o Cloud Armor WAF baseline.

Kryteria akceptacji:

- Modul nie zawiera placeholderow typu `YOUR_*`.
- Modul ma jawny provider, wersje Terraform, zmienne, outputy i minimalny przyklad.
- Modul daje sie podpiac do referencyjnej architektury przez output policy self link.
- Lokalna walidacja repozytorium i test kontraktu modulu przechodza bez Dockera i bez GCP.

Status: baseline zrealizowany bez uruchamiania Dockera i bez wdrozenia do GCP. Cloud Armor WAF ma teraz productized Terraform baseline, minimal example, outputy integracyjne, lokalny test kontraktu i zaktualizowany runbook/evidence guide.

## Etap 10: Security Data Lake jako productized IaC

Cel: przeniesc Security Data Lake z poziomu detection-as-code do pelnego, reuzywalnego modulu IaC dla SecOps.

Zakres:

- Przepisac Terraform Security Data Lake jako productized module.
- Dodac `versions.tf`, `variables.tf`, `outputs.tf` i `terraform.tfvars.example`.
- Obsluzyc sink scope: `project`, `folder`, `organization`.
- Dodac BigQuery dataset IAM dla wygenerowanej writer identity.
- Dodac opcjonalne BigQuery scheduled queries dla istniejacych detekcji.
- Dodac `examples/minimal`.
- Dodac lokalny test kontraktu bez laczenia z GCP.
- Rozszerzyc centralny walidator o Security Data Lake baseline.

Kryteria akceptacji:

- Modul nie zawiera placeholderow typu `YOUR_*`.
- Modul ma jawne providery, zmienne, outputy i minimalny przyklad.
- Modul potrafi wdrozyc sink dla projektu, folderu albo organizacji.
- Scheduled detections sa opcjonalne i domyslnie wylaczone.
- Lokalna walidacja repozytorium i test kontraktu modulu przechodza bez Dockera i bez GCP.

Status: baseline zrealizowany bez uruchamiania Dockera i bez wdrozenia do GCP. Security Data Lake ma teraz productized Terraform baseline, scoped log sinks, dataset IAM dla writer identity, opcjonalne scheduled detections, minimal example, lokalny test kontraktu oraz zaktualizowany runbook/evidence guide.

## Etap 11: VPC Service Controls jako dry-run first productized IaC

Cel: podniesc jeden z najbardziej ryzykownych operacyjnie controls GCP do standardu, ktory pokazuje bezpieczny rollout, dry-run, wyjątki i rollback.

Zakres:

- Przepisac VPC Service Controls Terraform jako productized module.
- Dodac `versions.tf`, `variables.tf`, `outputs.tf` i `terraform.tfvars.example`.
- Wspierac istniejacy albo nowy Access Context Manager access policy.
- Dodac trusted access level dla IP, regionow i opcjonalnych IAM members.
- Rozdzielic `status` od dry-run `spec` przez `enforcement_mode`.
- Dodac ingress i egress exception policies.
- Dodac `examples/minimal`.
- Dodac lokalny test kontraktu bez laczenia z GCP.
- Rozszerzyc centralny walidator o VPC Service Controls baseline.

Kryteria akceptacji:

- Modul nie zawiera placeholderow typu `YOUR_*`.
- Domyslny wzorzec wdrozenia jest dry-run first.
- Modul ma jawne providery, zmienne, outputy i minimalny przyklad.
- Lokalna walidacja repozytorium i test kontraktu modulu przechodza bez Dockera i bez GCP.

Status: baseline zrealizowany bez uruchamiania Dockera i bez wdrozenia do GCP. VPC Service Controls ma teraz productized dry-run Terraform baseline, minimal example, test kontraktu, zaktualizowany runbook/evidence guide oraz status w portfolio.

## Etap 12: Cloud IDS jako kosztowo swiadomy productized IaC

Cel: podniesc Cloud IDS z prostego szkicu do kontrolowanego modulu IaC, ktory wymusza waski zakres mirroringu, evidence i teardown dla kosztownego testu.

Zakres:

- Przepisac Cloud IDS Terraform jako productized module.
- Dodac `versions.tf`, `variables.tf`, `outputs.tf` i `terraform.tfvars.example`.
- Dodac opcjonalne wlaczanie wymaganych API.
- Dodac reserved private service range i Service Networking connection.
- Dodac Cloud IDS endpoint z walidowana minimalna severka findingow.
- Dodac Packet Mirroring z subnet/instance/tag scope, CIDR filter i direction.
- Dodac `examples/minimal`.
- Dodac lokalny test kontraktu bez laczenia z GCP.
- Dodac runbook kosztowy i evidence guide.
- Rozszerzyc centralny walidator o Cloud IDS baseline.

Kryteria akceptacji:

- Modul nie zawiera placeholderow typu `YOUR_*`.
- Modul ma jawne providery, zmienne, outputy i minimalny przyklad.
- Mirroring scope jest jawnie konfigurowany.
- Evidence wymaga SCC/Cloud Logging finding oraz teardown proof.
- Lokalna walidacja repozytorium i test kontraktu modulu przechodza bez Dockera i bez GCP.

Status: baseline zrealizowany bez uruchamiania Dockera i bez wdrozenia do GCP. Cloud IDS ma teraz productized Terraform baseline, minimal example, lokalny test kontraktu, runbook kosztowy i zaktualizowany evidence guide.

## Finalna wersja statyczna

Status: zrealizowana bez uruchamiania Dockera, Terraform CLI i bez wdrozenia do GCP.

Finalnie repozytorium ma:

- centralny quality gate,
- spójny standard modulow,
- `metadata.yaml` i `evidence/README.md` dla glownych modulow,
- runbooki dla modulow operacyjnych,
- productized Terraform baseline we wszystkich katalogach `terraform/`,
- brak placeholderow `YOUR_*`, `yourdomain.com` i `your-` w Terraform,
- detection-as-code z sample events i expected results,
- SOAR dry-run z lokalnym testem,
- supply-chain baseline z SBOM, SARIF, provenance i attestation artifacts,
- portfolio showcase, evidence matrix, quickstart, demo script, ADR-y i final acceptance.

Od tego miejsca backlog nie dotyczy juz strukturalnego domykania repozytorium. Kolejny sensowny krok to zebranie runtime evidence w izolowanych srodowiskach:

1. Terraform/OpenTofu `fmt`, `validate`, `plan` dla wybranych modulow.
2. OWASP Docker runtime output dla trybu vulnerable i secure.
3. Secure Cloud Run Edge deployment evidence z testowego projektu.
4. Cloud Armor, VPC Service Controls i Cloud IDS runtime evidence.
5. Cloud Build, SBOM/SARIF, Binary Authorization allow/deny proof.
6. Redaktowane logi, alerty, cleanup proof i koszty.
