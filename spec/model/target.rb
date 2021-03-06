require_relative '../directory_data'

describe 'Target' do
  it 'Should change a users dialstring when we add a Target' do
    user = FXC::User[:extension => "1901"]
    user.dialstring.should == "{presence_id=${dialed_user}@$${domain}}${sofia_contact(default/${dialed_user}@$${domain})}"
    user.add_target(FXC::Target.new(:value => "user/1901"))
    user.dialstring.should == "user/1901"
  end

  it 'Should change a did dialstring when we add a Target' do
    user = FXC::User[:extension => "1901"]
    (did = user.dids.first).number.should.equal "1901"
    did.dialstring.should.equal user.dialstring
    did.add_target(FXC::Target.new(:value => "sofia/external/1234@sip.foo.com"))
    did.dialstring.should.equal "sofia/external/1234@sip.foo.com"
  end

end
