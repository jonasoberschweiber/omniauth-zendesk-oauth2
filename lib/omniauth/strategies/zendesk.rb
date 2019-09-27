require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Zendesk < OmniAuth::Strategies::OAuth2
      option :client_options, {
        authorize_url: '/oauth/authorizations/new',
        token_url:     '/oauth/tokens'
      }

      option :scope, "read"
      option :subdomain, "test"

      def authorize_params
        options.scope = request.params["scope"] if request.params["scope"]
        super
      end

      def request_phase
        if invalid_subdomain?
          fail!("Invalid subdomain, please ensure subdomain doesn't contain periods or question marks")
        else
          super
        end
      end

      # Don't allow ? or . in subdomain, for security reasons. User could be
      # redirected to attacker-controller domain if subdomain is something like
      # "bishopfox.com?name=value"
      def invalid_subdomain?
        if request.params["subdomain"]
          return true if request.params["subdomain"].include?("?")
          return true if request.params["subdomain"].include?(".")
        end
        false
      end

      def callback_phase
        zendesk_url # call it so it's memoized and we can ditch the session variable
        session.delete "subdomain"
        super
      end

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, oauth_client_options)
      end

      def oauth_client_options
        deep_symbolize(options.client_options.merge({site: zendesk_url}))
      end

      def zendesk_url
        @zendesk_url ||= begin
          if options.client_options["site"]
            options.client_options["site"]
          else
            if request.params["subdomain"] && request.params["subdomain"].empty?
              request.params["subdomain"] = nil
            end
            options.subdomain = request.params["subdomain"] || session["subdomain"] || options.subdomain
            session["subdomain"] = options.subdomain
            "https://#{options.subdomain}.zendesk.com"
          end
        end
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
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
