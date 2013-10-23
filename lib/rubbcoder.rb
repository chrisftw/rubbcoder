class RuBBCoder
  
  class Tag
    
    attr_accessor :coder
    attr_reader :block
    
    def initialize(text, opts = {}, &blk)
      @coder = nil
      @text = text
      @example = opts[:example]
      @decription = opts[:description]
      @block = opts[:block]
      @block = true if @block.nil?
      @front = opts[:front]
      @back = opts[:back] if @block
      @custom = blk
    end
    
    def encode(contents, attribute)
      attribute.gsub!(/^=/, "") if attribute
      attribute = "" if attribute.nil?
      if @custom
        return @custom.call(contents, attribute, @coder.options)
      elsif @block
        return "#{@front}#{contents}#{@back}"
      else
        return @front
      end
    end

    def self.clean_css(css)
      css = css.split(";").first
      return css.split("\"").first
    end
  end
  
  attr_reader :options
  
  def initialize(extra_codes = {}, disable_list = [], opts={})
    @tags = RuBBCoder::DEFAULT_TAGS.clone
    disable_list.each{|key| @tags.delete(key.to_s.downcase)}
    @tags.merge!(extra_codes)
    @tags.each {|k,tag| tag.coder = self }
    
    @options = {:text_size_max => 40, :text_size_min => 8, :video_width => 400, :video_height => 300}
    @options = @options.merge(opts)
    @options[:coder] = self
  end

  def to_html(bbcode)
    html = bbcode.clone
    #html.gsub!(/\n/, "<br>")
    # block tags
    /(.*)\[([A-Za-z]+)(=.*)?\](.*)\[\/\2\](.*)/m.match(html) { |data|
      tag = @tags[data[2].downcase]
      if(tag)
        html = "#{data[1]}#{tag.encode(data[4], data[3])}#{data[5]}"
      else
        html = "#{data[1]}&#91;#{data[2]}#{data[3]}&#93;#{to_html(data[4])}&#91;/#{data[2]}&#93;#{to_html(data[5])}"
      end
    #  puts "HTML before R: #{html}"
      html = to_html(html)
    #  puts "HTML after: #{html}"
    }
    # non block tags
    /(.*)\[([A-Za-z]+)(=.*)?\](.*)/.match(html) { |data|
      tag = @tags[data[2].downcase]
      #puts data[2].to_sym
      #puts tag.inspect
      if(tag && tag.block == false)
        html = "#{data[1]}#{tag.encode(nil, data[3])}#{data[4]}"
      else
        html = "#{data[1]}&#91;#{data[2]}#{data[3]}&#93;#{to_html(data[4])}"
      end
      html = to_html(html)
    }
    
    return html
  end

  DEFAULT_TAGS = {
    "br" => RuBBCoder::Tag.new("br", :example => "Line 1[br]line 2", :description => "Use [br] for new line.",
      :block => false, :front => "<br>\n"
    ),
    "b" => RuBBCoder::Tag.new("b", :example => "normal [b]BOLD text[/b] normal",
      :description => "Use [b] for bold text, end with [/b].",
      :front => "<strong>", :back => "</strong>"
    ),
    "i" => RuBBCoder::Tag.new("i", :example => "normal [i]ITALIC text[/i] normal",
      :description => "Use [i] for italic text, end with [/i].",
      front: "<em>", back: "</em>"
    ),
    "u" => RuBBCoder::Tag.new("u", :front => "<u>", :back => "</u>", :example => "normal [u]underlined text[/u] normal",
      :description => "Use [u] for underline text, end with [/u]."
    ),
    "s" => RuBBCoder::Tag.new("s", :front => "<del>", :back => "</del>",
      :example => "normal [s]strike-through text[/s] noraml",
      :description => "Use [s] for strike-through text, end with [/s]."
    ),
    "color" => RuBBCoder::Tag.new("color", :example => "normal [color=blue]blue text[/color] normal",
      :description => "Change color of your text with [color=tag], end with [/color].") {|c, a, o|
      "<span style=\"color:#{a.length > 2 ? Tag.clean_css(a) : 'red'};\">#{c}</span>"
    },
    "list" => RuBBCoder::Tag.new("list", :front => "<ul>", :back => "</ul>",
      :example => "[list] [*] item 1 [*] item 2 [/list]",
      :description => "Creates a list of items with [*] as bullets."
    ){ |c, a, o|
      c = o[:coder].to_html(c)
      lis = c.split("[*]").collect{|li| li.strip}
      lis.delete_at(0)
      c = "<ul>\n<li>" + lis.join("</li>\n<li>") + "</li>\n</ul>"
    },
    "size" => RuBBCoder::Tag.new("size", :example => "normal [size=30]big text[/size] normal",
      :description => "[size] tag used to alter the size in pixels of the text."
    ){ |c, a, o|
      max = o[:text_size_max]
      min = o[:text_size_min]
      a = a.to_i
      a = max if a > max
      a = min if a < min
      "<span style=\"font-size:#{a}px;\">#{c}</span>"
    },
    "img" => RuBBCoder::Tag.new("img", :example => "[img]http://www.enmasse.com/game.png[/img]",
      :description => "[img] tag used to place an image in the forums.") {|c, a| "<img src=\"#{c}\">" },
    "url" => RuBBCoder::Tag.new("url", :example => "[url=http://tera.enmasse.com]Link Text[/url]",
      :description => "make a link with ") {|c, a| "<a href=\"#{a || c}\">#{c}</a>" },
    "table" => RuBBCoder::Tag.new("table", :front => "<table>\n", :back => "</table>\n",
      :example => "[table][tr][td]data[/td][/tr][/table]",
      :description => "Makes a table."
    ),
    "tr" => RuBBCoder::Tag.new("tr", :front => "<tr>", :back => "</tr>\n"),
    "td" => RuBBCoder::Tag.new("td", :front => "<td>", :back => "</td>"),
    "quote" => RuBBCoder::Tag.new("quote", :front => "<blockquote>", :back => "</blockquote>"),
    "youtube" => RuBBCoder::Tag.new("youtube") {|c, a| <<-YOUTUBE
<iframe width="#{opts[:video_width]}" height="#{opts[:video_height]}" src="//youtube.com/embed/#{attribute}">
</iframe>
YOUTUBE
    }
  }

end
