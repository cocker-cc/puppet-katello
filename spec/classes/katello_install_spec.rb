require 'spec_helper'

describe 'katello::install' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with enable_ostree == false' do
        let(:pre_condition) do
          ['include foreman',
           'include foreman::plugin::tasks',
           'include certs',
           "class {'katello':
              enable_ostree => false,
           }"
          ]
        end

        it { should_not contain_package("tfm-rubygem-katello_ostree")}
      end

      describe 'with enable_ostree == true' do
        let(:pre_condition) do
          ['include foreman',
           'include foreman::plugin::tasks',
           'include certs',
           "class {'katello':
              enable_ostree => true,
           }"
          ]
        end
        it { should contain_package("tfm-rubygem-katello_ostree").with_ensure('installed').
                                                                  with_notify(["Service[foreman-tasks]", "Service[httpd]", "Exec[foreman-rake-apipie:cache:index]"]) }
      end
    end
  end
end
