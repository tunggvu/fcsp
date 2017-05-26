module InfoUsersHelper
  def quote_content quote = ""
    quote.blank? ? t("users.social_network.add_quote") : quote
  end
end
