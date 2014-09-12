class FileMailer < ActionMailer::Base
  default from: "armor@armoredtruck.com"

  def mail_file(recipient)
    @recipient = recipient
    mail(to: @recipient, subject: "ARMOR!")
  end

end
