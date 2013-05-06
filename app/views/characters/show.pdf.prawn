pdf.image "#{Rails.root}/public/character_sheet_bg_pg1.jpg", :at => [0, y - 0]

pdf.draw_text "CHARACTER", :size => 7, :style => :bold, :at => [74, y - 22]
pdf.draw_text "CHARACTER NAME", :size => 11, :style => :bold, :at => [74, y - 39]
pdf.draw_text "SPECIES", :size => 7, :at => [74, y - 58]
pdf.draw_text "CAREER", :size => 7, :at => [74, y - 76]
pdf.draw_text "SPECIALIZATION TREES", :size => 7, :at => [74, y - 95]
pdf.draw_text "#{@character.name}", :size => 14, :at => [195, y - 39]
pdf.draw_text "#{@character.race.name}", :size => 10, :at => [195, y - 58]
pdf.draw_text "#{@character.career.name}", :size => 10, :at => [195, y - 76]

pdf.text_box "#{@character.user.email}", :size => 8, :at => [458, y - 90]

pdf.text_box "#{@soak}", :size => 25, :style => :bold, :at => [120, y - 133]
pdf.text_box "#{@wound_th}", :size => 25, :style => :bold, :at => [215, y - 133]
pdf.text_box "#{@strain_th}", :size => 25, :style => :bold, :at => [340, y - 133]
pdf.text_box "#{@defense}", :size => 25, :style => :bold, :at => [475, y - 133]

# Abilities
pdf.text_box "#{@character.brawn}", :size => 35, :style => :bold, :at => [93, y - 212]
pdf.text_box "#{@character.agility}", :size => 35, :style => :bold, :at => [175, y - 212]
pdf.text_box "#{@character.intellect}", :size => 35, :style => :bold, :at => [260, y - 212]
pdf.text_box "#{@character.cunning}", :size => 35, :style => :bold, :at => [345, y - 212]
pdf.text_box "#{@character.willpower}", :size => 35, :style => :bold, :at => [429, y - 212]
pdf.text_box "#{@character.presence}", :size => 35, :style => :bold, :at => [513, y - 212]

bounding_box([70, 536], :width => 65, :height => 10) do
  pdf.text "BRAWN", :size => 7, :style => :normal, :align => :center, :color => "ffffff"
end
bounding_box([153, 536], :width => 65, :height => 10) do
  pdf.text "AGILITY", :size => 7, :style => :normal, :align => :center, :color => "ffffff"
end
bounding_box([238, 536], :width => 65, :height => 10) do
  pdf.text "INTELLECT", :size => 7, :style => :normal, :align => :center, :color => "ffffff"
end
bounding_box([322, 536], :width => 65, :height => 10) do
  pdf.text "CUNNING", :size => 7, :style => :normal, :align => :center, :color => "ffffff"
end
bounding_box([406, 536], :width => 65, :height => 10) do
  pdf.text "WILLPOWER", :size => 7, :style => :normal, :align => :center, :color => "ffffff"
end
bounding_box([490, 536], :width => 65, :height => 10) do
  pdf.text "PRESENCE", :size => 7, :style => :normal, :align => :center, :color => "ffffff"
end


# Abilities end

#@character.character_skills.each do |character_skill|
#    character_skill.skill.name
    # <%= character_skill.ranks unless character_skill.ranks < 1  %> [<%= render :partial => "dice_pool", :locals => {:score => #@character.send(character_skill.skill.characteristic.downcase), :ranks => character_skill.ranks} %>]<% if #@character.character_skills.last != character_skill %>,<% end %>
#end

combat = Array.new
knowledge = Array.new
other = Array.new
@character.character_skills.each do |skill|
  if @combat_skills.include?(skill.skill.name)
    combat << skill
  elsif @knowledge_skills.include?(skill.skill.name)
    knowledge << skill
  else
    other << skill
  end
end

combat_skills = combat.map do |skill|
  pdf.font "Helvetica", :size=> 8
  dice_ability = "#{Rails.root}/public/dice/blank.png"
  dice_proficiency = "#{Rails.root}/public/dice/blank.png"
  if @character.send(skill.skill.characteristic.downcase) == skill.ranks
    dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{skill.ranks}.png"
  elsif @character.send(skill.skill.characteristic.downcase) < skill.ranks
    dice_ability = "#{Rails.root}/public/dice/ability_#{skill.ranks - @character.send(skill.skill.characteristic.downcase)}.png"
    dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{@character.send(skill.skill.characteristic.downcase)}.png"
  else
    dice_ability = "#{Rails.root}/public/dice/ability_#{@character.send(skill.skill.characteristic.downcase) - skill.ranks}.png"
    if skill.ranks > 0
      dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{skill.ranks}.png"    
    end
  end
  [
    "#{skill.skill.name} (#{skill.skill.characteristic.truncate(3, :omission => '')})",
    if @career_skill_ids.include?(skill.skill.id)
      'Yes'
    end,
    {:image => dice_ability},
    {:image => dice_proficiency},
  ]
