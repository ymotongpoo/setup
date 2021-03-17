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

control 'user-setting' do
    impact 1.0
    title 'Check user setting'
    desc 'Check user config should be properly set'

    describe user('demo') do
        it { should exist }
        its('home') { should eq '/home/demo' }
        its('shell') { should eq '/usr/bin/zsh' }
    end

    describe user('root') do
        it { should exist }
        its('home') { should eq '/root' }
        its('shell') { should eq '/bin/bash' }
    end
end

include_controls 'debian-core'
include_controls 'common'
