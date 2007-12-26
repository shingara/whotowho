require 'yaml'
require 'optparse'

module WhoToWho
  # Class for parse Args and save all into
  class ParseArgs

    attr_reader :verbose
    attr_reader :subject
    attr_reader :content
    attr_reader :from

    # Parse all argument and check if required is define
    def parse(args, prog)
      options = OptionParser.new do |opts|
        
        opts.banner = "Usage: #{prog} [options]"
        
        opts.on("-v", "--verbose", "Run verbosely") do |v|
          @verbose = true
        end
        opts.on( '-f', '--file REQUIRED', :REQUIRED, 'File where is all data') do |f|
          load_file f
        end
        opts.on('-c', '--config FILE', :REQUIRED, 'File where is all config') do |f|
          load_config f
        end
        opts.on('-g', '--gmail', 'Define option if use a Gmail account for SMTP') do |g|
          require_dependency('whotowho/smtp_tls') if g
        end
        opts.on('-s', '--subject SUBJECT', :REQUIRED, 'Define the subject to send by email') do |s|
          @subject = s
        end
        opts.on('-m FILE', '--mail MAIL', :REQUIRED, 'Send a file where the content is with 2 params #{who} and #{towho}') do |c|
          @content = File.open(c).read
        end

        @full_print = opts

      end.parse!
      test_required
      @test = 0
    end


    # Send a random Link objet from list_link save into
    def put_random
      rand_index = rand(@list_link.size)
      @list_link.slice!(rand_index)
    end

    # Size of list_link in args
    def size
      @list_link.size
    end


    def insert(link)
      @list_link << link
    end

    # Size of list_link in args
    def size
      @list_link.size
    end

    def refresh
      @list_link = Array.new @list_link_copy
      puts 'refresh'
      @test += 1
      if @test > 3
        puts 'Sorry this combinaison is hard to randomise'
        exit
      end
    end

  private
   
    # Load the file with format to YAML in list_link attribute
    def load_file(f)
      @list_link = []
      YAML.load_file(f).each { |e|
        link = Link.new e[0], e[1]
        link.exclude = e[2] if e.size > 2
        @list_link << link
      }
      check_possibility
      @list_link_copy = Array.new @list_link
    end

    # Check if the @list_link it's not incorrect
    # If the @list_link has no an element exclude by all
    # or one element who exclude all
    def check_possibility
      @list_link.each { |l|

        # Check if one element exclude all element
        if (l.exclude.class == Array && l.exclude.size >= (@list_link.size - 1))
          puts "There are several exclude for #{l.name}. You need define less one element possible"
          exit
        end

        # Check if one element is exclude by all element 
        all_exclude = false

        @list_link.each { |l2|
          next if l2 == l
          unless l2.exclude.nil?
            if l2.exclude.include? l.name
              all_exclude = true 
            else
              all_exclude = false
            end
          end
          break unless all_exclude
        }

        if all_exclude
          puts "One name is exclude by all other element. This element is #{l.name}, you need fixe that"
          exit
        end
      }
    end

    # Load the file like a smtp config for actionMailer
    def load_config(f)
      conf_hash = YAML.load_file f
      ActionMailer::Base.smtp_settings = conf_hash
      @from = conf_hash[:from]
    end
    
    # Test if all argument required is define
    def test_required
      required = true
      if @subject.nil? || @subject.empty?
        puts 'you need define a subject'
        required = false
      end

      if @content.nil? || @content.empty?
        puts 'you need define a file or a file not empty for you mail template'
        required = false
      end

      if @list_link.nil? || @list_link.empty? || @list_link.size < 2
        puts 'The list of data need define by a file. This file can\'t be empty or only one data'
        required = false
      end

      if ActionMailer::Base.smtp_settings.empty?
        puts 'The configuration of your SMTP account can\'t be empty'
        required = false
      end

      if @from.nil? || @from.empty?
        puts 'You need define a from in your mail settings.'
        required = false
      end

      unless required
        puts @full_print
        exit
      end
    end

  end
end
