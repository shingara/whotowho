module WhoToWho
  # Class for link an email to a name
  class Link

    attr_reader :name
    attr_reader :email
    attr_reader :exclude
    
    def initialize(name, email)
      @name = name
      @email = email
      @exclude = []
    end

    def exclude=(list_exclude)
      WhoToWho.log.debug "#{name} has exclude #{list_exclude[:exclude].join(',')}"
      @exclude = list_exclude[:exclude]
    end

    def to_s
      "#{name} (#{email})"
    end
  end
end
