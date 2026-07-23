# frozen_string_literal: true

module HelpCenter
  class ContactsController < BaseController
    ALLOWED_ATTACHMENT_CONTENT_TYPES = %w[application/pdf image/png image/jpeg image/jpg].freeze
    ALLOWED_ATTACHMENT_EXTENSIONS = %w[.pdf .png .jpg .jpeg].freeze

    before_action :set_contact_form
    before_action :ensure_contact_form_enabled
    before_action :load_custom_fields, only: %i[new create]
    before_action :ensure_contact_form_configured, only: :create

    # TODO: Complete contact form implementation after widget is completed. Right now it's just a stub

    def new; end

    def create
      # Prepare parameters
      # The form data comes from params[:contact] which maps to the keys of the custom fields
      contact_params = params.require(:contact).permit!.to_h

      # Pass to ConversationCreator
      begin
        conversation = Channels::ContactForms::ConversationCreator.call(
          contact_form_channel: @contact_form,
          form_params: contact_params,
          attachments: contact_attachments
        )
        redirect_to contact_success_path, notice: contact_success_notice
      rescue StandardError => e
        flash.now[:alert] = I18n.t("help_center.contact.new.error", message: e.message)
        render :new, status: :unprocessable_entity
      end
    end

    def success; end

    private

    def set_contact_form
      @contact_form = current_portal.contact_form_channel
    end

    def ensure_contact_form_enabled
      unless current_portal.show_contact_form? && @contact_form.present?
        redirect_to root_path
      end
    end

    def load_custom_fields
      @custom_fields = @contact_form.custom_fields.order("custom_field_resources.position ASC")
      @contact_form_configured = @contact_form.primary_inbox.present? && @custom_fields.any?
      return if @contact_form_configured

      @contact_form_unavailable_message = I18n.t(
        "help_center.contact.new.not_configured",
        default: "This form is not yet configured. Please try again later."
      )
    end

    def ensure_contact_form_configured
      return if @contact_form_configured

      render :new, status: :service_unavailable
    end

    def contact_attachments
      attachments = Array(params[:attachments]).compact
      invalid_attachment = attachments.find do |attachment|
        extension = File.extname(attachment.original_filename.to_s).downcase

        !ALLOWED_ATTACHMENT_CONTENT_TYPES.include?(attachment.content_type) ||
          !ALLOWED_ATTACHMENT_EXTENSIONS.include?(extension)
      end

      if invalid_attachment
        raise ArgumentError, I18n.t(
          "help_center.contact.new.invalid_attachment_type",
          default: "Only PDF, PNG, and JPG files are allowed."
        )
      end

      attachments
    end

    def contact_success_notice
      return @contact_form.success_message if @contact_form.success_message.present?

      fallback = I18n.t("help_center.contact.success.notice")
      key = @contact_form.configurations.to_h["success_message_i18n_key"].presence

      key ? I18n.t(key, default: fallback) : fallback
    end
  end
end
