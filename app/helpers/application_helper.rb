module ApplicationHelper
  # # returns page title on per page basis, using Hartl's
  # def full_title(page_title="")
  #   base_title = "Ruby on Rails Tutorial"
  #   if page_title.empty?
  #     base_title
  #   else
  #     "#{page_title} | #{base_title}"
  #   end
  # end

  # returns page title on per page basis, using Bates's content_for
  def title(page_title="")
    content_for(:title) { page_title }
  end
end
