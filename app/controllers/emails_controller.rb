class EmailsController < ApplicationController

  def index
    @all_emails = Email.new.get("subject: Hiring?", 10) 
  end

end
