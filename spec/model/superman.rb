require_relative '../db_helper'

describe 'FXC::User' do
  should "not have superman powers for normal users" do
    user = FXC::User.find_or_create(username: 'mrbar')
    user.superman.should == false
  end

  it "can grant superman powers" do
    user = FXC::User.find_or_create(username: 'mrfoo', superman: true)
    user.superman.should == true
  end
end
