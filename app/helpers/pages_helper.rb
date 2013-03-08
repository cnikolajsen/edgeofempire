module PagesHelper

  def current_page_on(page_icon)
    if @page == page_icon
      '_on'
    else
      ''
    end
  end
  
end
