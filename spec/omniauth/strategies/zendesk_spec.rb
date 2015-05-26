require 'spec_helper'

describe OmniAuth::Strategies::Zendesk do
  subject do
    OmniAuth::Strategies::Zendesk.new({})
  end

  context '#zendesk_url' do

    it "defaults to the 'test' subdomain" do
      allow(subject).to receive(:request).and_return(OpenStruct.new(params: {}))
      allow(subject).to receive(:session).and_return({})
      expect(subject.zendesk_url).to eq("https://test.zendesk.com")
    end

    it "overrides the site with client_options" do
      subject = OmniAuth::Strategies::Zendesk.new(
        'KEY', 'SECRET',
        client_options: { site: 'https://test2.zendesk.com' }
      )
      allow(subject).to receive(:request).and_return(OpenStruct.new(params: {}))
      allow(subject).to receive(:session).and_return({})
      expect(subject.zendesk_url).to eq("https://test2.zendesk.com")
    end

    it "overrides the site with a request parameter" do
      subject.options.client_options.site
      allow(subject).to receive(:session).and_return({})
      allow(subject).to receive(:request) do
        double("Request", :params => {"subdomain" => "testsite"})
      end
      expect(subject.zendesk_url).to eq('https://testsite.zendesk.com')
    end
  end

  context 'info' do
    before do
      allow(subject).to receive(:raw_info).and_return(
        'user' => {
          'email' => 'test@test.org',
          'id' => 123,
          'name' => 'Marty McFly',
          'role' => 'admin',
          'organization_id' => 456
        }
      )
    end

    it 'returns the email as uid' do
      expect(subject.uid).to eq 'test@test.org'
    end

    context 'puts all the info in the info hash' do
      it {expect(subject.info).to have_key 'name'}
      it {expect(subject.info).to have_key 'id'}
      it {expect(subject.info).to have_key 'email'}
      it {expect(subject.info).to have_key 'role'}
      it {expect(subject.info).to have_key 'organization_id'}
    end
  end

end
