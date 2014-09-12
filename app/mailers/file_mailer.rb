class FileMailer < ActionMailer::Base
  default from: "armor@armoredtruck.com"

  def mail_file(recipient, sender, pubkey, privkeyname, encryptedfile, encfilename)
    @recipient = recipient
    @sender = sender
    @pubkeyname = pubkey
    @privkeyname = privkeyname
    attachments[encfilename] = {encoding: 'quoted-printable', content: encryptedfile }
    mail(to: @recipient, subject: "ARMOR!")

  end

end
