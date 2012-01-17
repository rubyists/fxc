require_relative '../directory_data'

describe 'FXC::Context' do
  it 'should always have a default context' do
    default = FXC::Context.default
    default.should.not.be.nil?
    default.name.should.equal "default"
  end

  it 'should always have a public context' do
    pub = FXC::Context.public
    pub.should.not.be.nil?
    pub.name.should.equal "public"
  end

  it "should list users in the context" do
    user = FXC::User.find_or_create(:username => "msfoo")
    FXC::Context.default.add_user(user).should.not.be.nil
    FXC::Context.default.users.map { |u| u.username }.should.include "msfoo"
  end

  it "should list DIDs in the context" do
    did = FXC::Did.find_or_create(:number => "8675309")
    FXC::Context.public.add_did(did).should.not.be.nil
    FXC::Context.public.dids.map { |n| n.number }.should.include "8675309"
  end
end
