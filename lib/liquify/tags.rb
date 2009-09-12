module Liquify
  class SnippetTag < Liquid::Tag
    attr_accessor :snippet

    def initialize(tag_name, markup, tokens)
      super
      @markup.strip!
    end

    def render(context)
      source  = Liquid::Template.file_system.read_template_file(@markup, Snippet)
      partial = Liquid::Template.parse(source)
      partial.render(context)
    end

  end
  Liquid::Template.register_tag('snippet', SnippetTag)
  
  class LoremTag < Liquid::Tag
    def render(context)
      'Lorem Ipsum Donut'
    end
  end
  Liquid::Template.register_tag('lorem', LoremTag)
  
  class CurrentTimeTag < Liquid::Tag
    def render(context)
      if @markup.empty?
        Time.now
      else
        Time.now.strftime(@markup.strip)
      end
    end
  end
  Liquid::Template.register_tag('current_time', CurrentTimeTag)
end