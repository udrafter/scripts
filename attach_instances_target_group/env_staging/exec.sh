#!/bin/bash

echo "Attaching staging instances to target group 'target-group-test' ..."

instances=""
array=( cms-staging worker-staging )
for i in "${array[@]}"
do
  di_cmd="aws ec2 describe-instances --filters \"Name=tag:Name,Values=$i\" \
  --query \"Reservations[*].Instances[*].{instance_id: InstanceId}\" \
  --output json --region eu-west-2 --profile udrafter \
  | jq '.[0][0] | {insid: .instance_id}'"

  inst=$(eval "$di_cmd" | jq -r '.[]')
  instances+="Id=${inst} "
done

echo "Instances to attach: $instances"

rt_cmd="aws elbv2 register-targets \
--target-group-arn arn:aws:elasticloadbalancing:eu-west-2:333205879969:targetgroup/target-group-test/2d6e7b704bed5d46 \
--targets $instances --region eu-west-2 --profile udrafter"

z=$(eval "$rt_cmd")
echo $z

echo "Instances $instances attached to target group 'target-group-test'"