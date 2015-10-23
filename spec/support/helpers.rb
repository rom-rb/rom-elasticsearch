module Helpers
  INDEX = 'rom-test'

  def db_options
    {url: 'http://localhost:9200', index: INDEX}
  end

  def create_index(connection)
    if connection.indices.exists?(index: INDEX)
      connection.delete_by_query(index: INDEX, body: {query: {match_all: {}}})
    else
      connection.indices.create(index: INDEX)
    end
  rescue
  end

  def refresh_index(connection)
    connection.indices.refresh(index: INDEX)
  end
end
