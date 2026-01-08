#!/bin/bash
set -e

########################################
# AWS IaC Lab 01 - Automated Test Script
# Author: NT548
########################################

echo "========== AWS IaC LAB01 TEST =========="

# ===== Pre-check =====
command -v terraform >/dev/null || { echo "[ERROR] terraform not found"; exit 1; }
command -v aws >/dev/null || { echo "[ERROR] aws cli not found"; exit 1; }

# ===== Config =====
REGION="ap-southeast-1"

# Move to terraform dev directory
cd ../terraform_lab01_full_tfvars/environments/dev

# ===== Read Terraform Outputs =====
VPC_ID=$(terraform output -raw vpc_id)
PUBLIC_SUBNET_ID=$(terraform output -raw public_subnet_id)
PRIVATE_SUBNET_ID=$(terraform output -raw private_subnet_id)
NAT_ID=$(terraform output -raw nat_gateway_id)
PUBLIC_EC2_ID=$(terraform output -raw public_ec2_id)
PRIVATE_EC2_ID=$(terraform output -raw private_ec2_id)

echo "[INFO] VPC ID           : $VPC_ID"
echo "[INFO] Public Subnet ID : $PUBLIC_SUBNET_ID"
echo "[INFO] Private Subnet ID: $PRIVATE_SUBNET_ID"
echo "[INFO] NAT Gateway ID   : $NAT_ID"
echo "[INFO] Public EC2 ID    : $PUBLIC_EC2_ID"
echo "[INFO] Private EC2 ID   : $PRIVATE_EC2_ID"

echo "---------------------------------------"

########################################
# TEST 1: VPC existence
########################################
echo "[TEST 1] VPC exists"
aws ec2 describe-vpcs \
  --vpc-ids "$VPC_ID" \
  --region "$REGION" >/dev/null
echo "PASS"

########################################
# TEST 2: Public Subnet auto-assign public IP
########################################
echo "[TEST 2] Public Subnet auto-assign public IP"

MAP_PUBLIC_IP=$(aws ec2 describe-subnets \
  --subnet-ids "$PUBLIC_SUBNET_ID" \
  --region "$REGION" \
  --query "Subnets[0].MapPublicIpOnLaunch" \
  --output text)

if [ "$MAP_PUBLIC_IP" = "True" ]; then
  echo "PASS"
else
  echo "FAIL (MapPublicIpOnLaunch = $MAP_PUBLIC_IP)"
  exit 1
fi

########################################
# TEST 3: Private EC2 has no public IP
########################################
echo "[TEST 3] Private EC2 has NO public IP"

PRIVATE_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$PRIVATE_EC2_ID" \
  --region "$REGION" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

if [ "$PRIVATE_PUBLIC_IP" = "None" ]; then
  echo "PASS"
else
  echo "FAIL (Private EC2 has public IP)"
  exit 1
fi

########################################
# TEST 4: NAT Gateway is available
########################################
echo "[TEST 4] NAT Gateway state"

NAT_STATE=$(aws ec2 describe-nat-gateways \
  --nat-gateway-ids "$NAT_ID" \
  --region "$REGION" \
  --query "NatGateways[0].State" \
  --output text)

if [ "$NAT_STATE" = "available" ]; then
  echo "PASS"
else
  echo "FAIL (NAT state = $NAT_STATE)"
  exit 1
fi

########################################
# TEST 5: Private EC2 Security Group isolation
########################################
echo "[TEST 5] Private EC2 Security Group isolation (no SSH from Internet)"

PRIVATE_SG_ID=$(aws ec2 describe-instances \
  --instance-ids "$PRIVATE_EC2_ID" \
  --region "$REGION" \
  --query "Reservations[0].Instances[0].SecurityGroups[0].GroupId" \
  --output text)

SSH_OPEN=$(aws ec2 describe-security-groups \
  --group-ids "$PRIVATE_SG_ID" \
  --region "$REGION" \
  --query "SecurityGroups[0].IpPermissions[?FromPort==\`22\`].IpRanges[?CidrIp=='0.0.0.0/0']" \
  --output text)

if [ -z "$SSH_OPEN" ]; then
  echo "PASS"
else
  echo "FAIL (SSH open to Internet)"
  exit 1
fi

########################################
# TEST 6: Terraform idempotency
########################################
echo "[TEST 6] Terraform idempotency (no changes expected)"

set +e
terraform plan -detailed-exitcode >/dev/null
PLAN_EXIT_CODE=$?
set -e

if [ "$PLAN_EXIT_CODE" -eq 0 ]; then
  echo "PASS"
elif [ "$PLAN_EXIT_CODE" -eq 2 ]; then
  echo "FAIL (Terraform plan has changes)"
  exit 1
else
  echo "FAIL (Terraform plan error)"
  exit 1
fi

