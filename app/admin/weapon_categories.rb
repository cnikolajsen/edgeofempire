ActiveAdmin.register WeaponCategory do
  permit_params :name

  menu :label => "Weapon Categories", :parent => "Equipment"
end
