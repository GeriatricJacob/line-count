module DeviseHelper
  def devise_error_messages!
    res = resource
    if res.present? and res.errors.any?
      content_tag :ul, class: 'error' do
        res.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
      end
    end
  end

  def resource
    @user
  end
end
