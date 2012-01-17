require_relative '../directory_data'

describe 'Did' do
  it 'should have a DID' do
    did = FXC::Did[:number => "1901"]
    did.description.should == "Inbound DID Test"
  end

  it 'should have a relationship to a user' do
    did = FXC::Did[:number => "1901"]
    user = did.user
    user.class.should == FXC::User
  end

  it "should use a user's default dialstring if it has no targets" do
    did = FXC::Did[:number => "1901"]
    did.dialstring.should == "{presence_id=${dialed_user}@$${domain}}${sofia_contact(default/${dialed_user}@$${domain})}"
  end

  it "should change dialstring if it has a target" do
    did = FXC::Did[:number => "1901"]
    did.add_target(FXC::Target.new(:value => "sofia/default/8675309@127.0.0.1"))
    did.dialstring.should == "sofia/default/8675309@127.0.0.1"
  end

  it 'should set the did context to public upon creation' do
    did = FXC::Did.new(:number => "1112223311")
    did.context.should.be.nil
    did.save.reload.context.should.not.be.nil
    did.context.name.should.equal "public"
  end

end
