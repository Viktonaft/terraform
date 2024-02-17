#!/bin/bash

# Отримання key_name з вхідних даних
INPUT=$(cat)
KEY_NAME=$(echo $INPUT | jq -r .key_name)
REGION=$(echo "$INPUT" | jq -r .region)

# Перевірка існування ключа
if aws ec2 describe-key-pairs --region "$REGION" --key-names "$KEY_NAME" &>/dev/null; then
  echo "{\"exists\":\"true\"}"
else
  echo "{\"exists\":\"false\"}"
fi