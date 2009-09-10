module Liquify
  class PageDrop < Liquid::Drop
    def initialize(page)
      @page = page
    end

    def title
      @page.title
    end
  end
end