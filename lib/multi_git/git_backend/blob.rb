require 'multi_git/blob'
module MultiGit::GitBackend

  class Blob < IO

    include MultiGit::Blob

    delegate (IO.public_instance_methods-Object.public_instance_methods) => 'to_io'

    def initialize(repository, oid, content = nil)
      @repository = repository
      @git = repository.__backend__
      @oid = oid
      @content = content ? content.dup.freeze : nil
    end

    def size
      @size ||= begin
        if @content
          @content.bytesize
        else
          @git.lib.object_size(@oid)
        end
      end
    end

    def content
      @content ||= @git.lib.object_contents(@oid).freeze
    end

    private :content

    def to_io
      @io ||= StringIO.new(content)
    end

  end

end
