require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Zendesk < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://test.zendesk.com',
        authorize_url: '/oauth/authorizations/new',
        token_url: '/oauth/tokens'
      }

      option :scopes

      def authorize_params
        super.tap do |params|
          if request.params['scope']
            params[:scope] = request.params[v]
          end
        end
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v2/users/me.json').parsed
      end

      uid { raw_info['user']['email'].to_s }

      info do
        u = raw_info['user']
        {
          'id' => u['id'],
          'name' => u['name'],
          'email' => u['email'],
          'role' => u['role'],
          'organization_id' => u['organization_id']
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end
    end
  end
end

OmniAuth.config.add_camelization 'zendesk', 'Zendesk'
