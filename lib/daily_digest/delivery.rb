require 'mail'

module DailyDigest
  class Delivery
    attr_reader :config

    def initialize(config = nil)
      @config = config || configure_from_env
    end

    def configure_from_env
      Config.new(
        mailfrom: ENV['KINDLE_MAILFROM'],
        mailto: ENV['KINDLE_MAILTO'],
        smtp_server: ENV['SMTP_SERVER'],
        smtp_username: ENV['SMTP_USERNAME'],
        smtp_password: ENV['SMTP_PASSWORD'],
      )
    end

    def deliver(file)
      build_mail(file).deliver
    end

    def build_mail(file)
      mail = Mail.new
      mail.to = config.mailto
      mail.from = config.mailfrom
      mail.subject = 'Daily Digest'

      mail.text_part = Mail::Part.new do
        body 'New Daily Digest as an attachment'
      end

      mail.add_file file
      mail.delivery_method :smtp, config.smtp_options

      mail
    end

    class Config
      attr_accessor :mailto, :mailfrom, :smtp_server, :smtp_username, :smtp_password

      def initialize(args)
        args.each do |k, v|
          send("#{k}=", v)
        end
      end

      def smtp_options
        { address: address, port: port, domain: domain, user_name: user_name, password: password  }
      end

      def address
        smtp_server.split(':')[0]
      end

      def port
        smtp_server.split(':')[1] || 25
      end

      def domain
        smtp_username.split('@')[1]
      end

      def user_name
        smtp_username.split('@')[0]
      end

      def password
        smtp_password
      end
    end
  end
end
