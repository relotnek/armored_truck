class FileMailer < ActionMailer::Base
  default from: "armor@armoredtruck.com"

  def mail_file(recipient, sender, pubkey, privkeyname, encfilename)
    @recipient = recipient
    @sender = sender
    @pubkeyname = pubkey
    @privkeyname = privkeyname
    #attachments[encfilename] = { encoding: 'quoted-printable', content: "test" }
    mail(to: @recipient, subject: "ARMOR!")

  end

end
