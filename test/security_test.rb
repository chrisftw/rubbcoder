require "./test/test_helper"

describe RuBBCoder do
  before do
    @rubbcoder = RuBBCoder.new
  end

  describe "security" do
    it "should not allow css injection in [color] tag" do
      bbcode = "This is the [color=blue\" class=\"howdy]COLOR[/color] test."
      @rubbcoder.to_html(bbcode).must_equal "This is the <span style=\"color:blue;\">COLOR</span> test."
    end

    it "must translate color with attempted css hacks" do
      bbcode = "This is the [color=#0f0;font-size:100px;]BIG COLOR[/color] test."
      @rubbcoder.to_html(bbcode).must_equal "This is the <span style=\"color:#0f0;\">BIG COLOR</span> test."
    end

    it "should not allow js injection in [color] tag" do
      bbcode = "This is the [color=blue\"><script>alert('hello')</script><hr style=\"display:none]COLOR[/color] test."
      @rubbcoder.to_html(bbcode).must_equal "This is the <span style=\"color:blue;\">COLOR</span> test."
    end
  end
end
