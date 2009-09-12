module Liquify
  class DBFileSystem
    def self.read_template_file(name, klass)
      klass.find_by_name(name).content
    end
  end
end