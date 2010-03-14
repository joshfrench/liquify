module Liquify

  class PartDrop < Liquid::Drop
    def initialize(page)
      @page = page
    end

    def [](part)
      @context['part_name'] = part if @context
      if part = @page.part(part)
        Liquid::Template.parse(part.content).render(@context)
      end
    end

    alias method_missing []
  end
  
  class ParentBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end
    def render(context)
      puts context
    end
  end

  class PageDrop < Liquid::Drop
    attr_accessor :page
    delegate :title, :slug, :breadcrumb, :parent, :children, :to => :page

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

    def date
      @page.published_at || @page.created_at
    end
    
    def url
      relative_url_for(@page.url, @context['request'])
    end
    
    private
      def relative_url_for(url, request)
        File.join(ActionController::Base.relative_url_root || '', url)
      end

  end
end