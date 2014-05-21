ActiveAdmin.register ForcePower do
  permit_params :name, :description, :activation, :ranked,
    force_power_upgrades_attributes: [ :id, :force_power_id, :name, :description, :ranked, :cost, :column, :row, :colspan, :parent_1, :parent_2 ]

  config.sort_order = "name_asc"

  show :title => :name do
    table '', :class => 'talent-tree' do
      colgroup do
        col :width => "22%"
        col :width => "4%"
        col :width => "22%"
        col :width => "4%"
        col :width => "22%"
        col :width => "4%"
        col :width => "22%"
      end
      tr do
        td :class => 'talent', :colspan => 7 do
          span strong "#{force_power.name} Basic Power"
          #br strong talent.activation
          span text_replace_tokens(force_power.description.html_safe)
        end
      end

      upgrades_row_1 = ForcePowerUpgrade.where(:force_power_id => force_power.id, :row => 1).order(:column)
      upgrades_row_2 = ForcePowerUpgrade.where(:force_power_id => force_power.id, :row => 2).order(:column)
      upgrades_row_3 = ForcePowerUpgrade.where(:force_power_id => force_power.id, :row => 3).order(:column)
      upgrades_row_4 = ForcePowerUpgrade.where(:force_power_id => force_power.id, :row => 4).order(:column)

      tr do
        upgrades_row_1.each_with_index do |upg, i|
          td :class => 'vertical-link link-1', :colspan => upg.colspan
          unless upgrades_row_1.last == upg or i == 3
            td
          end
        end
      end
      tr do
        upgrades_row_1.each_with_index do |upg, i|
          td :class => 'talent', :colspan => upg.colspan do
            span upg.name
            br text_replace_tokens(upg.description.html_safe)
          end
          unless upgrades_row_1.last == upg or i == 3
            td :class => 'horizontal-link link-' + force_power.upgrade_links_horizontal_admin[0][i].to_s
          end
        end
      end

      tr do
        force_power.upgrade_links_vertical_admin[1].each do |link|
          td :class => 'vertical-link link-'+link.to_s
        end
      end
      tr do
        upgrades_row_2.each_with_index do |upg, i|
          td :class => 'talent', :colspan => upg.colspan do
            span upg.name
            br text_replace_tokens(upg.description.html_safe)
          end
          unless upgrades_row_2.last == upg or i == 3
            td :class => 'horizontal-link link-' + force_power.upgrade_links_horizontal_admin[1][i].to_s
          end
        end
      end

      tr do
        force_power.upgrade_links_vertical_admin[2].each do |link|
          td :class => 'vertical-link link-'+link.to_s
        end
      end
      tr do
        upgrades_row_3.each_with_index do |upg, i|
          td :class => 'talent', :colspan => upg.colspan do
            span upg.name
            br text_replace_tokens(upg.description.html_safe)
          end
          unless upgrades_row_3.last == upg or i == 3
            td :class => 'horizontal-link link-' + force_power.upgrade_links_horizontal_admin[2][i].to_s
          end
        end
      end

      tr do
        force_power.upgrade_links_vertical_admin[3].each do |link|
          td :class => 'vertical-link link-'+link.to_s
        end
      end
      tr do
        upgrades_row_4.each_with_index do |upg, i|
          td :class => 'talent', :colspan => upg.colspan do
            span upg.name
            br text_replace_tokens(upg.description.html_safe)
          end
          unless upgrades_row_4.last == upg or i == 3
            td :class => 'horizontal-link link-' + force_power.upgrade_links_horizontal_admin[3][i].to_s
          end
        end
      end
    end
  end

  form do |f|
    f.inputs "Basic Power" do
      f.input :name
      f.input :description
      if force_power.id
        f.has_many :force_power_upgrades do |em_form|
          em_form.input :name
          em_form.input :description
          em_form.input :ranked
          em_form.input :cost
          em_form.input :row
          em_form.input :column
          em_form.input :colspan
          em_form.input :parent_1, :as => :select, :collection => ForcePowerUpgrade.where(:force_power_id => force_power.id).map{|upgrade| ["#{upgrade.name} (#{upgrade.row},#{upgrade.column})", upgrade.id]}
          em_form.input :parent_2, :as => :select, :collection => ForcePowerUpgrade.where(:force_power_id => force_power.id).map{|upgrade| ["#{upgrade.name} (#{upgrade.row},#{upgrade.column})", upgrade.id]}
        end
      end

    end
    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      create! do |format|
        format.html { redirect_to admin_force_powers_url }
      end
    end
  end
end
