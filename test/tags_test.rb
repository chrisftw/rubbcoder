require "./test/test_helper"

describe RuBBCoder do
  before do
    @rubbcoder = RuBBCoder.new
  end

  describe "block tags" do
    it "must translate bold tag [b]" do
      bbcode = "This is [b]BOLD[/b] test."
      @rubbcoder.to_html(bbcode).must_equal "This is <strong>BOLD</strong> test."
    end

    it "must translate italic tag [i]" do
      bbcode = "This is [i]ITALIC[/i] test."
      @rubbcoder.to_html(bbcode).must_equal "This is <em>ITALIC</em> test."
    end

    it "must translate color tag [color]" do
      bbcode = "This is the [color=blue]COLOR[/color] test."
      @rubbcoder.to_html(bbcode).must_equal "This is the <span style=\"color:blue;\">COLOR</span> test."
    end

    it "must translate [color] without given color" do
      bbcode = "This is the [color]COLOR[/color] test."
      @rubbcoder.to_html(bbcode).must_equal "This is the <span style=\"color:red;\">COLOR</span> test."
    end

    it "must translate [list]" do
      bbcode = "This is an [list]\n[*]unordered list\n[*]with two items.\n[/list]\nin my code."
      @rubbcoder.to_html(bbcode).must_equal "This is an <ul>\n<li>unordered list</li>\n<li>with two items.</li>\n</ul>\nin my code."
    end

    it "must translate nested [list] tag" do
      bbcode = "This is an [list]\n[*]unordered list[*]with two items.[*][list]\n[*]nested unordered list[*]nested with two items.[/list]\n[/list]\nin my code."
      @rubbcoder.to_html(bbcode).must_equal "This is an <ul>\n<li>unordered list</li>\n<li>with two items.</li>\n<li><ul>\n<li>nested unordered list</li>\n<li>nested with two items.</li>\n</ul></li>\n</ul>\nin my code."
    end

    it "must translate nested [list] tags if li's are identical" do
      bbcode = "This is an [list]\n[*]unordered list[*]with two items.[*][list]\n[*]unordered list[*]with two items.[/list]\n[/list]\nin my code."
      @rubbcoder.to_html(bbcode).must_equal "This is an <ul>\n<li>unordered list</li>\n<li>with two items.</li>\n<li><ul>\n<li>unordered list</li>\n<li>with two items.</li>\n</ul></li>\n</ul>\nin my code."
    end

    it "must translate [size] without going under or over limits" do
      bbcode1 = "This is [size=1]Too Small[/size]"
      bbcode2 = "This is [size=20]Just Right[/size]"
      bbcode3 = "This is [size=100]Too Large[/size]"
      @rubbcoder.to_html(bbcode1).must_equal "This is <span style=\"font-size:8px;\">Too Small</span>"
      @rubbcoder.to_html(bbcode2).must_equal "This is <span style=\"font-size:20px;\">Just Right</span>"
      @rubbcoder.to_html(bbcode3).must_equal "This is <span style=\"font-size:40px;\">Too Large</span>"
    end
    
    it "must translate [quote] tag" do
      bbcode = "Then he said, [quote]I'll be back![/quote]."
      @rubbcoder.to_html(bbcode).must_equal "Then he said, <blockquote>I'll be back!</blockquote>."
    end
    
    it "must translate [youtube] tag" do
      bbcode = "Best video ever! [youtube]http://youtu.be/video[/youtube]."
      @rubbcoder.to_html(bbcode).must_equal "Best video ever! <iframe width="400" height="300" src=\"//youtube.com/embed/dQw4w9WgXcQ\">\n</iframe>."
    end
  end

  describe "non-block tags" do
    it "must translate breaks" do
      bbcode = "This is line one.[br]This is line two."
      @rubbcoder.to_html(bbcode).must_equal "This is line one.<br>\nThis is line two."
    end
  end
end
