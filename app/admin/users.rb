ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :username, :enabled, :role

  menu :label => "Frontend Users", :parent => "Users"

  index do
    column :id
    column :username
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions
  end

  filter :username
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :username
      f.input :email
      f.input :password
      #f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      f.input :enabled

      f.input :role, :as => :select, :collection => User::ROLES

      #for role in User::ROLES
        #f.check_box "user[roles][#{role}]", role, f.object.roles.include?(role), {:name => "user[roles][]"}
        #f.label "user_roles_#{role}", role.humanize
      #end
      #f.hidden_field "user[roles][]", ""
    end
    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

end
