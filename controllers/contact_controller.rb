
class ContactController

  def initialize(receipt)
    @receipt = receipt
  end

  def send(sender, message)
    Pony.mail :to => @receipt,
              :from => @receipt,
              :subject => 'Contact from your personal webpage',
              :body => "#{sender} : #{message}"
  end
end