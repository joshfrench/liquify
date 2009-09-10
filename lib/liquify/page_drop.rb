module Liquify
  class PageDrop < Liquid::Drop
    attr_accessor :page
    delegate :title, :slug, :breadcrumb, :to => :page

    def initialize(page)
      @page = page
    end

    def author
      if author = @page.created_by
        author.name
      end
    end
  end
end