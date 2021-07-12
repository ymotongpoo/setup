#!/bin/bash
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

instances=$( gcloud compute instances list --filter="labels.process=template" --format="value(name)" )

if [ -n "$instances" ]; then
    for instance in ${instances};do
        gcloud compute instances delete --quiet ${instance} --zone=${ZONE}
    done
fi


firewalls=$( gcloud compute firewall-rules list --filter="name=dev-http" --format="value(name)" )

if [ -n "$firewalls" ]; then
    for firewall in ${firewalls};do
        gcloud compute firewall-rules delete --quiet ${firewall}
    done
fi