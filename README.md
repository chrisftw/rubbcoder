# RuBBCoder

### About

BBCode should be simple, and easy to customize.  So we made it simple and easy to customize.

### Warning

Currently on version 0.0.0.  This means ANYTHING could change at any moment while I nail down this problem and the best solutions.  If you find any errors in my code please let me know.  I am new to BBCode.

### Tags

Default tags:

    [b]bold[/b]
    [i]italic[/i]
    [u]underline[/u]
    [s]strikethrough[/s]
    [br]line break
    [size=20]text size[/size]
    [color=red]colored text[/color]
    [list] [*] item 1 [*] item 2 [/list]
    [img]http://url.com/img/hello.jpg[/img]
    [url]http://chrisreister.com[/url]
    [url=http://www.enmasse.com]Custom text url[/url]
    [youtube]http://youtube.com/movie[/youtube]
    [youtube]http://youtube.com/movie[/youtube]

Tags that CAN work:

    [anything] you like[/anything]

See below for setting up custom tags...

### Install RuBBCoder:

    gem install rubbcoder

or in your Gemfile:

    gem rubbcoder

and bundle install!

Wow, that was easy.

### How to use RuBBCoder:

With RuBBCoder default tags:

    @@rubbcoder = RuBBCoder.new()
    html = @@rubbcoder.to_html(user_submitted_text)

#### Add a custom tag

    @@rubbcoder = RuBBCoder.new({"tag" => RuBBCoder::Tag.new("tag", :front => "<pre>", :back => "</pre>")})
    html = @@rubbcoder.to_html(user_submitted_text)

or create a very specialized tag!

    custom_tags = {}
    custom_tags["superhr"] = RuBBCoder::Tag.new("superhr", :block => false){ |contents, attribute, opts|
        "<hr class=\"ultimate\">"
    }
    @@rubbcoder = RuBBCoder.new(custom_tags)

Now you have a tag.  We passed the option block as false, so that the parser does not look for [/supertag]

Using this same technique you can override default functionality of tags.  Here we will make the youtube BBCode a non-block tag with a attribute that is just the video id on Youtube.

    custom_tags = {}
    custom_tags["youtube"] = RuBBCoder::Tag.new("youtube", :block => false){ |contents, attribute, opts|
    <<-YOUTUBE
        <iframe width="#{opts[:video_width]}" height="#{opts[:video_height]}" src="//youtube.com/embed/#{attribute}">
        </iframe>
    YOUTUBE
    }
    @@rubbcoder = RuBBCoder.new(custom_tags)
    
    sample_bbcode = "my video: [youtube=dQw4w9WgXcQ]"

    # => "<iframe width=\"400\" height=\"300\" src=\"//youtube.com/embed/dQw4w9WgXcQ\">\n</iframe>"

#### Disable a default tag

If you want a tag out  it is also quick and easy.  The second argument to a new coder is an array of tags to disable.

    @@rubbcoder = RuBBCoder.new({}, ["s", "u", "youtube"])\
    sample_bbcode = "[b]Hey jive [u]turkey![/u][/b]"
    html = @@rubbcoder.to_html(user_submitted_text)
    # => "<strong>Hey jive &#91;u&#93;turkey&#91;/u&#93;</strong>"

Disabled tags are currently being converted to html entities, and will show as tags to the users, so they can edit the posts.

#### Options, Options, Options

You want options?  We have options.  More coming soon.

* :video_width (default 400)
* :video_height (default 300)
* :text_size_min (default 8)
* :text_size_max (default 40)

Also a bonus option called :coder is a reference back to the coder instance in case you want to call a method on the coder in your custom tag blocks.  This is not a set-able option.

### Other benefits

You can make a separate encoder instance for moderators, so moderators can have additional codes allowed to them.

### Coming soon

* More default tags
* More options

### Contributions

If you need custom tags, they are easy to implement yourself.  If you see something that should be default, and is not let me know.
Always write tests for your pull requests.
