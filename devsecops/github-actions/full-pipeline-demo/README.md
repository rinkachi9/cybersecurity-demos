# DevSecOps: Shift-Left Security Pipeline

Ten moduł prezentuje podejście **Shift-Left**, czyli integrowanie testów bezpieczeństwa na jak najwcześniejszym etapie cyklu życia oprogramowania (SDLC).

## 🛡️ Filary Pipeline'u Security

### 1. Secret Scanning (Gitleaks)
- **Cel**: Wykrywanie zahardkodowanych haseł, kluczy API, certyfikatów i tokenów.
- **Dlaczego?**: Wyciek poświadczeń to najczęstsza przyczyna incydentów chmurowych.

### 2. IaC Security (Checkov)
- **Cel**: Skanowanie plików Terraform pod kątem błędów konfiguracyjnych.
- **Przykład**: Wykrywa publiczne bucket-y S3, brak szyfrowania dysków lub zbyt szerokie reguły Firewall.

### 3. Software Composition Analysis (SCA) & SAST (Trivy)
- **Cel**: Wykrywanie podatności w bibliotekach (np. `npm`, `pip`) oraz w systemie plików.
- **Dlaczego?**: Twoja aplikacja jest tak bezpieczna, jak jej najsłabsza zależność (np. incydent Log4j).

## 🚀 Jak użyć tych narzędzi?

W pliku `.github/workflows/security.yml` zdefiniowaliśmy joby, które uruchamiają się przy każdym `push` i `pull_request`. 
Dobre praktyki:
- **Block on Failure**: Jeśli narzędzie wykryje błąd o krytycznym priorytecie, pipeline powinien zostać przerwany.
- **Visibility**: Wyniki powinny być raportowane w sekcji "Security" na GitHubie lub w komentarzach do PR.

---
*Narzędzia użyte w demo: [Gitleaks](https://github.com/gitleaks/gitleaks), [Checkov](https://www.checkov.io/), [Trivy](https://aquasecurity.github.io/trivy/)*
