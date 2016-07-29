class HomeController < ApplicationController
  def index
  end

  def contact
    contact = contact_params
    if current_user
      contact[:name] = current_user.full_name
      contact[:email] = current_user.email
      contact[:phone] = current_user.phone_number
      contact[:city] = current_user.addresses.first.try(:city)
    end
    UserMailer.contact_mail(contact).deliver_later
    render json: { msg: "success" }
  end

  def society
    society = society_params
    UserMailer.society_mail(society).deliver_later
    render json: { msg: "success" }
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :city, :phone, :message)
    end

    def society_params
      params.require(:society).permit(:name, :city, :email, :phone, :event, :price, :message)
    end

end
