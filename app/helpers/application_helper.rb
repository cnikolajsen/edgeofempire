module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Edge of the Empire"
    if @title.nil?
      base_title
    else
      "#{@title} - #{base_title}"
    end
  end

  def text_replace_tokens(text)

    text = text.gsub(/\[ability\]/, image_tag("dice/ability.png", :alt => "Ability", :class => 'dice', :size => '12'))
    text = text.gsub(/\[advantage\]/, image_tag("dice/advantage.png", :alt => "Advantage", :class => 'dice', :size => '12'))
    text = text.gsub(/\[threat\]/, image_tag("dice/threat.png", :alt => "Threat", :class => 'dice', :size => '12'))
    text = text.gsub(/\[boost\]/, image_tag("dice/boost.png", :alt => "Boost", :class => 'dice', :size => '12'))
    text = text.gsub(/\[challenge\]/, image_tag("dice/challenge.png", :alt => "Challenge", :class => 'dice', :size => '12'))
    text = text.gsub(/\[difficulty\]/, image_tag("dice/difficulty.png", :alt => "Difficulty", :class => 'dice', :size => '12'))
    text = text.gsub(/\[proficiency\]/, image_tag("dice/proficiency.png", :alt => "Proficiency", :class => 'dice', :size => '12'))
    text = text.gsub(/\[setback\]/, image_tag("dice/setback.png", :alt => "Setback", :class => 'dice', :size => '12'))
    text = text.gsub(/\[triumph\]/, image_tag("dice/triumph.png", :alt => "Triumph", :class => 'dice', :size => '12'))
    text = text.gsub(/\[despair\]/, image_tag("dice/despair.png", :alt => "Despair", :class => 'dice', :size => '12'))
    text = text.gsub(/\[success\]/, image_tag("dice/success.png", :alt => "Success", :class => 'dice', :size => '12'))
    text = text.gsub(/\[failure\]/, image_tag("dice/failure.png", :alt => "Failure", :class => 'dice', :size => '12'))
    text = text.gsub(/\[force\]/, image_tag("dice/force.png", :alt => "Force", :class => 'dice', :size => '12'))
    text = text.gsub(/\[force_white\]/, image_tag("dice/force_white.png", :alt => "Light Side", :class => 'dice', :size => '12'))
    text = text.gsub(/\[force_black\]/, image_tag("dice/force_black.png", :alt => "Dark side", :class => 'dice', :size => '12'))

    text.html_safe
  end
end
