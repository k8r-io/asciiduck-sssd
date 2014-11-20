require 'spec_helper'
describe 'sssd' do
  ['Ubuntu1404'].each do |platform|
    context "on #{platform}" do
      defaults = Hash.new
      if platform.eql?('RHEL7')
        let(:facts) { {
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemmajrelease => '7',
          :operatingsystemrelease    => '7.0',
          :kernel                    => 'Linux',
          :fqdn                      => 'test.example.org',
        } }
        defaults[:package_name] = ['sssd','sssd-ldap']
        defaults[:package_ensure] = 'present'
        defaults[:config_path] = '/etc/sssd/sssd.conf'
        defaults[:config_owner] = 'root'
        defaults[:config_group] = 'root'
        defaults[:config_mode] = '0600'
        defaults[:service_name] = 'sssd'
        defaults[:service_ensure] = 'running'
        defaults[:service_enable] = true
      end
      if platform.eql?('Ubuntu1404')
        let(:facts) { {
          :osfamily                  => 'Debian',
          :operatingsystem           => 'Ubuntu',
          :operatingsystemmajrelease => '14.04',
          :operatingsystemrelease    => '14.04',
          :lsbdistrelease            => '14.04',
          :kernel                    => 'Linux',
          :fqdn                      => 'test.example.org',
        } }
        defaults[:package_name] = ['sssd','sssd-ldap']
        defaults[:package_ensure] = 'present'
        defaults[:config_path] = '/etc/sssd/sssd.conf'
        defaults[:config_owner] = 'root'
        defaults[:config_group] = 'root'
        defaults[:config_mode] = '0600'
        defaults[:service_name] = 'sssd'
        defaults[:service_ensure] = 'running'
        defaults[:service_enable] = true
      end
      describe 'with defaults for all parameters' do
        it do
          should compile 
          should contain_class('sssd')
          should contain_class('sssd::install')
          should contain_class('sssd::config')
          should contain_class('sssd::service')

          if defaults[:package_name].kind_of?(Array)
            defaults[:package_name].each do |p|
              should contain_package(p).with_ensure(defaults[:package_ensure])
            end
          else
            should contain_package(defaults[:package_name]).with_ensure(defaults[:package_ensure])
          end
          should contain_service(defaults[:service_name]).with( {
            :ensure => defaults[:service_ensure],
            :enable => defaults[:service_enable],
          } )
          should contain_file(defaults[:config_path]).with ( {
            :owner  => defaults[:config_owner],
            :group => defaults[:config_group],
            :mode  => defaults[:config_mode],
            :content => /This file is maintained by Puppet/
          } ) 
        end
      end
      ## Package overrides
      describe 'with package_name override' do
        ['package-string',['package','array']].each do |package_name|
          describe "equal #{package_name}" do 
            let(:params) { {
              :package_name  => package_name
            } }
            if package_name.kind_of?(Array)
              package_name.each do |p|
                it {should contain_package(p).with_ensure(defaults[:package_ensure])}
              end
            else
                it {should contain_package(package_name).with_ensure(defaults[:package_ensure])}
            end
          end
        end
        describe 'invalid' do
          let(:params) { {
            :package_name => {'name'=>'sssd-package'}
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with package_ensure override' do
        ['latest','absent','present','8.0'].each do |ensure_val|
          describe "equal #{ensure_val}" do 
            let(:params) { {
              :package_ensure  => ensure_val
            } }
            defaults[:package_name].each do |p|
              it {should contain_package(p).with_ensure(ensure_val)}
            end
          end
        end
        describe 'invalid' do
          let(:params) { {
            :package_ensure => ['invalid','array']
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with manage_package override' do
        describe 'equal false' do 
          let(:params) { {
            :manage_package  => false
          } }
          it { should have_package_count(0) }
        end
        describe 'invalid' do
          let(:params) { {
            :manage_package  => 'invalid'
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      # Config overrides
      describe 'with config_path override' do
        describe 'equals /foo/sssd.conf' do
          let(:params) { {
            :config_path => '/foo/sssd.conf'  
          } }
          it { should contain_file('/foo/sssd.conf').with ( {
            :owner  => defaults[:config_owner],
            :group => defaults[:config_group],
            :mode  => defaults[:config_mode],
          } ) }
        end
        describe 'equals foo/sssd.conf' do
          let(:params) { {
            :config_path => 'foo/sssd.conf'  
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with config_owner override' do
        describe 'equals foo-owner' do
          let(:params) { {
            :config_owner => 'foo-owner'  
          } }
          it { should contain_file(defaults[:config_path]).with ( {
            :owner  => 'foo-owner',
            :group => defaults[:config_group],
            :mode  => defaults[:config_mode],
          } ) }
        end
        describe 'equals an array ' do
          let(:params) { {
            :config_owner => ['foo','bar']  
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with config_group override' do
        describe 'equals foo-group' do
          let(:params) { {
            :config_group => 'foo-group'  
          } }
          it { should contain_file(defaults[:config_path]).with ( {
            :owner  => defaults[:config_owner],
            :group => 'foo-group',
            :mode  => defaults[:config_mode],
          } ) }
        end
        describe 'equals an array ' do
          let(:params) { {
            :config_group => ['foo','bar']  
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with config_mode override' do
        ['777','0777'].each do |config_mode|
          describe "equals #{config_mode}" do
            let(:params) { {
              :config_mode => config_mode
            } }
            it { should contain_file(defaults[:config_path]).with ( {
              :owner  => defaults[:config_owner],
              :group => defaults[:config_group],
              :mode  => config_mode,
            } ) }
          end
        end
        describe 'equals an 890' do
          let(:params) { {
            :config_mode => '890'
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with config_content override' do
        describe "equals 'Test content'" do
          let(:params) { {
            :config_content => 'Test content'
          } }
          it { should contain_file(defaults[:config_path]).with ( {
            :owner    => defaults[:config_owner],
            :group   => defaults[:config_group],
            :mode    => defaults[:config_mode],
            :content => 'Test content'
          } ) }
        end
        describe 'equals an array' do
          let(:params) { {
            :config_mode => ['one','two']
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with config_source override' do
        describe "equals puppet:///test-resources/sssd.conf" do
          let(:params) { {
            :config_source => 'puppet:///test-resources/sssd.conf'
          } }
          it { should contain_file(defaults[:config_path]).with ( {
            :owner    => defaults[:config_owner],
            :group   => defaults[:config_group],
            :mode    => defaults[:config_mode],
            :source  => 'puppet:///test-resources/sssd.conf',
            :content => ''
          } ) }
        end
        describe 'equals an array' do
          let(:params) { {
            :config_mode => ['one','two']
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with config_template override' do
        describe "equals test-resources/sssd.erb" do
          let(:params) { {
            :config_template => 'test-resources/sssd.erb'
          } }
          it { should contain_file(defaults[:config_path]).with ( {
            :owner    => defaults[:config_owner],
            :group   => defaults[:config_group],
            :mode    => defaults[:config_mode],
            :content => "Test template.\n"
          } ) }
        end
        describe 'equals an array' do
          let(:params) { {
            :config_mode => ['one','two']
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end

      # Service overrides
      describe 'with service_name override' do
        ['service-string',].each do |service_name|
          describe "equal #{service_name}" do 
            let(:params) { {
              :service_name  => service_name
            } }
            if service_name.kind_of?(Array)
              service_name.each do |p|
                it {should contain_service(p).with_ensure(defaults[:service_ensure])}
              end
            else
                it {should contain_service(service_name).with_ensure(defaults[:service_ensure])}
            end
          end
        end
        describe 'invalid' do
          let(:params) { {
            :service_name => ['sssd-service','other-service']
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with service_ensure override' do
        ['running','stopped'].each do |ensure_val|
          describe "equal #{ensure_val}" do 
            let(:params) { {
              :service_ensure  => ensure_val
            } }
            it {should contain_service(defaults[:service_name]).with_ensure(ensure_val)}
          end
        end
        describe 'invalid' do
          let(:params) { {
            :service_ensure => 'waffles'
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with service_enable override' do
        [true,false].each do |enable_val|
          describe "equal #{enable_val}" do 
            let(:params) { {
              :service_enable  => enable_val
            } }
            it {should contain_service(defaults[:service_name]).with_enable(enable_val)}
          end
        end
        describe 'invalid' do
          let(:params) { {
            :service_enable => 'waffles'
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      describe 'with manage_service override' do
        describe 'equal false' do 
          let(:params) { {
            :manage_service  => false
          } }
          it { should have_service_count(0) }
        end
        describe 'invalid' do
          let(:params) { {
            :manage_service  => 'invalid'
          } }
          it do
            expect {
              should compile
            }.to raise_error(Puppet::Error)
          end
        end
      end
      # application setting overrides
      describe 'with domain settings overrode:' do
        describe 'ldap domain without uri rotation' do
          let(:params) { {
            :domains => {
              'example' => {
                'id_provider' => 'ldap',
                'ldap_uri'    => ['ldap://ldap1.example.org','ldap://ldap2.example.org'],
              }
            }
          } }
          it do
            should contain_file(defaults[:config_path]).with_content(/ldap_uri = ldap:\/\/ldap1\.example\.org,ldap:\/\/ldap2\.example\.org/)
          end
        end
        describe 'ldap domain with uri rotation' do
          let(:params) { {
            :domains => {
              'example' => {
                'id_provider' => 'ldap',
                'ldap_uri'    => ['ldap://ldap1.example.org','ldap://ldap2.example.org'],
              }
            },
            :rotate_uris => true
          } }
          it do
            should contain_file(defaults[:config_path]).with_content(/ldap_uri = (?=.*ldap1\.example\.org)(?=.*ldap2\.example\.org)/)
          end
        end
      end
    end
  end
  context "on unsupported platform" do
    let(:facts) { {
      :osfamily                  => 'Windows',
      :operatingsystem           => 'Windows',
      :operatingsystemmajrelease => '3',
      :operatingsystemrelease    => '3.1',
      :kernel                    => 'Microsfot',
      :fqdn                      => 'test.example.org',
    } }
    describe 'with defaults for all parameters' do
      it do
        expect {
          should compile
        }.to raise_error(Puppet::Error, /unsupported os/i)
      end
    end
    describe 'with override_unsupported = true and values provided for everything' do
      let(:params) { {
        :override_unsupported => true,
        :manage_package       => true,
        :package_name         => 'foo',
        :package_ensure       => 'present',
        :manage_config        => true,
        :config_path          => '/foo.conf',
        :config_owner         => 'foo',
        :config_group         => 'foo',
        :config_mode          => '1234',
        :manage_service       => true,
        :service_name         => 'foo',
        :service_ensure       => 'running',
        :service_enable       => true,
      } }
      it { should compile }
    end
  end
end
