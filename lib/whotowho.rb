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

    def send(list_random)
      list_random.each { |l|
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
      puts "concords : #{first} <= #{tmp}"

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
            puts 'timeout'
            refresh = true
            break
          end
        end
        concord_list << [tmp, tmp2]
        puts "concords : #{tmp} <= #{tmp2}"
        tmp = tmp2
      end
     
      if tmp.exclude.include? first.name
        refresh = true
      end

      concord_list << [tmp, first]
      puts "concords : #{tmp} <= #{first}"

      if refresh
        @args.refresh
        concord_list = random
      end


      concord_list.each { |c|
        puts "#{c[0]} => #{c[1]}"
      }

      concord_list

    end
  end
end
