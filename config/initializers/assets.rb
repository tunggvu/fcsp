# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(education/project_member.js admin/admin.css admin/admin.js
  template education.scss education/project_search education/management/groups
  education.js employer.scss employer.js education/trainings.js
  education/projects.js education/posts_search.js education/management/feedbacks
  education/management/group_users education/management/users job users friend_ship
  education/management/categories language_search org_search user_education user_education_form
  user_education_search_result ckeditor/filebrowser/images/gal_del.png awards
  user_social_network user_link certificates user_portfolios)
