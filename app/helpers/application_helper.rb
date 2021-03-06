module ApplicationHelper
  def full_title page_title
    base_title = t "titlecontent"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def init_user
    @user ||= current_user
  end
end
