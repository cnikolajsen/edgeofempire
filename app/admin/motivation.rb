ActiveAdmin.register Motivation do
  permit_params :description, :name, :category, :career_id

  menu label: 'Motivation', parent: 'Character Backgrounds'

  config.sort_order = 'category_asc'

  config.per_page = 50

  filter :category, as: :select
  filter :name, as: :string

  index do
    column :category
    column :name
    column :career
    column :description do |desc|
      simple_format desc.description
    end
    actions
  end

  form do |f|
    f.inputs 'Motivation Details' do
      f.input :career
      f.input :name
      f.input :description
      f.input :category, as: :select, collection: %w(Ambition Cause Relationship Discovery Conflict)
    end
    f.actions
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_motivations_url }
      end
    end
  end
end
