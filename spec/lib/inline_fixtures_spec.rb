require 'spec_helper'

module ActiveRecord
  class Base; end
end
class ExampleClass; end
ExampleClass.class.send(:include, InlineFixtures)


describe InlineFixtures do
  let(:ar_connection) { mock('ar_connection') }
  before do
    ActiveRecord::Base.stub(:connection).and_return(ar_connection)
  end
  describe "#inline_fixture" do
    context "when a hash is given" do
      it "should create and execute sql" do
        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (bar) VALUES ('quux')")
        ExampleClass.inline_fixture :foos, :bar => "quux"

        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (baz, bar) VALUES ('grault', 'quux')")
        ExampleClass.inline_fixture :foos, :baz => 'grault', :bar => "quux"
      end
    end
    context "when a block is given with column names" do
      it "should create and execute sql" do
        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (first, second, third, fourth, fifth, sixth) VALUES ('1', '2', '3', '4', '5', '6'), ('x', 'y', 'z', 'a', 'b', 'c'), ('word', 'word', 'word', 'word', 'word', 'word')")
        ExampleClass.inline_fixture :foos, [:first, :second, :third, :fourth, :fifth, :sixth] do
          [
            %w{1 2 3 4 5 6},
            %w{x y z a b c},
            %w{word word word word word word}
          ]
        end
      end
    end
    context "when a block is given without column names" do
      it "should create and execute sql" do
        ar_connection.should_receive(:insert_sql).with("INSERT INTO foos (sixth, second, third, fourth, first, fifth) VALUES ('6', '2', '3', '4', '1', '5'), ('c', 'y', 'z', 'a', 'x', 'b'), ('word', 'word', 'word', 'word', 'word', 'word')")
        ExampleClass.inline_fixture :foos do
          [
            {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :sixth => 6},
            {:first => 'x', :second => 'y', :third => 'z', :fourth => 'a', :fifth => 'b', :sixth => 'c'},
            {:first => 'word', :second => 'word', :third => 'word', :fourth => 'word', :fifth => 'word', :sixth => 'word'}
          ]
        end
      end
    end
  end
end