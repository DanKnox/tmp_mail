module TmpMail
  class Configuration

    attr_reader :mongoid_config
    attr_reader :include_root_in_json
    attr_reader :maildir_path

    def initialize
      @mongoid_config = "#{File.dirname(__FILE__)}/mongoid.yml"
      @include_root_in_json = false
      @maildir_path = ENV['MAILDIR_PATH']
    end

  end
end
