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

title "common control"

control 'common-configuration' do
    impact 1.0
    title 'Personal directory settings'

    items = [
        { path: '/home/demo/personal', mode: '0644', isdir: true },
        { path: '/home/demo/.gitconfig', mode: '0600', isdir: false },
        { path: '/home/demo/.gitconfig.personal', mode: '0600', isdir: false},
        { path: '/home/demo/.ssh/config', mode: '0600', isdir: false },
        { path: '/home/demo/.config', mode: '0755', isdir: false },
        { path: '/home/demo/.dotfiles', mode: '0755', isdir: true },
    ]

    items.each do |item|
        describe file(item[:path]) do
            it { should exist }
            if item[:isdir] then
                it { should be_directory }
            end
            its('mode') { should cmp item[:mode] }
        end
    end
end

control 'golang-installation' do
    impact 1.0
    title 'Go development environment'
    desc 'Go distribution should be installed'

    describe file('/home/demo/.go') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
        its('group') { should eq 'demo' }
    end

    describe file('/home/demo/go') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
        its('group') { should eq 'demo' }
    end

    describe file('/home/demo/go/bin/go') do
        it { should exist }
        its('mode') { should cmp '0755' }
        its('owner') { should cmp 'demo' }
    end

    describe command('/home/demo/go/bin/go version') do
        its('stdout') { should match (/go version go[1-9\.]+ linux\/amd64/) }
    end

    commands = ['dlv', 'lazydocker']
    commands.each do |command|
        describe file('/home/demo/.go/bin/'.concat(command)) do
            it { should exist }
            its('mode') { should cmp '0755' }
            its('owner') { should cmp 'demo' }
        end
    end
end

control 'python-installation' do
    impact 1.0
    title 'Python development environment'

    describe file('/home/demo/python') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
    end

    describe command('/home/demo/python/misc/bin/python -V') do
        its('stdout') { should match (/Python 3.[1-9\.]+/) }
    end
end

control 'binary-installation' do
    impact 0.5
    title 'Binary files installed via tarball'
    desc 'The binaries should be installed under user bin directory'

    binaries = ['peco', 'k6', 'hugo', 'vgrep']

    binaries.each do |binary|
        describe file('/home/demo/bin/'.concat(binary)) do
            it { should exist }
            its('mode') { should cmp '0755' }
        end
    end
end


