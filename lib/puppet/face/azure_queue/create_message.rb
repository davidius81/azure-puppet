# encoding: UTF-8
require 'tilt'

Puppet::Face.define :azure_queue, '1.0.0' do
  action :create_message do

    summary 'List SQL database servers.'
    arguments 'list'
    description <<-'EOT'
      The list action obtains a list of sql database servers and
      displays them on the console output.
    EOT

    Puppet::ServiceBus.add_create_message_options(self)

    when_invoked do |options|
      Puppet::ServiceBus.initialize_env_variable(options)
      azure_queue_service = Azure::QueueService.new
      azure_queue_service.create_queue(options[:queue_name])
      azure_queue_service.create_message(options[:queue_name], options[:queue_message])
    end

    returns 'Array of database server objets.'

    examples <<-'EOT'
      $ puppet azure_sqldb list --azure-subscription-id=YOUR-SUBSCRIPTION-ID \
        --management-certificate azure-certificate-path \
        --management-endpoint=https://management.database.windows.net:8443/

    Listing Servers

      Server: 1
        Server Name         : esinlp9bav
        Administrator login : puppet3
        Location            : West US

      Server: 2
        Server Name         : estkonosnv
        Administrator login : puppet
        Location            : West US

      Server: 3
        Server Name         : ezprthvj9w
        Administrator login : puppet
        Location            : West US

    EOT
  end
end