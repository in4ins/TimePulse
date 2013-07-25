# == Schema Information
#
# Table name: projects
#
#  id          :integer(4)      not null, primary key
#  parent_id   :integer(4)
#  lft         :integer(4)
#  rgt         :integer(4)
#  client_id   :integer(4)
#  name        :string(255)     not null
#  account     :string(255)
#  description :text
#  clockable   :boolean(1)      default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#  billable    :boolean(1)      default(TRUE)
#  flat_rate   :boolean(1)      default(FALSE)
#


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do

  let :github_url do "https://github.com/Awesome/McAwesome" end
  let :pivotal_id do 12345 end

  let :root_project do Project.root end

  it "should create a new instance given valid attributes" do
    Factory(:project)
  end

  it "should require a name" do
    Factory.build(:project, :name => nil).should_not be_valid
  end

  describe "cascades" do
    describe "client" do
      before(:each) do
        @client = Factory(:client)
        @client2 = Factory(:client)
      end
      it "should return a project's client" do
        @leaf = Factory(:project, :client => @client)
        @leaf.client.should == @client
        @leaf.client_source.should == @leaf
      end
      it "should return a project's parent's client if the project has no client" do
        @parent = Factory(:project, :client => @client)
        @leaf = Factory(:project, :client_id => nil, :parent => @parent)
        @leaf.client_source.should == @parent
      end
      it "should return a project's grandparent's client if the project and parent have no client" do
        @grandparent = Factory(:project, :client => @client, :name => 'GP')
        @parent = Factory(:project, :parent => @grandparent, :client_id => nil, :name => "P")
        @project = Factory(:project, :client_id => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.client.should == @client
        @project.client_source.should == @grandparent
      end
      it "should return a project's parent's client if the project has no client and the grandparent has a different client" do
        @grandparent = Factory(:project, :client => @client)
        @parent = Factory(:project, :parent => @grandparent, :client => @client2)
        @project = Factory(:project, :client_id => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.client.should == @client2
        @project.client_source.should == @parent
      end
    end
    describe "account" do
      it "should return a project's client" do
        Factory(:project, :account => "account").account.should == "account"
      end
      it "should return a project's parent's client if the project has no client" do
        @parent = Factory(:project, :account => "account")
        Factory(:project, :account => nil, :parent => @parent).account.should == "account"
      end
      it "should return a project's grandparent's client if the project and parent have no client" do
        @grandparent = Factory(:project, :account => "account", :name => 'GP')
        @parent = Factory(:project, :parent => @grandparent, :account => nil, :name => "P")
        @project = Factory(:project, :account => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.account.should == "account"
      end
      it "should return a project's parent's client if the project has no client and the grandparent has a different client" do
        @grandparent = Factory(:project, :account => "account")
        @parent = Factory(:project, :parent => @grandparent, :account => "account2")
        @project = Factory(:project, :account => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.account.should == "account2"

        @grandparent.reload.descendants.should include(@parent)
        @grandparent.reload.descendants.should include(@project)
      end
    end
    describe "github_url" do
      it "should return a project's github URL" do
        Factory(:project, :github_url => github_url ).github_url.should == github_url
      end
      it "should return a project's parent's github URL if the project has no github URL" do
        @parent = Factory(:project, :github_url => github_url )
        Factory(:project, :github_url => nil , :parent => @parent).github_url.should == github_url
      end
      it "should return a project's grandparent's github URL if the project and parent have no github URL" do
        @grandparent = Factory(:project, :github_url => github_url, :name => 'GP')
        @parent = Factory(:project, :parent => @grandparent, :github_url => nil, :name => "P")
        @project = Factory(:project, :github_url => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.github_url.should == github_url
      end
      it "should return a project's parent's github URL if the project has no github URL  and the grandparent has a different github URL" do
        @grandparent = Factory(:project, :github_url => "https://github.com/Awesome/NotAwesome")
        @parent = Factory(:project, :parent => @grandparent, :github_url => github_url)
        @project = Factory(:project, :github_url => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.github_url.should == github_url

        @grandparent.reload.descendants.should include(@parent)
        @grandparent.reload.descendants.should include(@project)
      end
    end
    describe "pivotal_id" do
      it "should return a project's github URL" do
        Factory(:project, :pivotal_id => pivotal_id ).pivotal_id.should == pivotal_id
      end
      it "should return a project's parent's github URL if the project has no github URL" do
        @parent = Factory(:project, :pivotal_id => pivotal_id )
        Factory(:project, :pivotal_id => nil , :parent => @parent).pivotal_id.should == pivotal_id
      end
      it "should return a project's grandparent's github URL if the project and parent have no github URL" do
        @grandparent = Factory(:project, :pivotal_id => pivotal_id, :name => 'GP')
        @parent = Factory(:project, :parent => @grandparent, :pivotal_id => nil, :name => "P")
        @project = Factory(:project, :pivotal_id => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.pivotal_id.should == pivotal_id
      end
      it "should return a project's parent's github URL if the project has no github URL  and the grandparent has a different github URL" do
        @grandparent = Factory(:project, :pivotal_id => 54321)
        @parent = Factory(:project, :parent => @grandparent, :pivotal_id => pivotal_id)
        @project = Factory(:project, :pivotal_id => nil, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @grandparent, root_project ]
        @project.pivotal_id.should == pivotal_id

        @grandparent.reload.descendants.should include(@parent)
        @grandparent.reload.descendants.should include(@project)
      end
    end

    describe "rates" do
      before :each do
        @base = Factory(:project)
        @base_rate = Factory(:rate, :project => @base)
        @base.rates << @base_rate
      end

      it "should return a project's rates" do
        @base.rates.first.should == @base_rate
      end
      it "should return a project's parent's rates if the project has no rates" do
        Factory(:project, :account => nil, :parent => @base).rates.first.should == @base_rate
      end
      it "should return a project's grandparent's rates if the project and parent have no rates" do
        @base.name = 'GP'
        @parent = Factory(:project, :parent => @base, :name => "P")
        @project = Factory(:project, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @base, root_project ]
        @project.rates.first.should == @base_rate
      end
      it "should return a project's parent's rates if the project has no rates and the grandparent has different rates" do
        new_rate = Factory(:rate, :name => 'Rate 1')
        @parent = Factory(:project, :parent => @base)
        @parent.rates = [new_rate]
        @project = Factory(:project, :parent => @parent)
        @project.ancestors.reverse.should == [ @parent, @base, root_project ]
        @project.rates.first.should == new_rate

        @base.reload.descendants.should include(@parent)
        @base.reload.descendants.should include(@project)
      end
    end
  end


end
