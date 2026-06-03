# frozen_string_literal: true

module HelpCenter
  class ContactsController < BaseController
    before_action :ensure_contact_form_enabled

    # TODO: Complete contact form implementation after widget is completed. Right now it's just a stub

    def new
      @contact_form = current_portal.contact_form_channel
      @custom_fields = @contact_form.custom_fields.order('custom_field_resources.position ASC')
    end

    def create
      @contact_form = current_portal.contact_form_channel
      
      # Prepare parameters
      # The form data comes from params[:contact] which maps to the keys of the custom fields
      contact_params = params.require(:contact).permit!.to_h

      # Pass to ConversationCreator
      begin
        conversation = Channels::ContactForms::ConversationCreator.call(
          contact_form_channel: @contact_form,
          form_params: contact_params,
          attachments: params[:attachments] || []
        )
        redirect_to contact_success_path, notice: I18n.t(
          @contact_form.configurations["success_message_i18n_key"] || "help_center.contact.success.notice",
          default: I18n.t("help_center.contact.success.notice")
        )
      rescue StandardError => e
        flash.now[:alert] = I18n.t("help_center.contact.new.error", message: e.message)
        @custom_fields = @contact_form.custom_fields.order('custom_field_resources.position ASC')
        render :new, status: :unprocessable_entity
      end
    end

    def success
      @contact_form = current_portal.contact_form_channel
    end

    private

    def ensure_contact_form_enabled
      unless current_portal.show_contact_form? && current_portal.contact_form_channel.present?
        redirect_to root_path
      end
    end
  end
end
