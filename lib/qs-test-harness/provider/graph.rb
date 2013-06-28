module Qs::Test::Harness::Provider
  class Graph < Base
    def initialize(harness)
      require 'graph-backend'

      wipe_graph!
    end

    def app_class
      ::Graph::Backend::API
    end

    def wipe_graph!
      connection = ::Graph::Backend::Connection.create.neo4j
      (connection.find_node_auto_index('uuid:*') || []).each do |node|
        connection.delete_node!(node)
      end
    end
  end
end