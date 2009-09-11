module Liquify

  class PartDrop < Liquid::Drop
    def initialize(page)
      @page = page
    end

    def [](part)
      if part = @page.part(part)
        part.content
      end
    end

    alias method_missing []
  end

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

    def parts
      PartDrop.new(@page)
    end
  end
end