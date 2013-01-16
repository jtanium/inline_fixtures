require "inline_fixtures/version"

module InlineFixtures
  def self.included(othermod)
    puts "hello #{othermod}!"
  end
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
    ActiveRecord::Base.connection.insert_sql("INSERT INTO #{table_name} (#{columns.join(', ')}) VALUES ('#{values.map { |row_vals| row_vals.join("', '") }.join("'), ('")}')")
  end
end
