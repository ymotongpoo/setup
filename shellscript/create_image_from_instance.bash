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

machine_image_name="${DISTRIBUTION}-yoshifumi-image-${REVISION}"

exists=$(gcloud beta compute machine-images list \
  --filter="name=${machine_image_name}" \
  --format="value(name)" )

if [ -n "${exists}" ]; then
    gcloud beta compute machine-images delete ${machine_image_name} --quiet
fi

gcloud beta compute machine-images create ${machine_image_name} \
  --source-instance ${DISTRIBUTION}-template \
  --source-instance-zone ${ZONE}