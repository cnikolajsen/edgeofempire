ActiveAdmin.register User do
  menu :label => "Frontend Users", :parent => "Users"

  index do
    column :id
    column :username
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :username
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      f.input :enabled

    end
    f.actions
  end
end