end

knowledge_skills = knowledge.map do |skill|
  pdf.font "Helvetica", :size=> 8
  dice_ability = "#{Rails.root}/public/dice/blank.png"
  dice_proficiency = "#{Rails.root}/public/dice/blank.png"
  if @character.send(skill.skill.characteristic.downcase) == skill.ranks
    dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{skill.ranks}.png"
  elsif @character.send(skill.skill.characteristic.downcase) < skill.ranks
    dice_ability = "#{Rails.root}/public/dice/ability_#{skill.ranks - @character.send(skill.skill.characteristic.downcase)}.png"
    dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{@character.send(skill.skill.characteristic.downcase)}.png"
  else
    dice_ability = "#{Rails.root}/public/dice/ability_#{@character.send(skill.skill.characteristic.downcase) - skill.ranks}.png"
    if skill.ranks > 0
      dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{skill.ranks}.png"    
    end
  end
  [
    "#{skill.skill.name} (#{skill.skill.characteristic.truncate(3, :omission => '')})",
    if @career_skill_ids.include?(skill.skill.id)
      'Yes'
    end,
    {:image => dice_ability},
    {:image => dice_proficiency}
  ]
end

general_skills = other.map do |skill|
  pdf.font "Helvetica", :size=> 8
  dice_ability = "#{Rails.root}/public/dice/blank.png"
  dice_proficiency = "#{Rails.root}/public/dice/blank.png"
  if @character.send(skill.skill.characteristic.downcase) == skill.ranks
    dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{skill.ranks}.png"
  elsif @character.send(skill.skill.characteristic.downcase) < skill.ranks
    dice_ability = "#{Rails.root}/public/dice/ability_#{skill.ranks - @character.send(skill.skill.characteristic.downcase)}.png"
    dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{@character.send(skill.skill.characteristic.downcase)}.png"
  else
    dice_ability = "#{Rails.root}/public/dice/ability_#{@character.send(skill.skill.characteristic.downcase) - skill.ranks}.png"
    if skill.ranks > 0
      dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{skill.ranks}.png"    
    end
  end
  [
    "#{skill.skill.name} (#{skill.skill.characteristic.truncate(3, :omission => '')})",
    if @career_skill_ids.include?(skill.skill.id)
      'Yes'
    end,
    {:image => dice_ability},
    {:image => dice_proficiency}
  ]
end

bounding_box([64, 505], :width => 242, :height => 335) do
  pdf.table [
   ['General skills', 'Career?', 'Dice pool']
  ],
  :cell_style => {
    :height => 10,
    :padding => 1,
    :size => 5,
    :align => :center
  },
  :width => 242,
  :column_widths => [100, 22, 120]
  
  pdf.table general_skills,
    :cell_style => {
      :height => 15,
      :padding => 1,
    },
    :width => 242,
    :column_widths => [100, 22, 60, 60]
end

bounding_box([320, 505], :width => 242, :height => 335) do
  pdf.table [
   ['Combat skills', 'Career?', 'Dice pool']
  ],
  :cell_style => {
    :height => 10,
    :padding => 1,
    :size => 5,
    :align => :center
  },
  :width => 242,
  :column_widths => [100, 22, 120]

  pdf.table combat_skills,
    :cell_style => {
      :background_color => "FFFFFF",
      :height => 15,
      :padding => 1,
    },
    :width => 242,
    :column_widths => [100, 22, 60, 60]
end

bounding_box([320, 408], :width => 242, :height => 335) do
  pdf.table [
   ['Knowledge skills', 'Career?', 'Dice pool']
  ],
  :cell_style => {
    :height => 10,
    :padding => 1,
    :size => 5,
    :align => :center
  },
  :width => 242,
  :column_widths => [100, 22, 120]

  pdf.table knowledge_skills,
    :cell_style => {
      :background_color => "FFFFFF",
      :height => 15,
      :padding => 1,
      },
      :width => 242,
      :column_widths => [100, 22, 60, 60]
end

bounding_box([320, 280], :width => 242, :height => 335) do
  pdf.table [
   ['Custom skills', 'Career?', 'Dice pool']
  ],
  :cell_style => {
    :height => 10,
    :padding => 1,
    :size => 5,
  },
  :width => 242,
  :column_widths => [100, 22, 120]

 # pdf.table custom_skills,
 #   :cell_style => {
 #     :background_color => "FFFFFF",
 #     :height => 15,
 #     :padding => 1,
 #     },
 #     :width => 242,
 #     :column_widths => [100, 22, 60, 60]
end

bounding_box([70, 28], :width => 80, :height => 15) do
  text "#{@character.experience}", :size => 15, :style => :bold, :align => :center
end

pdf.start_new_page

pdf.image "#{Rails.root}/public/character_sheet_bg_pg2.jpg", :at => [0, y - 0]


bounding_box([100, 300], :width => 300, :height => 200) do 

end