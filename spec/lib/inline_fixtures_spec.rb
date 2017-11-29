require 'spec_helper'

module ActiveRecord
  class Base; end
end
class ExampleClass; end
ExampleClass.class.send(:include, InlineFixtures)


describe InlineFixtures do
  let(:ar_connection) { double('ar_connection') }
  before do
    ActiveRecord::Base.stub(:connection).and_return(ar_connection)
    ar_connection.stub(:insert_sql).and_return(19)
  end
  describe "#inline_fixture" do
    context "when a hash is given" do
      it "should create and execute sql" do
        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (bar) VALUES ('quux')")
        ExampleClass.inline_fixture :foos, :bar => "quux"

        attributes = {:baz => 'grault', :bar => "quux"}
        key_list = attributes.keys.join(', ')
        value_list = "'#{attributes.values.join("', '")}'"
        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (#{key_list}) VALUES (#{value_list})")
        ExampleClass.inline_fixture :foos, attributes
      end
      it "should return the auto generated id" do
        ExampleClass.inline_fixture(:foos, :bar => "quux").should == 19
      end
    end
    context "when a block is given with column names" do
      let(:column_names) { [:first, :second, :third, :fourth, :fifth, :sixth] }
      let(:fixture_records) { [%w{1 2 3 4 5 6}, %w{x y z a b c}, %w{word word word word word word}] }
      it "should create and execute sql" do
        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (first, second, third, fourth, fifth, sixth) VALUES ('1', '2', '3', '4', '5', '6'), ('x', 'y', 'z', 'a', 'b', 'c'), ('word', 'word', 'word', 'word', 'word', 'word')")
        ExampleClass.inline_fixture(:foos, column_names) { fixture_records }
      end
      it "should return the auto generated ids" do
        ExampleClass.inline_fixture(:foos, column_names) { fixture_records }.should == [19, 20, 21]
      end
    end
    context "when a block is given without column names" do
      let(:attributes_1) { {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :sixth => 6} }
      let(:attributes_2) { {:first => 'x', :second => 'y', :third => 'z', :fourth => 'a', :fifth => 'b', :sixth => 'c'} }
      let(:attributes_3) { {:first => 'word', :second => 'word', :third => 'word', :fourth => 'word', :fifth => 'word', :sixth => 'word'} }
      let(:fixture_records) { [attributes_1, attributes_2, attributes_3] }
      it "should create and execute sql" do
        key_list = attributes_3.keys.join(', ')
        value_list = "'#{attributes_1.values.join("', '")}'), ('#{attributes_2.values.join("', '")}'), ('#{attributes_3.values.join("', '")}'"

        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (#{key_list}) VALUES (#{value_list})")
        ExampleClass.inline_fixture(:foos) { fixture_records }
      end
      it "should return the auto generated ids" do
        ExampleClass.inline_fixture(:foos) { fixture_records }.should == [19, 20, 21]
      end
    end
  end
end
