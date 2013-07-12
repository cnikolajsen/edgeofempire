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
    
    text = text.gsub(/\[ability\]/, image_tag("dice/ability.png", :alt => "Ability", :class => 'dice'))
    text = text.gsub(/\[advantage\]/, image_tag("dice/advantage.png", :alt => "Advantage", :class => 'dice'))
    text = text.gsub(/\[threat\]/, image_tag("dice/threat.png", :alt => "Threat", :class => 'dice'))
    text = text.gsub(/\[boost\]/, image_tag("dice/boost.png", :alt => "Boost", :class => 'dice'))
    text = text.gsub(/\[challenge\]/, image_tag("dice/challenge.png", :alt => "Challenge", :class => 'dice'))
    text = text.gsub(/\[difficulty\]/, image_tag("dice/difficulty.png", :alt => "Difficulty", :class => 'dice'))
    text = text.gsub(/\[proficiency\]/, image_tag("dice/proficiency.png", :alt => "Proficiency", :class => 'dice'))
    text = text.gsub(/\[setback\]/, image_tag("dice/setback.png", :alt => "Setback", :class => 'dice'))
    text = text.gsub(/\[triumph\]/, image_tag("dice/triumph.png", :alt => "Triumph", :class => 'dice'))
    text = text.gsub(/\[despair\]/, image_tag("dice/despair.png", :alt => "Despair", :class => 'dice'))
    text = text.gsub(/\[success\]/, image_tag("dice/success.png", :alt => "Success", :class => 'dice'))
    text = text.gsub(/\[failure\]/, image_tag("dice/failure.png", :alt => "Failure", :class => 'dice'))
    text = text.gsub(/\[force\]/, image_tag("dice/force.png", :alt => "Force", :class => 'dice'))
    text = text.gsub(/\[force_white\]/, image_tag("dice/force_white.png", :alt => "Light Side", :class => 'dice'))
    text = text.gsub(/\[force_black\]/, image_tag("dice/force_black.png", :alt => "Dark side", :class => 'dice'))
    
    text.html_safe
  end
end
