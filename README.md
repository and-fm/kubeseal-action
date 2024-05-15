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

Here is an example deploy.yaml file to generate a generic secret from some secrets.  
For generating a plain text insecure configmap, just pass your name value pairs into `configmap_env` instead of `secrets`

```yaml
name: Create a secret
on: workflow_dispatch
jobs:
  create_secret:
    name: Create secret
    runs-on: ubuntu-latest
    steps:
      - name: Generate secret via kubectl
        uses: and-fm/k8s-yaml-action@main
        id: gen
        with:
          name: test-secrets
          namespace: test-dev
          secrets: |-
            SECRET_1:${{ secrets.SECRET_1 }}
            SECRET_2:${{ secrets.SECRET_2 }}
      - name: get secrets
        run: |
          echo "${{ steps.gen.outputs.out_yaml }}"
```
