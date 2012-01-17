require_relative '../directory_data'

describe 'FXC::Provider' do
  it 'Should format a 10 digit number into a valid sofia url' do
    provider = FXC::Provider.new(:host => 'sip.vtwhite.com', :prefix => 1, :name => "VTWhite")
    provider.format("8179395222").should.equal "sofia/external/18179395222@sip.vtwhite.com"
  end

  it 'Should not format a non 10 digit number' do
    provider = FXC::Provider.new(:host => 'sip.vtwhite.com', :prefix => 1, :name => "VTWhite")
    provider.format("${sofia_contact(default/2600@$${domain})}").should.equal "${sofia_contact(default/2600@$${domain})}"
  end

end
