#!/bin/sh
# A sample of the planted misconfigurations is there: the inline-policy user, the wildcard policy,
# the role any AWS principal may assume, and the unencrypted SQS queue.
set -eu
aws iam get-user --user-name sadcloudInlineUser --query User.UserName --output text >/dev/null
aws iam list-policies --scope Local --query "Policies[?starts_with(PolicyName, 'wildcard_IAM_policy')].PolicyName" \
  --output text | grep -q wildcard_IAM_policy
aws s3api head-bucket --bucket "$ISOLOOM_OUTPUT_BUCKET"
url=$(aws sqs get-queue-url --queue-name sadcloud --query QueueUrl --output text)
sse=$(aws sqs get-queue-attributes --queue-url "$url" --attribute-names KmsMasterKeyId --query 'Attributes.KmsMasterKeyId' --output text)
[ "$sse" = "None" ] || { echo "the queue is encrypted with $sse" >&2; exit 1; }
