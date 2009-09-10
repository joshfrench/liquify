module Liquify
  class SnippetDrop < Liquid::Drop
    attr_accessor :snippet
    delegate :content, :to => :snippet

    def initialize(snippet)
      @snippet = snippet
    end
  end
end