require "support/helpers/i18n_helpers"

RSpec.configure do |config|
  config.include Features::I18nHelpers, type: :feature
end
