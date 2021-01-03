module Trestle
  module FlashHelper

    def normalize_flash_alert(flash)
      flash.is_a?(Hash) ? flash.with_indifferent_access : { message: flash }
    end

    # @return [Boolean]
    def debug_form_errors?
      Trestle.config.debug_form_errors && instance_has_errors?
    end

    # @return [Boolean]
    def instance_has_errors?
      instance.errors.any? rescue false
    end

  end
end
