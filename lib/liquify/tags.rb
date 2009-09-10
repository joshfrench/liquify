module Liquify
  class SnippetTag < Liquid::Tag
    attr_accessor :snippet

    def initialize(tag_name, snippet_name, tokens)
      @snippet = Snippet.find_by_name(snippet_name.strip)
    end

    def render(context)
      Liquid::Template.parse(@snippet.content).render(context)
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