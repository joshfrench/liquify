module Liquify
  class SnippetTag < Liquid::Tag
    attr_accessor :snippet

    def initialize(tag_name, snippet_name, tokens)
      @tag_name = tag_name
      @snippet = snippet_name.strip
      parse(tokens)
    end

    def render(context)
      source  = Liquid::Template.file_system.read_template_file(@snippet, Snippet)
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
end