module PagesHelper

  def current_page_on(page_icon)
    if @page == page_icon
      '_on'
    else
      ''
    end
  end
  
  def current_page(page_icon)
    @page == page_icon
  end
  
end
