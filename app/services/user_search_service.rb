class UserSearchService
  def initialize(params)
    @users = User.all
    filter_by_role(params[:role])
    filter_by_art(params[:art_id])
    filter_by_price(params[:price_min], params[:price_max])
    filter_by_available_at(params[:start_date], params[:end_date])
  end

  def filter_by_role(role)
    @users = @users.where(role: User.roles[role]) if role.present?
  end

  def filter_by_art(art_id)
    @users = @users.where(art_id: art_id) if art_id.present?
  end

  def filter_by_available_at(start_date, end_date)
    if end_date
      right_border = DateTime.strptime(end_date, '%m/%d/%Y')
      left_border = start_date ?  DateTime.strptime(start_date, '%m/%d/%Y') : DateTime.now
      all_users = @users
      available_users = @users.joins(:availabilities).where(user_availabilities: { available_at: left_border..right_border })
      non_available_users = (all_users - available_users).uniq
      non_available_users.each {|u| u.unavailable = true}
      @users = (available_users + non_available_users).uniq
    end  
  end

  def filter_by_price(price_min, price_max)
    return @users if price_min.blank? || price_max.blank?
    @users = @users.joins(:shows).where(shows: { price: price_min..price_max })
  end

  def results
    @users
  end
end
