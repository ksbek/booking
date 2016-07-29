ActiveAdmin.register Art do
  permit_params :title, :description, :main_description, :italic_description,
                :banner_url

  index do
    selectable_column
    id_column
    column :art do |art|
      raw art.users.map { |user| link_to(user.full_name, admin_user_path(user)) }.join(', ')
    end
    column :title
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs 'Art' do
      f.semantic_errors *f.object.errors.keys
      f.input :title
      f.input :description
      f.input :main_description
      f.input :italic_description
      f.input :banner_url
    end
    f.actions
  end

  show do |art|
    attributes_table do
      table_for art.users do
        column :users do |user|
          link_to user.full_name, admin_user_path(user)
        end
      end
      row :title
      row :description
      row :main_description
      row :italic_description
      row :banner_url
      row :created_at
      row :updated_at
    end
  end
end
