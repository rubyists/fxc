require_relative '../helper'

describe 'FXC::User' do
  @defaults = {
    extension: "1234",
    username: "fxc",
    first_name: "tj",
    last_name: "vanderpoel",
    password: "a+b3t4r;pvs6"
  }
  @auto_create_min = "1904"

  after do
    FXC::User.delete
  end

  it 'auto-assigns extension when none given' do
    u = FXC::User.create(:first_name => "tj")
    u.extension.should.equal @auto_create_min
  end

  it 'hashes password on assignment' do
    u = FXC::User.create(:username => "tj", :password => 'weak sauce')
    u.password.should.not.equal 'weak sauce'
    u.password.should.equal FXC::User.digestify('weak sauce')
  end

=begin
  it 'does not allow directly assigned extensions in the auto-populate range (<3176)' do
    lambda{
      FXC::User.create(:extension => "1800")
    }.should.raise(Sequel::ValidationFailed).
      message.should == "extension can not be directly assigned above 3175"
  end
=end

  it 'requires extension to be all digits' do
    lambda { FXC::User.create(:extension => "bougyman") }.should.raise(Sequel::ValidationFailed).
      message.should == "extension must be all digits, mailbox must be all digits"
  end

  it 'requires pin to be 4+ digits' do
    lambda { FXC::User.create(:extension => "1234", :pin => "foo") }.should.raise(Sequel::ValidationFailed).
      message.should.match /must be all digits \(4 minimum\)/
    lambda { FXC::User.create(:extension => "1234", :pin => 123) }.should.raise(Sequel::ValidationFailed).
      message.should.match /must be all digits \(4 minimum\)/
  end

  should 'not allow duplicate extension' do
    user = FXC::User.create(:extension => "1234")
    lambda { FXC::User.create(:extension => "1234") }.should.raise(Sequel::ValidationFailed).
      message.should.match /extension can not be duplicated/
  end

  should 'not allow duplicate username' do
    user = FXC::User.create(:extension => "1234", :username => 'crusty')
    lambda { FXC::User.create(:extension => 2234, :username => 'crusty') }.should.raise(Sequel::ValidationFailed).
      message.should.match /username can not be duplicated/
  end

  should 'be inactive upon initial creation' do
    user = FXC::User.create(:extension => "1234")
    user.active.should.be.false
  end

  it 'makes mailbox equal to extension if it is not specified' do
    user = FXC::User.create(:extension => "1234")
    user.mailbox.should.equal user.extension.to_s
  end

  should 'require mailbox to be all digits' do
    lambda { FXC::User.create(:extension => "1234", :mailbox => "foo") }.should.raise(Sequel::ValidationFailed).
      message.should.match /must be all digits/
  end

  should 'have a default dialstring when created' do
    user = FXC::User.create(@defaults)
    user.dialstring.should === "{presence_id=${dialed_user}@$${domain}}${sofia_contact(default/${dialed_user}@$${domain})}"
  end

  should 'add default user_variables when created' do
    user = FXC::User.create(@defaults)
    user.variables.size.should.equal 5
  end

  it 'creates a default route when a user is created' do
    user = FXC::User.create(@defaults)
    user.extensions.should.not.be.nil?
    user.extensions.size.should == 1
    ext = user.extensions.first
    ext.conditions.size.should == 1
    ext.conditions.first.actions.size.should == 6
    ext.conditions.first.actions[2].data.should == "user/#{user.extension}"
  end

  it 'sets the effective_caller_id to "first_name last_name"' do
    user = FXC::User.create(@defaults.merge(first_name: "Boe", last_name: "Jangles"))
    (caller_id_number = user.variables.detect { |n| n.name == "effective_caller_id_name" }).should.not.be.nil
    caller_id_number.value.should == "Boe Jangles"
  end

  it 'sets the effective_caller_id to fullname' do
    user = FXC::User.create(@defaults.merge(fullname: "Mister Boe Jangles"))
    (caller_id_number = user.variables.detect { |n| n.name == "effective_caller_id_name" }).should.not.be.nil
    caller_id_number.value.should == "Mister Boe Jangles"
  end

  it 'sets the user context to default upon creation' do
    user = FXC::User.new(:extension => "1234")
    user.context.should.be.nil
    user.save.reload.context.should.not.be.nil
    user.context.name.should.equal "default"
  end

  it 'allows multiple users (with usernames)' do
    user = FXC::User.create(:extension => 1191, :username => 'pete')
    user2 = FXC::User.create(:extension => 1192, :username => "frodo")
    FXC::User.all.size.should.equal 2
  end

  it 'allows multiple users (no usernames)' do
    user = FXC::User.create(:extension => 1191)
    user2 = FXC::User.create(:extension => 1199)
    FXC::User.all.size.should.equal 2
  end
end
