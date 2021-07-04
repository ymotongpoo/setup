# setup scripts

This script is for setting up Yoshi's development environments.

## Prerequisits

* Terraform: 1.0+
* Ansible: 4.2+ (2.11+)


## Execution

```console
terraform apply -auto-approve -target=google_compute_engine.<distribution>
```

`distribution` would either of them:

* debian10
* ubuntu2004
* arch