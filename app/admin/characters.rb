ActiveAdmin.register Character do
  filter :user
  filter :race
  filter :career

  index do |character|
    column :name
    column :race
    column :career
    column :user do |user|
      user.user.email
    end
    actions
  end


  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

  end
end