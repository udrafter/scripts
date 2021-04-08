# Attach instances to Target Group script

This script attach instances to load balancer target group to allow the correct behaviour of the load balancer.

The reason to implement this script is the need to switch off the installations outside working hours in order to save costs.

When these instances are restored first thing in the morning, the target groups do not have the restored instances associated with them, so it is necessary to re-assign them.

The operation is very simple, you use the AWS CLI commands to retrieve the instance identifiers for the 'development' environment on the one hand and those for the 'staging' environment on the other hand. Once these identifiers are available, the instruction is executed to associate these identifiers to the corresponding target group (development or staging).

This script runs as a recurring task on the 'Bastion Host' machine, with the following recurring task definition:

```sh
crontab -l
```
```sh
# Output
00 6 * * 1-5 ./scripts/attach_instances_target_group/env_staging/exec.sh
00 6 * * 1-5 ./scripts/attach_instances_target_group/env_development/exec.sh
```

It runs from Monday to Friday at 06:00 UTC. Instances are switched off from Monday to Friday at 17:00 UTC and are switched off on the same days at 05:45 UTC.

To be able to connect to 'Bastion Host', check in the AWS console panel 'EC2/Instances' how to connect to this machine via SSH.

If the instances are already associated to the target group, no change takes place.

## Set permissions

```sh
chmod +x env_development/exec.sh
chmod +x env_staging/exec.sh
```

## Execute

```sh
./env_development/exec.sh
./env_staging/exec.sh
```