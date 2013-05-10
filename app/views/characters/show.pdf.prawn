#===== Character details =====
fill_color "6d7b68"
pdf.draw_text "CHARACTER", :size => 7, :style => :bold, :at => [74, y - 22]
fill_color "505b4d"
pdf.draw_text "CHARACTER NAME", :size => 11, :style => :bold, :at => [74, y - 39]
pdf.draw_text "SPECIES", :size => 7, :at => [74, y - 58]
pdf.draw_text "CAREER", :size => 7, :at => [74, y - 76]
pdf.draw_text "SPECIALIZATION TREES", :size => 7, :at => [74, y - 95]
fill_color "3e463b"
pdf.draw_text "#{@character.name}", :size => 14, :at => [195, y - 39]
pdf.draw_text "#{@character.race.name}", :size => 10, :at => [195, y - 58]
pdf.draw_text "#{@character.career.name}", :size => 10, :at => [195, y - 76]
pdf.text_box "#{@character.user.email}", :size => 8, :at => [458, y - 90]
#===== /Character details =====

#===== Vitals =====
fill_color "ffffff"
pdf.draw_text "SOAK VALUE", :size => 7, :style => :bold, :at => [105, 669]
pdf.draw_text "WOUNDS", :size => 7, :style => :bold, :at => [235, 669]
pdf.draw_text "STRAIN", :size => 7, :style => :bold, :at => [360, 669]
pdf.draw_text "DEFENSE", :size => 7, :style => :bold, :at => [480, 669]
fill_color "000000"
pdf.draw_text "#{@soak}", :size => 25, :style => :bold, :at => [120, y - 150]
pdf.draw_text "#{@wound_th}", :size => 25, :style => :bold, :at => [215, y - 150]
pdf.draw_text "#{@strain_th}", :size => 25, :style => :bold, :at => [340, y - 150]
pdf.draw_text "#{@defense}", :size => 25, :style => :bold, :at => [475, y - 150]
fill_color "ffffff"
pdf.draw_text "THRESHOLD", :size => 7, :style => :bold, :at => [205, 624]
pdf.draw_text "THRESHOLD", :size => 7, :style => :bold, :at => [328, 624]
pdf.draw_text "RANGED", :size => 7, :style => :bold, :at => [455, 624]
fill_color "000000"
pdf.draw_text "CURRENT", :size => 7, :style => :bold, :at => [255, 624]
pdf.draw_text "CURRENT", :size => 7, :style => :bold, :at => [380, 624]
pdf.draw_text "MELEE", :size => 7, :style => :bold, :at => [505, 624]
#===== /Vitals =====

#===== Characteristics =====
fill_color "a99f8f"
pdf.draw_text "CHARACTERISTICS", :size => 6, :style => :bold, :at => [290, y - 188]
fill_color "000000"
pdf.draw_text "#{@character.brawn}", :size => 35, :style => :bold, :at => [93, y - 235]
pdf.draw_text "#{@character.agility}", :size => 35, :style => :bold, :at => [175, y - 235]
pdf.draw_text "#{@character.intellect}", :size => 35, :style => :bold, :at => [260, y - 235]
pdf.draw_text "#{@character.cunning}", :size => 35, :style => :bold, :at => [345, y - 235]
pdf.draw_text "#{@character.willpower}", :size => 35, :style => :bold, :at => [429, y - 235]
pdf.draw_text "#{@character.presence}", :size => 35, :style => :bold, :at => [513, y - 235]
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
#===== /Characteristics =====

#===== Skills =====
fill_color "a99f8f"
pdf.draw_text "SKILLS", :size => 6, :style => :bold, :at => [302, y - 13]
fill_color "000000"

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
    :align => :center
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
#===== /Skills =====

#===== WEAPONS =====
fill_color "a99f8f"
pdf.draw_text "WEAPONS", :size => 6, :style => :bold, :at => [298, 164]
fill_color "000000"

weapons = @character.weapons.map do |weapon|
  pdf.font "Helvetica", :size=> 8
  character_skill_ranks = CharacterSkill.where("character_id = ? AND skill_id = ?", @character.id, weapon.skill.id)
  ranks = character_skill_ranks.first.ranks
  
  unless weapon.nil?
    @wq = Array.new
    weapon.weapon_quality_ranks.each do |q|
      ranks = ''
      if q.ranks > 0
        ranks = " #{q.ranks}"
      end
      @wq << "#{WeaponQuality.find_by_id(q.weapon_quality_id).name}#{ranks}"
    end
  end
  weapon_data = @wq.join(',')
  logger.debug(@wq)
  
  [
    weapon.name,
    "#{weapon.skill.name}",
    weapon.damage,
    weapon.range,
    weapon.crit,
    weapon_data #@wq #"#(@wq.join(','))",
  ]
end

