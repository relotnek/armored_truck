class FileMailer < ActionMailer::Base
  default from: "armoredtruck@truckdispatch.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Armored Truck')
  end

  def file_email(sender, sprivkey_name, recipient, rpubkey_name)
    @sender = sender
    @user = current_user
    

    mail(to: @recipient.email, subject: "You've recieved a new file from Armored Truck")
  end
end
