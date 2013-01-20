module TmpMail
  class Address < ::Mail::Address

    def self.demongoize(object)
      Address.new(object)
    end

    def self.mongoize(object)
      case object
      when Address then object.mongoize
      when String then Address.new(object).mongoize
      else
        object
      end
    end

    def self.evolve(object)
      case object
      when Address then object.mongoize
      else
        object
      end
    end

    def mongoize
      to_s
    end

  end
end
