# Evidence: GKE Service Mesh Security

## Expected Evidence

- PeerAuthentication set to strict mTLS.
- AuthorizationPolicy enforcing allowed service paths.
- Test traffic showing allowed and denied calls.
- Mesh status output from the test cluster.

## Do Not Commit

- Kubeconfig files.
- Service account tokens.
- Raw production pod logs.

