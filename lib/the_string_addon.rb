require "the_string_addon/version"

module TheStringAddon; end

class String
  #######################################################
  # SEO compact
  #######################################################
  def seo_compact
    self.squish.strip.gsub(/\s*,\s*/, ',')
  end

  #######################################################
  # Fix WYSIWYG editor styles
  #######################################################

  # <p style="text-align: justify;"></p>         #=> <br>
  # <p style="text-align: justify;">   <br> </p> #=> <br>

  def empty_p2br
    txt = self.dup

    %w[ p div ].each do |tag_name|
      txt.scan(/(<#{ tag_name }.*?>)(.*?)(<\/#{ tag_name }>)/mix).each do |item|
        start   = item[0]
        content = item[1]
        fin     = item[2]

        if content.match(/\A[[:space:]]*\Z/mix)
          pattern = item.join ''
          txt = txt.gsub pattern, '<br>'
        end

        if content.match(/\A[[:space:]]*<br>[[:space:]]*\Z/mix)
          pattern = item.join ''
          txt = txt.gsub pattern, '<br>'
        end
      end
    end

    txt
  end

  #######################################################
  # ~ Fix WYSIWYG editor styles
  #######################################################

  # Regexp shortcats
  ANY_QUOTE     = '[\"|\']'
  ANY_CONTENT   = '.*?'
  CAN_HAS_SPACE = '[[:space:]]*?'
  TRUSTED_SITES = ['open-cook.ru']

  #######################################################
  # SEO oriented methods
  #######################################################

  def add_nofollow_to_links
    src_content = self.dup
    content     = src_content.dup

    content.scan /(<a.*?>)(.*?)(<\/a>)/mix do |link_parts|
      tag_start   = link_parts[0]
      tag_content = link_parts[1]
      tag_end     = link_parts[2]

      unless tag_start_parts = tag_start.match(/(rel=#{ ANY_QUOTE })(#{ ANY_CONTENT })(#{ ANY_QUOTE })/mix)
        unless tag_start.match(/#{ TRUSTED_SITES.join('|') }/mix)
          old_link = link_parts.join('')
          new_link = ["<a rel='nofollow' #{ tag_start[3..-1] }", tag_content, tag_end].join('')

          src_content.gsub! old_link, new_link
        end
      end
    end

    src_content
  end

  def wrap_nofollow_links_with_noindex
    src_content = self.dup
    content     = src_content.dup

    # find links which wrapped with noindex
    noindexed_links = []
    content.scan /<noindex>(#{ CAN_HAS_SPACE })(<a#{ ANY_CONTENT }>)(#{ ANY_CONTENT })(<\/a>)(#{ CAN_HAS_SPACE })<\/noindex>/mix do |item|
      noindexed_links << item[1..3].join('')
    end

    # all links
    all_links = []
    content.scan /(<a#{ ANY_CONTENT }>)(#{ ANY_CONTENT })(<\/a>)/mix do |item|
      link = item.join

      if link.match(/(rel=#{ ANY_QUOTE })(#{ ANY_CONTENT })(#{ ANY_QUOTE })/mix)
        if link.match /nofollow/mix
          all_links << item.join
        end
      end
    end

    # if link not in list of wrapped links - wrap it
    # identical links will gives wrong result. So, let it be
    all_links.each do |link|
      unless noindexed_links.include?(link)
        src_content.gsub! link, "<noindex>#{ link }</noindex>"
      end
    end

    src_content
  end

  #######################################################
  # ~ SEO oriented methods
  #######################################################


  #######################################################
  # Plain text oriented methods
  #######################################################

  def noendl
    self.gsub("\n", '')
  end

  def endl2br
    self.gsub("\n", "<br />")
  end

  #######################################################
  # ~ Plain text oriented methods
  #######################################################
end
