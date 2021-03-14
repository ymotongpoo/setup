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

control 'golang-installation' do
    impact 1.0
    title 'Go development environment'
    desc 'Go distribution should be installed'

    describe file('/home/demo/.go') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should cmp 'demo' }
    end

    describe file('/home/demo/go') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should cmp 'demo' }
    end

    describe file('/home/demo/.go/bin/go') do
        it { should exist }
        its('mode') { should cmp '0755' }
        its('owner') { should cmp 'demo' }
    end
end

control 'binary-installation' do
    impact 0.5
    title 'Binary files installed via tarball'
    desc 'The binaries should be installed under user bin directory'

    binaries = ['peco', 'hub', 'k6', 'hugo', 'vgrep']

    binaries.each do |binary|
        describe file('/home/demo/bin/'.concat(binary)) do
            it { should exist }
            its('mode') { should cmp '0755' }
        end
    end
end


