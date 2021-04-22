#!/bin/bash

echo "Attaching staging instances to target group 'target-group-test' ..."

instances=""
array=( cms-staging worker-staging )
for i in "${array[@]}"
do
  di_cmd="aws ec2 describe-instances --filters \"Name=tag:Name,Values=$i\" \
  --query \"Reservations[*].Instances[*].{instance_id: InstanceId}\" \
  --output json --region eu-west-2 \
  | jq '.[0][0] | {insid: .instance_id}'"  # add --profile udrafter if needed

  inst=$(eval "$di_cmd" | jq -r '.[]')
  instances+="Id=${inst} "


  # get security group id attached to instance
  gi_cmd="aws ec2 describe-instances --filters \"Name=tag:Name,Values=$i\" \
  --query \"Reservations[*].Instances[*].SecurityGroups[*].{group_id: GroupId}\" \
  --output json --region eu-west-2 \
  | jq '.[][][] | {grid: .group_id}'"  # add --profile udrafter if needed

  gi=$(eval "$gi_cmd" | jq -r '.[]')
  echo "security group $gi for instance $inst"

  # attach SSH-from-Bastion-host security group to instance
  at_sg_ins_cmd="aws ec2 modify-instance-attribute --instance-id $inst \
  --groups $gi sg-0f2354b56f41e2f30 sg-0b658e69fa5b63291 --region eu-west-2" # --profile udrafter

  at_sg_ins=$(eval "$at_sg_ins_cmd")
  echo "Attached SSH-from-Bastion-host to instance $inst"
done

echo "Instances to attach: $instances"

rt_cmd="aws elbv2 register-targets \
--target-group-arn arn:aws:elasticloadbalancing:eu-west-2:333205879969:targetgroup/target-group-test/2d6e7b704bed5d46 \
--targets $instances --region eu-west-2" # add --profile udrafter if needed

z=$(eval "$rt_cmd")
echo $z

echo "Instances $instances attached to target group 'target-group-test'"