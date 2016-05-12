# OmniAuth Zendesk via OAuth2

This strategy authenticates against Zendesk via OAuth2. You'll need an OAuth2
Application ID and Secret. See the [Zendesk help page][1] for details.

## Usage

#### Single Subdomain

```ruby
use OmniAuth::Builder.do
  provider :zendesk, ENV['ZD_CLIENT'], ENV['ZD_SECRET'], client_options: {
    site: 'https://yours.zendesk.com'
  }, scope: 'read'
end
```

Scope can be either `read`, `write` or `read write`.

#### Multiple Subdomains

If you have [Global OAuth][2] enabled for Zendesk you can specify the
**subdomain** in a URL parameter called `subdomain`. If you would like to do
this do not specify a `site` in the builder because that will override the
`subdomain` parameter.

```ruby
use OmniAuth::Builder.do
  provider :zendesk, ENV['ZD_CLIENT'], ENV['ZD_SECRET'], scope: 'read'
end
```

Then your Omniauth URL should be formulated like this:
`https://mysite.local/auth/zendesk?subdomain=myzendesk`

[1]: https://support.zendesk.com/hc/en-us/articles/203663836-Using-OAuth-authentication-with-your-application#topic_pvr_ncl_1l
[2]: https://support.zendesk.com/hc/en-us/articles/203691386-Using-a-Global-OAuth-Client-to-Integrate-with-Zendesk
