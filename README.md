inline_fixtures
==============

This adds a helper method to your tests so you can insert test records (fixtures) quickly and without fuss. Here's an example:


    describe Post do
      describe ".first" do
        it "should find the first post" do
          first_post_id = inline_fixture :posts, :body => "First post!",
                                                 :posted_at => "2013-01-15 23:08:12"
          second_post_id = inline_fixture :posts, :body => "Second post!",
                                                   :posted_at => "2013-01-15 23:10:53"

          Post.first.id.should == first_post_id
        end
      end
    end

That's a trivial example to give you a feel. The real benefit comes when you want to insert whole bunches of records quickly, e.g.:

    describe Report do

      describe ".last_3_months_revenue" do
        it "should return the revenue report" do
          inline_fixture :invoices, [:date, :amount, :account_id] do
            two_months_ago = 2.months.ago.to_s(:db)
            last_month     = 1.month.ago.to_s(:db)
            this_month     = Date.today.to_s(:db)
            acct_1_id      = inline_fixture(:accounts, :name => "Example Account 1")
            acct_2_id      = inline_fixture(:accounts, :name => "Example Account 2")
            acct_3_id      = inline_fixture(:accounts, :name => "Example Account 3")

            [
              [3.months.ago.to_s(:db), "14.00", acct_2_id],
              [two_months_ago, "27.00", acct_1_id],
              [two_months_ago, "88.00", acct_2_id],
              [two_months_ago, "104.00", acct_3_id],
              [last_month, "30.00", acct_1_id],
              [last_month, "120.00", acct_2_id],
              [last_month, "96.00", acct_3_id],
              [this_month, "63.00", acct_1_id],
              [this_month, "144.00", acct_2_id],
              [this_month, "103.00", acct_3_id]
              [1.months.from_now.to_s(:db), "29.00", acct_1_id],
            ]
          end
          Report.last_3_months_revenue.should == 775.0
        end
      end

    end

Granted this is still a pretty simple example, but the above would result in just 4 inserts, meaning it would be uber fast.