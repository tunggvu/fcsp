class UserSocialNetworksController < ApplicationController
  before_action :authenticate_user!

  def create
    SocialNetwork.transaction do
      social_network_params.each do |type, url|
        current_user.social_networks.create! social_network_type: type, url: url
      end
    end
    render_json t(".success"), 200, get_link_social_network
  rescue
    render_json t(".fail"), 400
  end

  def update
    SocialNetwork.transaction do
      social_network_params.each do |type, url|
        current_user.social_networks.send(type).first
          .update_attributes! social_network_type: type, url: url
      end
    end
    render_json t(".success"), 200, get_link_social_network
  rescue
    render_json t(".fail"), 400
  end

  private

  def social_network_params
    JSON.parse params.require :social_network
  end

  def render_json message, status_code, link = nil
    respond_to do |format|
      format.json do
        render json: {flash: message, status: status_code, link: link}
      end
    end
  end

  def get_link_social_network
    networks = %w(facebook google twitter linkedin skype youtube instagram)
    networks.each_with_object({}) do |network, links|
      links[network.to_s] = current_user.link_social_network(network)
      links
    end
  end
end
