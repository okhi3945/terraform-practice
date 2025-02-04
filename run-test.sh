#!/bin/bash

curl $(terraform output -raw alb_dns_name)
rc=$?

if [ $rc == 0 ]; then
  echo "success"
fi