bounding_box([68, 155], :width => 242, :height => 335) do
  pdf.table [
   ['WEAPON', 'SKILL', 'DAMAGE', 'RANGE', 'CRIT', 'SPECIAL']
  ],
  :cell_style => {
    :height => 10,
    :padding => 1,
    :size => 5,
    :align => :center
  },
  :width => 491,
  :column_widths => [115, 100, 42, 42, 42, 150]

  pdf.table weapons,
    :cell_style => {
      :background_color => "FFFFFF",
      :height => 12,
      :padding => [2, 3],
      :size => 6
    },
    :width => 491,
    :column_widths => [115, 100, 42, 42, 42, 150]
end
#===== /WEAPONS =====

fill_color "ffffff"
pdf.draw_text "TOTAL XP", :size => 7, :style => :bold, :at => [95, 2]
pdf.draw_text "AVAILABLE XP", :size => 7, :style => :bold, :at => [491, 2]
fill_color "000000"
bounding_box([70, 28], :width => 80, :height => 15) do
  text "#{@character.experience}", :size => 15, :style => :bold, :align => :center
end
bounding_box([70, 28], :width => 80, :height => 15) do
  text "#{@character.experience}", :size => 15, :style => :bold, :align => :center
end

pdf.start_new_page
# Background image.
pdf.image "#{Rails.root}/public/character_sheet_bg_pg2.jpg", :at => [0, y - 0]
border_color = "c8c8c8"
# Page graphics.
stroke do
  stroke_color border_color
  self.line_width = 2
  rounded_rectangle [67, 792], 327, 165, 5
  rounded_rectangle [67, 615], 327, 195, 5
  rounded_rectangle [405, 792], 153, 372, 5
  rounded_rectangle [67, 410], 491, 112, 5
  rounded_rectangle [67, 289], 491, 289, 5
end
stroke do
  fill_color "ffffff"
  # Motivations.
  pdf.fill_and_stroke_rectangle [76, 739], 309, 103
  # Obligations.
  pdf.fill_and_stroke_rectangle [76, 585], 309, 153
  # Character description.
  pdf.fill_and_stroke_rectangle [413, 739], 138, 310

end
stroke do
  stroke_color border_color
  self.line_width = 1
  # Motivations inner.
  vertical_line	739, 636, :at => 230
  horizontal_line 76, 190, :at => 708
  horizontal_line 230, 343, :at => 708

  # Obligations inner.
  vertical_line	585, 432, :at => 230
  horizontal_line 76, 190, :at => 555
  horizontal_line 76, 190, :at => 512
  horizontal_line 76, 190, :at => 472
  horizontal_line 230, 343, :at => 555
  horizontal_line 230, 343, :at => 512
  horizontal_line 230, 343, :at => 472

  # Character description inner.
  horizontal_line 413, 530, :at => 708
  horizontal_line 413, 530, :at => 688
  horizontal_line 413, 530, :at => 667
  horizontal_line 413, 530, :at => 646
  horizontal_line 413, 530, :at => 628
  horizontal_line 413, 530, :at => 606
  horizontal_line 413, 530, :at => 523
end

fill_color "787878"
pdf.draw_text "TYPE", :size => 7, :style => :bold, :at => [85, 712]
pdf.draw_text "TYPE", :size => 7, :style => :bold, :at => [239, 712]
pdf.draw_text "TYPE", :size => 7, :style => :bold, :at => [85, 558]
pdf.draw_text "TYPE", :size => 7, :style => :bold, :at => [239, 558]
pdf.draw_text "MAGNITUDE", :size => 7, :style => :bold, :at => [85, 517]
pdf.draw_text "MAGNITUDE", :size => 7, :style => :bold, :at => [239, 517]
pdf.draw_text "COMPLICATIONS", :size => 7, :style => :bold, :at => [85, 476]
pdf.draw_text "COMPLICATIONS", :size => 7, :style => :bold, :at => [239, 476]
pdf.draw_text "GENDER", :size => 7, :style => :bold, :at => [425, 712]
pdf.draw_text "AGE", :size => 7, :style => :bold, :at => [425, 692]
pdf.draw_text "HEIGHT", :size => 7, :style => :bold, :at => [425, 671]
pdf.draw_text "BUILD", :size => 7, :style => :bold, :at => [425, 650]
pdf.draw_text "HAIR", :size => 7, :style => :bold, :at => [425, 632]
pdf.draw_text "EYES", :size => 7, :style => :bold, :at => [425, 610]
pdf.draw_text "NOTABLE FEATURES", :size => 7, :style => :bold, :at => [425, 589]
pdf.draw_text "OTHER", :size => 7, :style => :bold, :at => [425, 507]

fill_color "6d7b68"
pdf.draw_text "MOTIVATIONS", :size => 7, :style => :bold, :at => [335, 754]
pdf.draw_text "CHARACTER DESCRIPTION", :size => 7, :style => :bold, :at => [455, 754]
pdf.draw_text "OBLIGATIONS", :size => 7, :style => :bold, :at => [335, 600]
pdf.draw_text "EQUIPMENT LOG", :size => 7, :style => :bold, :at => [492, 395]
pdf.draw_text "TALENT AND SPECIAL ABILITES", :size => 7, :style => :bold, :at => [437, 272]

#pdf.rounded_rectangle [300, 300], 100, 200, 20