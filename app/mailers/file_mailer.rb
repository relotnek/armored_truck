class FileMailer < ActionMailer::Base
  default from: "from@example.com"

  def mail_file(recipient)
    @recipient = recipient
    mail(to: @recipient, subject: "ARMOR!")
  end

end
