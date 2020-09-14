require 'spec_helper'

describe 'auditbeat', 'type' => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile }
      it { is_expected.to create_class('auditbeat') }
      it { is_expected.to create_class('auditbeat::install') }
      it { is_expected.to create_class('auditbeat::config') }
      it { is_expected.to create_class('auditbeat::service') }
      describe 'with ensure present' do
        let(:params) { { 'ensure' => 'present' } }

        it do
          is_expected.to contain_package('auditbeat').with(
            'ensure' => 'present',
          )
        end
      end
      describe 'with ensure absent' do
        let(:params) { { 'ensure' => 'absent' } }

        it do
          is_expected.to contain_package('auditbeat').with(
            'ensure' => 'absent',
          )
          is_expected.to contain_service('auditbeat').with(
            'ensure' => 'stopped',
            'enable' => false,
          )
        end
      end
      describe 'with version 7.5.1' do
        let(:params) { { 'package_ensure' => '7.5.1' } }

        it do
          is_expected.to contain_package('auditbeat').with(
            'ensure' => '7.5.1',
          )
        end
      end
      describe 'with disable_configtest false and file permission 0600' do
        let(:params) { { 'disable_configtest' => false, 'config_file_mode' => '0600' } }

        it do
          is_expected.to contain_file('/etc/auditbeat/auditbeat.yml').with(
            'ensure' => 'present',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0600',
            'validate_cmd' => '/usr/share/auditbeat/bin/auditbeat test config -c %',
          )
        end
      end
      describe 'with disable_configtest true' do
        let(:params) { { 'disable_configtest' => true } }

        it do
          is_expected.to contain_file('/etc/auditbeat/auditbeat.yml').with(
            'ensure' => 'present',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
            'validate_cmd' => nil,
          )
        end
      end
      describe 'with service enabled' do
        let(:params) { { 'ensure' => 'present', 'service_ensure' => 'enabled' } }

        it do
          is_expected.to contain_service('auditbeat').with(
            'ensure' => 'running',
            'enable' => true,
          )
        end
      end
      case os
      when %r{centos-7-|redhat-7-}
        describe 'with manage_repo true on RedHat family' do
          let(:params) { { 'ensure' => 'present', 'manage_repo' => true } }

          it do
            is_expected.to contain_yumrepo('beats').with(
              'ensure' => 'present',
              'baseurl' => 'https://artifacts.elastic.co/packages/7.x/yum',
              'gpgkey' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            )
          end
        end
      when %r{sles-12-}
        describe 'with manage_repo true on SLES family' do
          let(:params) { { 'ensure' => 'present', 'manage_repo' => true } }

          it do
            is_expected.to contain_zypprepo('beats').with(
              'enabled' => 1,
              'autorefresh' => 1,
              'gpgcheck' => 1,
              'name' => 'beats',
              'type' => 'yum',
              'baseurl' => 'https://artifacts.elastic.co/packages/7.x/yum',
              'gpgkey' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            )
          end
        end
      when %r{debian-9-|ubuntu-16.04-}
        describe 'with manage_repo true on Debian family' do
          let(:params) { { 'ensure' => 'present', 'manage_repo' => true } }

          it do
            is_expected.to contain_apt__source('beats').with(
              'ensure' => 'present',
              'location' => 'https://artifacts.elastic.co/packages/7.x/apt',
              'release' => 'stable',
              'repos' => 'main',
              'key' => {
                'id' => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
                'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
              },
            )
          end
        end
      end
    end
  end
end
