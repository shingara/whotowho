$:.unshift File.dirname(__FILE__)

require 'whotowho/version'
require 'whotowho/link'
require 'whotowho/parseargs'
require 'whotowho/sendmail'
require 'whotowho/smtp_tls'

module WhoToWho

  # Manage the separation and assign all who to who
  class WhoToWho
   
    TIMEOUT = 5000

    # init with an ParseArgs Object
    def initialize(args)
      @args = args
    end

    # Static method to made a logger in general of application
    def self.log
      @@log ||= Logger.new STDOUT
    end

    # Say if the logger is in debug level or not
    # The log is in debug whith -v option
    def self.logdebug?
      WhoToWho.log.level == Logger::DEBUG
    end

    def send(list_random)
      WhoToWho.log.info "Send Mail :"
      list_random.each { |l|
        WhoToWho.log.info "Send mail to #{l[0].name} (#{l[0].email})"
        SendMail.deliver_send_mail(l[1].name, l[0].email, l[0].name, @args)
      }
    end
    
    # made the random in list of Link 
    # and return a list of 2 links. The 
    # first for the second and the second
    # can't be in list of exclude of first
    def random
      concord_list = []
      
      first = @args.put_random
      
      tmp = @args.put_random
      while first.exclude.include? tmp.name
        @args.insert tmp
        tmp = @args.put_random
      end
      concord_list << [first, tmp]
      WhoToWho.log.debug "concords : #{first} <= #{tmp}"

      list_mail = []

      timeout = TIMEOUT
      refresh = false

      while @args.size > 0 do
        tmp2 = @args.put_random
        while tmp.exclude.include? tmp2.name
          @args.insert tmp2
          tmp2 = @args.put_random
          timeout -= 1
          if timeout < 0
            WhoToWho.log.debug 'timeout'
            refresh = true
            break
          end
        end
        concord_list << [tmp, tmp2]
        WhoToWho.log.debug "concords : #{tmp} <= #{tmp2}"
        tmp = tmp2
      end
     
      if tmp.exclude.include? first.name
        refresh = true
      end

      concord_list << [tmp, first]
      WhoToWho.log.debug "concords : #{tmp} <= #{first}"

      if refresh
        @args.refresh
        concord_list = random
      end


      concord_list.each { |c|
        WhoToWho.log.debug "#{c[0]} => #{c[1]}"
      }

      WhoToWho.log.info "The assignement is define."
      concord_list

    end
  end
end
