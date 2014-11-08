require 'spec_helper'

describe OmniAuth::Strategies::Zendesk do
  subject do
    OmniAuth::Strategies::Zendesk.new({})
  end

  context 'client options' do
    it 'should have correct site' do
      site = subject.options.client_options.site
      expect(site).to eq('https://test.zendesk.com')
    end

    it 'should let client override site' do
      strategy = OmniAuth::Strategies::Zendesk.new(
        'KEY', 'SECRET',
        client_options: { site: 'https://test2.zendesk.com' }
      )
      site = strategy.options.client_options.site
      expect(site).to eq('https://test2.zendesk.com')
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
