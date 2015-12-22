module EventsHelper
	def header_background_image_url
    "https://az810058.vo.msecnd.net/site/global/Content/img/home-search-bg-0#{rand(6)}.jpg"
  end

  def can_publish(event)
    signed_in? && event.ticket_types.count > 0 && !event.published && event.user_id == current_user.id
  end

  def can_edit(event)
    signed_in? && event.user_id == current_user.id
  end
end
