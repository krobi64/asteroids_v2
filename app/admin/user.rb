ActiveAdmin.register User do
  index do
    column :username
    column :email
    column :role
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs 'Admin Details' do
      f.input :username
      f.input :email
      f.input :role
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
