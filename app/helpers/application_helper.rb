module ApplicationHelper
  def full_title page_title = ""
    base_title = t "title"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def not_found
    render file: "public/404.html", layout: false, status: 404
  end

  def check_paginator? page
    page.left_outer? || page.right_outer? || page.inside_window?
  end

  def view_object name
    if name.is_a?(Symbol)
      class_name = name.to_s.titleize.split(" ").join("")
    else
      class_name = name.split("/")
        .map{|name_split| name_split.titleize.sub(" ", "")}.join("::")
    end
    class_name.constantize.new(self)
  end

  def devise_mapping
    Devise.mappings[:user]
  end

  # def resource_name
  #   devise_mapping.name
  # end

  def resource_class
    devise_mapping.to
  end

  def is_warning_flash? message_type
    message_type == Settings.warning
  end

  def request_friends
    if current_user && user_signed_in?
      current_user.requested_friends.includes :avatar
    end
  end

  def link_to_add_fields name, f, association, cssclass, title
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,
      child_index: "new_#{association}") do |builder|
      render association.to_s.singularize + "_fields", f: builder
    end
    link_to name, "javascript:void(0)",
      onclick: h("add_fields(this, \"#{association}\",
      \"#{escape_javascript(fields)}\")"),
      class: cssclass, title: title
  end
end
