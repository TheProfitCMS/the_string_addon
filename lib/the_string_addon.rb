require "the_string_addon/version"

module TheStringAddon; end

class String
  ANY_QUOTE     = '[\"|\']'
  ANY_CONTENT   = '.*?'
  CAN_HAS_SPACE = '[[:space:]]*?'

  def self.trusted_sites
    %w[ site.com example.com ]
  end
end

require "the_string_addon/seo_helpers"
require "the_string_addon/wysiwyg_helpers"
require "the_string_addon/plain_text_helpers"
