#!/bin/bash

echo "Attaching dev instances to target group 'tg-lb-development' ..."

instances=""
array=( cms-dev worker-dev )
for i in "${array[@]}"
do
  di_cmd="aws ec2 describe-instances --filters \"Name=tag:Name,Values=$i\" \
  --query \"Reservations[*].Instances[*].{instance_id: InstanceId}\" \
  --output json --region eu-west-2 \
  | jq '.[0][0] | {insid: .instance_id}'"  # add --profile udrafter if needed

  inst=$(eval "$di_cmd" | jq -r '.[]')
  instances+="Id=${inst} "
done

echo "Instances to attach: $instances"

rt_cmd="aws elbv2 register-targets \
--target-group-arn arn:aws:elasticloadbalancing:eu-west-2:333205879969:targetgroup/tg-lb-development/5dc5afcbae386a96 \
--targets $instances --region eu-west-2"  # add --profile udrafter if needed

z=$(eval "$rt_cmd")
echo $z

echo "Instances $instances attached to target group 'tg-lb-development'"