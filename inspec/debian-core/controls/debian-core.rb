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

title "debian controls"

control 'apt-installation' do
    impact 1.0
    title 'apt installation check'
    desc 'apt configurations should properly be set and install required packages'

    # repositories = [
    #     'https://download.docker.com/linux/debian',
    #     'https://apt.releases.hashicorp.com',
    # ]

    # repositories.each do |r|
    #     describe apt(r) do
    #         it { should exist }
    #         it { should be_enabled }
    #     end
    # end

    packages = [
        'apt-transport-https',
        'ca-certificates',
        'gnupg',
        'gnupg-agent',
        'wget',
        'curl',
        'unzip',
        'software-properties-common',
        'git',
        'zsh',
        'build-essential',
        'libssl-dev',
        'zlib1g-dev',
        'libbz2-dev',
        'libreadline-dev',
        'libffi-dev',
        'emacs',
        'vim',
        'python3',
        'python3-pip',
        'python3-venv',
        'tmux',
        'jq',
        'fzf',
        'fd-find',
        'silversearcher-ag',
        'sysstat',
        'htop',
        'atop',
        'nethogs',
        'vnstat',
        'nmon',
        'xclip',
        'docker-ce',
        'docker-ce-cli',
        'containerd.io',
        'ctop',
        'terraform',
        'hub',
    ]

    packages.each do |p|
        describe package(p) do
            it { should be_installed }
        end
    end

    packages_should_not_be_installed = [
        'docker',
        'docker-engine',
        'docker.io',
        'containerd',
        'runc',
    ]

    packages_should_not_be_installed.each do |p|
        describe package(p) do
            it { should_not be_installed }
        end
    end
end