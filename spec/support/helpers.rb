module Helpers
  INDEX = 'rom-test'

  def db_options
    {url: 'http://localhost:9200', index: INDEX}
  end

  def reindex(connection)
    if connection.indices.exists?(index: INDEX)
      connection.indices.delete(index: INDEX)
    end
    connection.indices.create(index: INDEX)
  rescue
  end

  def drop_index(connection)
    connection.indices.delete(index: INDEX)
  rescue
  end

  def refresh(connection)
    connection.indices.refresh(index: INDEX)
  end

  def create_database(name)
  end

  def drop_database(name)
  end
end
