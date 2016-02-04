require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_role) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage roles an WebLogic Secuirty Realm.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_role' }
      wlst template('puppet:///modules/orawls/providers/wls_role/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      Puppet.info "create #{name}"
      template('puppet:///modules/orawls/providers/wls_role/create.py.erb', binding)
    end

    on_modify do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_role/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_role/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :role_name
    parameter :timeout
    property :realm
    property :expression

    add_title_attributes(:role_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
