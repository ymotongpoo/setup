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

FROM python:3.9-slim-buster
ENV debian_packages \
  wget \
  unzip \
  openssh-client

ENV ansible_requirements \
  ansible>=4.2.0 \
  requests \
  google-auth

RUN apt-get update && apt-get install -y ${debian_packages}
RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py \
    && python3 get-pip.py && rm get-pip.py
COPY requirements.txt requirements.txt
RUN pip install ${ansible_requirements}
ENTRYPOINT ["/usr/local/bin/ansible-playbook"]