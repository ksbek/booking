class UserMailer < ApplicationMailer

  def booking_cancelled booking
    @booking = booking
    mail to: booking.user.email, subject: 'Votre demande de reservation a été refusée par le performeur.'
  end

  def booking_accepted booking
    @booking = booking
    mail to: booking.user.email, subject: default_i18n_subject
  end

  def booking_created booking
    @booking = booking
    if booking.user
      mail to: booking.user.email, subject: default_i18n_subject
    end
  end

  def contact_mail contact
    @contact = contact
    mail to: "enapparte@angeltech.io", subject: default_i18n_subject
  end

  def welcome_email user
    @user = user
    mail to: user.email, subject: 'Welcome to enapparte!'
  end

  def society_mail society
    @society = society
    mail to: "enapparte@angeltech.io", subject: default_i18n_subject
  end

end
