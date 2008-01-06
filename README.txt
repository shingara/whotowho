WhoToWho

 * http://dev.shingara.fr/projects/show/4
 * mailto:cyril.mougel@gmail.com

== HISTORY:

WhoToWho made in first for my friend group. For Christmas, we decide to
group us and we offer one present for only one other personne. The price is
define in first for this present.

Before WhoToWho, we made a group before the Christmas night and we made a
random choice of who must offer to who. The choice is made with little paper
in hat.

Now we are in different place and we can't see every week. So, like we have
all an email, I created WhoToWho. So I can't know who must be offer to who and
it's a total random.

Yes, WhoToWho is useless. But What is really usefull?

== DESCRIPTION:

WhoToWho is a simple script to define a name randomly in list of name. And
send this name by email. With WhoToWho you can define several thing:

 * Subject of Mail
 * Format of Mail with 2 parameters (who and towho)
 * The configuration of smtp connection
 * Add options for SSL if your smtp connection is a Gmail account

== FEATURES:

 * Randomize a list and choice one persone for another
 * Send an email who the personne know who is define to it
 * Define the subject and the content of mail with 2 places for define word
 * who and to who
 * Possibility to exclude one or several person for another. With this
   feature, one person can't have another person define.

== SYNOPSIS:

Usage: ./whotowho.rb [options]
  -v, --verbose                    Run verbosely
  -f, --file FILE                  File where is all data
  -c, --config FILE                File where is all config
  -g, --gmail                      Define option if use a Gmail account for SMTP
  -s, --subject SUBJECT            Define the subject to send by email
  -m, --mail MAIL                  Send a file where the content is with 2 params #{who} and #{towho}

== REQUIREMENT:

 * ActionMailer from Ruby On Rails project : gem install actionmailer

== INSTALL:

= Archive *.tar.gz

 * Install actionmailer before
 * Untar the archive
 * Go to bin directory
 * Start command whotowho

= Gem

 * gem install whotowho

== Example of command

ruby whotowho -m mail-example.txt -s 'a good subject' -f ../data.yaml -c conf.yaml -g

== Example of File configuration

= File data example

This file define the list of name and email. The format of this file is YAML. It's the serialization of an Array of an Array in Ruby. A example of format is :

- - name
  - email
- - name2
  - email2
- - name3
  - email3

If you want define an exclude person to another you need had an Exclude list to the key exclude after email, like following :

- - name
  - email
  - :exclude: - name2
- - name2
  - email2
  - :exclude: - name5
              - name6
- - name3
  - email3
- - name4
  - email4
- - name5
  - email5
- - name6
  - email6

= File of mail configuration

It's the same of actionmailer. But I have add a configuration of from. You need had :from:

:address: Allows you to use a remote mail server. Just change it from its default "localhost" setting.
:port: On the off chance that your mail server doesn‘t run on port 25, you can change it.
:domain: If you need to specify a HELO domain, you can do it here.
:user_name: If your mail server requires authentication, set the username in this setting.
:password: If your mail server requires authentication, set the password in this setting.
:authentication: If your mail server requires authentication, you need to specify the authentication type here. This is a symbol and one of :plain, :login, :cram_md5
:from: Define the email who send all mail in from header

= File of mail content

This file is a simple text file. You have two patterns who change before the send.

 * #{who} : it's the name of person who receiv the mail
 * #{towho} : the name of person assign to personne who receiv this mail

== LICENSE:

This code is free to use under the terms of the MIT license.
