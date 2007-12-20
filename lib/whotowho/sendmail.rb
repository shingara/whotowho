require 'action_mailer'

module WhoToWho
  # Made the send mail
  class SendMail < ActionMailer::Base

    # Send a mail with information send by args
    # args is a ParseArgs Object
    def send_mail(name, email, name_receiv, args)
      recipients email
      from args.from
      subject args.subject
      body(args.content.gsub(/\#\{who\}/, name_receiv).gsub(/\#\{towho\}/, name))
    end
    
  end
end
