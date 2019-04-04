class ApplicationMailer < ActionMailer::Base
  default :from => 'support@right-reply.com'
  layout 'mailer'

  def send_contact_message_to_site_admin(uname, uemail, umessage)
    @name = uname
    @email = uemail
    @message = umessage
    mail(:to => 'support@right-reply.com', :from => @email, :subject => 'Some one contacted you from Right Reply')
  end

  def send_contact_message_to_sender(uname, uemail, umessage)
    @name = uname
    @email = uemail
    @message = umessage
    mail(:to => @email, :subject => 'Right Reply - Request Received')
  end
end
