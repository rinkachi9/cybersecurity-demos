# Evidence: GKE Security

## Expected Evidence

- `kubectl` output showing default-deny and allow policies.
- Connectivity test results between frontend and backend pods.
- mTLS status from service mesh tooling.
- Admission denial sample for unsigned workloads, once Binary Authorization is added.

## Do Not Commit

- Cluster credentials.
- Kubeconfig files.
- Raw pod logs containing secrets.

