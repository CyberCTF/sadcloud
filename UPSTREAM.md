# Upstream

| | |
| --- | --- |
| Project | sadcloud |
| Repository | https://github.com/nccgroup/sadcloud |
| Version | master (no releases) |
| Commit | f538652921a7f3e8e25c0afaecad2d4382f8b21e |
| Licence | AGPL-3.0 |

`app/` is that commit, unchanged, without its Git history: the complete source of sadcloud as
this lab runs it. `terraform/main.tf` is this lab's own wrapper root module: it applies three of
sadcloud's service modules (`app/modules/aws/iam`, `s3`, `sqs`) with individual findings switched
on, instead of upstream's root `app/sadcloud/`, which only switches whole services on and would
include the account password policy and world-open resources. To update, replace `app/` with a
newer commit and change this table.
