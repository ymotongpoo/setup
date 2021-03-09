desribe file('/home/demo/bin/peco') do
    it { should exist }
    its('mode') { should cmp '0755' }
end