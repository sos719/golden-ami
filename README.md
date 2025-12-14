Repository For Golden AMI BuildPipeline

## Stages
1) BuildAMI (CodeBuild)
- dynamically selects latest Amazon Linux 2023 x86 base AMI
- launches builder EC2 in a public subnet
- patches/configures via SSM Run Command
- installs OpenSCAP tooling and SCAP Security Guide
- enables dnf-automatic (automatic updates)
- creates AMI and outputs ami_id.txt
- terminates builder instance

2) ValidateAMI (CodeBuild)
- launches validation EC2 from the new AMI
- validates marker + jq + dnf-automatic + OpenSCAP presence via SSM
- outputs validation_result.txt
- terminates validation instance

3) PublishAMI (CodeBuild)
- writes AMI ID to SSM Parameter Store (/golden-ami/latest)
- outputs publish_result.txt
