pdf.image "#{Rails.root}/public/character_sheet_bg_pg1.jpg", :at => [0, y - 0]

pdf.text_box "#{@character.name}", :size => 14, :at => [185, y - 30]
pdf.text_box "#{@character.race.name}", :size => 12, :at => [185, y - 50]
pdf.text_box "#{@character.career.name}", :size => 12, :at => [185, y - 68]

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
# Abilities end

@character.character_skills.each do |character_skill|
    character_skill.skill.name
    # <%= character_skill.ranks unless character_skill.ranks < 1  %> [<%= render :partial => "dice_pool", :locals => {:score => @character.send(character_skill.skill.characteristic.downcase), :ranks => character_skill.ranks} %>]<% if @character.character_skills.last != character_skill %>,<% end %>
end

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
  pdf.font "Helvetica", :size=> 10
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
  pdf.font "Helvetica", :size=> 10
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

other_skills = other.map do |skill|
  pdf.font "Helvetica", :size=> 10
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

bounding_box([64, 497], :width => 242, :height => 335) do
  pdf.table other_skills,
    :cell_style => {
      :background_color => "FFFFFF",
      :height => 15,
      :padding => 1,
    },
    :width => 242,
    :column_widths => [100, 22, 60, 60]
end

bounding_box([320, 498], :width => 242, :height => 335) do
  pdf.table combat_skills,
    :cell_style => {
      :background_color => "FFFFFF",
      :height => 15,
      :padding => 1,
    },
    :width => 242,
    :column_widths => [100, 22, 60, 60]
end

bounding_box([320, 398], :width => 242, :height => 335) do
  pdf.table knowledge_skills,
    :cell_style => {
      :background_color => "FFFFFF",
      :height => 15,
      :padding => 1,
      },
      :width => 242,
      :column_widths => [100, 22, 60, 60]
end

bounding_box([70, 28], :width => 80, :height => 15) do
  text "#{@character.experience}", :size => 15, :style => :bold, :align => :center
end

pdf.start_new_page

pdf.image "#{Rails.root}/public/character_sheet_bg_pg2.jpg", :at => [0, y - 0]


bounding_box([100, 300], :width => 300, :height => 200) do 

end