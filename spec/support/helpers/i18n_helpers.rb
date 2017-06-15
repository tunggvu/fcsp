module Features
  module I18nHelpers
    def full_error model_class, attribute, message, count = nil
      @_i18n_dummies ||= {}
      @_i18n_dummies[model_class] ||= model_class.new
      if count
        errors = @_i18n_dummies[model_class].errors
          .generate_message attribute, message, count: count
      else
        errors = @_i18n_dummies[model_class].errors
          .generate_message attribute, message        
      end
      (errors.is_a? String) ? errors : errors[:other]
    end
  end
end
