#!/bin/bash
#
# Copyright 2021 Yoshi Yamaguchi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

IAM_ACCOUNT="cloud-build-terraform-ansible@development-215403.iam.gserviceaccount.com"

keys=$( gcloud iam service-accounts keys list \
  --iam-account=${IAM_ACCOUNT} \
  --filter="key_type=USER_MANAGED" \
  --format="value(name)" )

if [ -n "$keys" ]; then
    for key in $keys; do
        gcloud iam service-accounts keys delete $key \
          --iam-account=${IAM_ACCOUNT} \
          --quiet
    done
fi

gcloud iam service-accounts keys create ansible-service-account.json \
  --iam-account=${IAM_ACCOUNT}