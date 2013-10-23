require "./test/test_helper"

describe RuBBCoder do
  before do
    @rubbcoder = RuBBCoder.new
  end

  describe "custom tags" do
    it "custom coder can deal with custom codes" do
      custom_tags = {
        "horse" => RuBBCoder::Tag.new("cr", :block => false) {|c,a| "<horse>?"}
      }
      custom_rubbcoder = RuBBCoder.new(custom_tags)
      bbcode = "I need a weird tag..  How about [horse]?"
      custom_rubbcoder.to_html(bbcode).must_equal "I need a weird tag..  How about <horse>??"
    end

    it "custom coder override existing codes" do
      custom_tags = {
        "youtube" => RuBBCoder::Tag.new("youtube") {|c,a| "<video>"}
      }
      custom_rubbcoder = RuBBCoder.new(custom_tags)
      bbcode = "You tube video here: [youtube]http://www.youtube.com/ABCDEF[/youtube] alright that was nice."
      custom_rubbcoder.to_html(bbcode).must_equal "You tube video here: <video> alright that was nice."
    end
  end

  describe "disable default tags" do
    it "must non translate disable tags" do
      custom_rubbcoder = RuBBCoder.new({}, ["b"])
      bbcode = "This [b]tag[/b] is disabled, but [i]this one[/i] should still work."
      custom_rubbcoder.to_html(bbcode).must_equal "This &#91;b&#93;tag&#91;/b&#93; is disabled, but <em>this one</em> should still work."
    end
  end
end
