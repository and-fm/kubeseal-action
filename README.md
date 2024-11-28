# Kubeseal Action

Encrypts k8s secrets with your sealed secrets public key

## Inputs

The following inputs can be used as `step.with` keys:

| Name           | Type   | Default | Required | Description                           |
| -------------- | ------ | ------- | -------- | ------------------------------------- |
| `pem_url`      | String |         | `true`   | URL of your sealed secrets public key |
| `secrets_yaml` | List   |         | `true`   | The input secret yaml to seal         |

## Outputs

The following outputs can be accessed with steps.\<step-id\>.outputs.out_yaml :

| Name       | Type     | Description                      |
| ---------- | -------- | -------------------------------- |
| `out_yaml` | K8s Yaml | The resulting sealed secret yaml |

## Workflows

Branch protection rules require a PR before code can be merged into _main_. There are two PR workflows:

- Dependency review will check upstream base Apline Linux image or Github Actions for updates. If there are High or Critical vulnerabilities found in feature branch, the workflow will fail.
- [Trivy scanner](https://github.com/aquasecurity/trivy) will check the built Docker image for vulnerabilities. If there's a High or Critical CVEs found in the image, the workflow will fail.

A successful merge into _main_ will update the _latest_ release and update the _latest_ tagged container image uploaded to GitHub Packages.

## Contributions

Any help keeping this repo healthy and secure would be appreciated! \
Remaining in the to-do is automating semantic version releases in case users need to rollback to older, stable versions.

## Usage

Here is an example deploy.yaml file to generate a generic sealed secret from some Github secrets.

```yaml
name: Create a secret
on: workflow_dispatch
jobs:
  create_secret:
    name: Create secret
    runs-on: ubuntu-latest
    steps:
      - name: Generate secrets
        uses: and-fm/k8s-yaml-action@main
        id: gen-secret
        with:
          name: ${{ env.SECRET_NAME }}-secret
          namespace: cluster-dev
          secrets: |-
            secret:${{ secrets.BIG_SECRET }}
            secret2:${{ secrets.BIG_SECRET2 }}
      - name: Seal secrets
        uses: and-fm/kubeseal-action@main
        id: seal-secret
        with:
          pem_url: https://cluster.com/v1/cert.pem
          secrets_yaml: ${{ steps.gen-secret.outputs.out_yaml }}
      - name: get secrets
        run: |
          echo "${{ steps.seal-secret.outputs.out_yaml }}"
```
