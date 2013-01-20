module TmpMail
  class Configuration

    attr_reader :mongoid_config
    attr_reader :include_root_in_json

    def initialize
      @mongoid_config = "#{File.dirname(__FILE__)}/mongoid.yml"
      @include_root_in_json = false
    end

  end
end
