# OmniAuth Zendesk via OAuth2

This strategy authenticates against Zendesk via OAuth2. You'll need an OAuth2
Application ID and Secret. See the [Zendesk help page][1] for details.

## Usage

```ruby
use OmniAuth::Builder.do
  provider :zendesk, ENV['ZD_CLIENT'], ENV['ZD_SECRET'], client_options: {
    site: 'https://yours.zendesk.com'
  }, scope: 'read'
end
```

Scope can be either `read`, `write` or `read write`.

[1]: https://support.zendesk.com/hc/en-us/articles/203663836-Using-OAuth-authentication-with-your-application#topic_pvr_ncl_1l
