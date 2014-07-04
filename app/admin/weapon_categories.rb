ActiveAdmin.register WeaponCategory do
  permit_params :name

  menu :label => "Weapon Categories", :parent => "Equipment"

  show do
    weapon_category.name.pluralize
  end
end
