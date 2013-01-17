require "inline_fixtures/version"

module InlineFixtures
  def inline_fixture(table_name, data_or_columns=nil)

    if block_given? && data_or_columns
      columns = data_or_columns
      values = yield
    elsif block_given?
      data = yield
      columns = data.first.keys
      values = data.map(&:values)
    else
      columns = data_or_columns.keys
      values = [data_or_columns.values]
    end
    last_insert_id = ActiveRecord::Base.connection.insert_sql("INSERT INTO #{table_name} (#{columns.join(', ')}) VALUES ('#{values.map { |row_vals| row_vals.join("', '") }.join("'), ('")}')")
    auto_generated_ids = (last_insert_id..(last_insert_id+values.length-1)).to_a
    auto_generated_ids.length == 1 ? auto_generated_ids.first : auto_generated_ids
  end
end
