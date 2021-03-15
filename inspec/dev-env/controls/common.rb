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

control 'base-configuration' do
    impact 1.0
    title 'Personal directory settings'
    desc 'Fundamental configurations for core development workspaces'

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
    desc 'Python development environment should be configured as venv'

    describe file('/home/demo/python') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
    end

    describe command('/home/demo/python/misc/bin/python -V') do
        its('stdout') { should match (/Python 3.[0-9\.]+/) }
    end
end


control 'gcloud-installation' do
    impact 1.0
    title 'gcloud installation'
    desc 'gcloud command should be installed and properly configured'



    describe file('/home/demo/.google-cloud-sdk') do
        it { should exist }
        it { should be_directory }
    end

    describe file('/home/demo/.google-cloud-sdk/bin/gcloud') do
        it { should exist }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
    end

    gcloud_version_output = /
    Google\ Cloud\ SDK\ [0-9\.]+\n
    alpha\ [0-9\.]+\n
    app-engine-go\ [0-9\.]+\n
    app-engine-python\ [0-9\.]+\n
    app-engine-python-extras\ [0-9\.]+\n
    beta\ [0-9\.]+\n
    bq\ [0-9\.]+\n
    cloud-datastore-emulator\ [0-9\.]+\n
    core\ [0-9\.]+\n
    gsutil\ [0-9\.]+\n
    kubectl\ [0-9\.]+\n
    kustomize\ [0-9\.]+\n
    skaffold\ [0-9\.]+
    /x
    describe command('/home/demo/.google-cloud-sdk/bin/gcloud version') do
        its('stdout') { should match (gcloud_version_output) }
    end
end


control 'node-intallation' do
    impact 0.8
    title 'Node.js installation'
    desc 'Node.js and its relevant packages should be installed'

    describe file('/home/demo/.nodenv') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
    end

    describe file('/home/demo/.nodenv/plugins/node-build') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
    end

    describe command('/home/demo/.nodenv/bin/nodenv version') do
        its('stdout') { should match (/[0-9\.]+ \(set by \/home\/demo\/\.nodenv\/version\)/) }
    end

    describe command('/home/demo/.nodenv/shims/node -v') do
        its('stdout') { should match (/v[0-9\.]+/) }
    end
end

control 'jvm-installation' do
    impact 0.8
    title 'JVM installation'
    desc 'Java Virtiual Machine and JVM languagees should be installed'

    java_version = '15'
    describe file(format('/opt/openjdk/%s', java_version)) do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
    end

    describe command(format('/opt/openjdk/%s/bin/java --version', java_version)) do
        its('stdout') { should match (/openjdk [0-9\.]+ [0-9\-]+/) }
    end

    describe file('/opt/kotlin') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
    end

    describe command('/opt/kotlin/bin/kotlinc -version') do
        its('stdout') { should match (/Kotlin\/Native: [0-9\.]+/) }
    end
end

control 'ruby-installation' do
    impact 0.5
    title 'Ruby installation'
    desc 'Ruby and its relevant packages should be installed'

    describe file('/home/demo/.rbenv') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
    end

    describe file('/home/demo/.rbenv/plugins/ruby-build') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
    end

    describe command('/home/demo/.rbenv/bin/rbenv version') do
        its('stdout') { should match (/[0-9\.]+ \(set by \/home\/demo\/\.rbenv\/version\)/) }
    end

    describe command('/home/demo/.rbenv/shims/ruby -v') do
        its('stdout') { should match (/ruby [0-9\.p]+/) }
    end
end

control 'rust-installation' do
    impact 0.5
    title 'Rust installation'
    desc 'Rust development environment should be set'

    describe file('/home/demo/.cargo') do
        it { should exist }
        it { should be_directory }
        its('mode') { should cmp '0755' }
        its('owner') { should eq 'demo' }
    end

    describe command('/home/demo/.cargo/bin/rustc -V') do
        its('stdout') { should match (/rustc [0-9\.]+ \(\w+ [0-9\-]+\)/) }
    end

    describe command('/home/demo/.cargo/bin/rustup -V') do
        its('stdout') { should match (/rustup [0-9\.]+ \(\w+ [0-9\-]+\)/) }
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

control 'systemd-configuration' do
    impact 1.0
    title 'Systemd configurations'
    desc 'Systemd service should be configured'

    describe systemd_service('docker') do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
    end

    describe systemd_service('containerd') do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
    end
end