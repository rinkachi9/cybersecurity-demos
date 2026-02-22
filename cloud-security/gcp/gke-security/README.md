# GKE Security: Network Segmentation & Hardening

W środowiskach kontenerowych (Kubernetes), domyślna konfiguracja sieci często pozwala na swobodną komunikację między wszystkimi Podami. W przypadku przejęcia jednego kontenera, atakujący może łatwo skanować i atakować inne usługi wewnątrz klastra (Lateral Movement).

## 🛡️ Kluczowe mechanizmy obronne

### 1. Network Policies (L3/L4 Firewall)
- **Problem**: "Flat network" wewnątrz klastra.
- **Rozwiązanie**: Zastosowanie polityk `NetworkPolicy`.
- **Demo**: W załączonym pliku `example-policies.yaml` pokazujemy podejście **Default Deny**, gdzie ruch jest blokowany domyślnie, a otwierane są tylko konkretne ścieżki (np. tylko `frontend` może rozmawiać z `backend` na porcie 8080).

### 2. Binary Authorization (Supply Chain Security)
- Mechanizm GKE, który pozwala na uruchamianie tylko podpisanych i zweryfikowanych obrazów kontenerów. Zapobiega to uruchomieniu złośliwego kodu przez nieautoryzowane osoby.

### 3. Workload Identity (IAM for Pods)
- Pody nie powinny używać statycznych kluczy JSON. Workload Identity pozwala przypisać tożsamość IAM bezpośrednio do Kubernetes Service Account.

## 🛠️ Jak wdrożyć Network Policies?
1. Upewnij się, że Twój klaster GKE ma włączony "Network Policy Add-on" (lub używasz Dataplane V2).
2. Zastosuj politykę `default-deny` dla każdego namespace'u.
3. Dodawaj selektywne reguły `allow` oparte na labelach (`podSelector`).

---
*Reference: [GKE Network Policies Documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/network-policies)*
