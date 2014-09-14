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

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to name, '', :onclick => h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\");return false;")
  end

  def markdown(text)
    options = {
      filter_html: false,
      hard_wrap: true,
      #link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink: true,
      superscript: true,
      tables: true,
      disable_indented_code_blocks: true
    }

    #renderer = Redcarpet::Render::HTML.new(options)
    #markdown = Redcarpet::Markdown.new(renderer, extensions = {})

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)


    markdown.render(text).html_safe
  end

end
