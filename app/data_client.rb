require "azure/storage/table"
=begin

At this time erb2slim is the only app I host that required redis. It seemed like overkill just to have a single redis db for a counter
so instead I setup tapped into azure storage account and made a table to hold total conversion count.

=end
class DataClient

    def initialize(storage_acc, access_key)
        @table_client = Azure::Storage::Table::TableService.create(storage_account_name: storage_acc, storage_access_key: access_key)
    end

    def get_count()
        query = { :filter => "PartitionKey eq 'counter'"}
        #ran into some edge case bug where get_entity() would fail, this was my workaround
        return @table_client.query_entities("erb2slim", query)[0].properties['value']
    end
    
    def incr_count()
        x = self.get_count() + 1
        entity = { "value" => x, :PartitionKey => "counter", :RowKey => "1" }
        @table_client.update_entity("erb2slim", entity)
        return x
    end
end