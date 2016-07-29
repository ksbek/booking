ActiveAdmin.register User do
  index do
    selectable_column
    id_column
    column :email
    column :role
    column :full_name
    column :phone_number
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :role
  filter :full_name

  form do |f|
    f.inputs 'User' do
      f.input :email
      f.input :password if f.object.new_record?
      f.input :firstname
      f.input :surname
      f.input :nickname, label: 'Nom de scène (nickname)'
      f.input :gender, as: :select, collection: User.genders.keys
      f.input :bio, as: :ckeditor
      f.input :phone_number
      f.input :dob, as: :datepicker
      f.input :activity
      f.input :moving
      f.input :addresses
      f.input :bookings
      f.input :shows

      f.inputs 'Profile picture', header: false, for: [:profile_picture, f.object.profile_picture || Picture.new] do |fc|
        fc.input :image, as: :file
        li id: 'profile_picture' do
          div class: 'inline-hints' do
            render(partial: 'active_admin/picture', locals: { object: f.object, page: 'edit' })
          end
      end
      end

      f.input :role, as: :select, collection: User.roles.keys

      f.input :pictures, as: :file, input_html: { multiple: true }
      li id: 'pictures' do
        div class: 'inline-hints' do
          render(partial: 'active_admin/pictures', locals: { object: f.object, page: 'edit' })
        end
      end

      f.has_many :showcases, heading: false, allow_destroy: true do |s|
        s.input :kind
        s.input :url
      end
      # f.has_many :availabilities, heading: false, allow_destroy: true do |s|
      #   s.input :available_at
      # end
      f.input :art
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :email
      row :full_name
      row :gender
      row :bio
      row :phone_number
      row :moving
      row :dob
      row :activity
      table_for user.languages.order('title ASC') do
        column :languages do |language|
          link_to language.title, admin_language_path(language)
        end
      end
      row :bookings do
        user.bookings.map do |b|
          link_to admin_booking_path(b)
        end.join(', ').html_safe
      end
      row :shows do
        user.shows.map do |b|
          link_to b.title, admin_show_path(b)
        end.join(', ').html_safe
      end
      row :ratings do
        user.ratings.map do |b|
          link_to b.value, admin_rating_path(b)
        end.join(', ').html_safe
      end
      row :role
      row :profile_picture do
        image_tag user.profile_picture.image.url(:thumb) if user.profile_picture
      end
      table_for user.showcases do
        column :showcases do |showcase|
          raw(showcase.kind + ': ' +
                  link_to(showcase.url, showcase.url, target: '_blank'))
        end
      end
      row :art do
        link_to user.art.title, admin_art_path(user.art) if user.art
      end

      row :pictures do
        render(partial: 'active_admin/pictures', locals: { object: user, page: 'show' } )
      end

      row :created_at
      row :updated_at
      row :sign_in_count
      row :last_sign_in_at
      row :last_sign_in_ip
    end
  end
end
