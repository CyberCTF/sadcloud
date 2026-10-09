# sadcloud

[sadcloud](https://github.com/nccgroup/sadcloud) by NCC Group: a tool for spinning up insecure
AWS infrastructure with Terraform, for training and for testing cloud auditing tools. This
repository runs a small, free subset of it with [Isoloom](https://www.isoloom.com) in your own
AWS account: [`isoloom.yml`](isoloom.yml) describes the cloud services, sadcloud sits unchanged
in [`app/`](app), and [`terraform/`](terraform) is a small wrapper that picks the findings.

| Cloud services | Findings |
| --- | --- |
| IAM | Wildcard admin policy, admin policy without "admin" in its name, PassRole on `*`, inline user, group and role policies with `NotAction`, a role any AWS principal may assume (with MFA) |
| S3 | A private bucket without default encryption, access logging or versioning |
| SQS | A queue without server-side encryption |

Cost: nothing billed by the hour (IAM, an empty bucket, an idle queue).

Left out on purpose: the account password policy (an account-wide setting that `down` would
delete), sadcloud's world-open SNS topic, SQS queue and S3 buckets (anyone could use them while
the lab runs), and every service billed by the hour (EC2, RDS, Redshift, EKS, load balancers).

## Run it

Use an AWS account with nothing else in it, signed in with the AWS CLI (`aws login`), and
Terraform installed.

```bash
isoloom run cloud-services
isoloom test cloud-services
isoloom down cloud-services
```

Then audit the account with [ScoutSuite](https://github.com/nccgroup/ScoutSuite),
[Prowler](https://github.com/prowler-cloud/prowler) or the AWS CLI. Upstream's sample reports:
[app/README.md](app/README.md).

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

AGPL-3.0, as sadcloud ([LICENSE](LICENSE)). Source offer: the complete corresponding source of
sadcloud as this lab runs it is in [`app/`](app), unchanged, and upstream at the commit named in
[UPSTREAM.md](UPSTREAM.md); this lab's own files (the spec, the wrapper, the checks) are in this
repository under the same licence. This lab is deliberately insecure: deploy it only in an
account you use for nothing else, and destroy it when you are done.
