# frozen_string_literal: true

module HelpCenter
  class ContactsController < BaseController
    ALLOWED_ATTACHMENT_CONTENT_TYPES = %w[application/pdf image/png image/jpeg image/jpg].freeze
    ALLOWED_ATTACHMENT_EXTENSIONS = %w[.pdf .png .jpg .jpeg].freeze

    before_action :set_contact_form
    before_action :ensure_contact_form_enabled
    before_action :ensure_customer_authenticated
    before_action :load_custom_fields, only: %i[new create]
    before_action :ensure_contact_form_configured, only: :create

    def new; end

    def create
      if @contact_form.spam_protection_enabled? && params[:nickname].present?
        redirect_to contact_success_path,
                    notice: contact_success_notice,
                    flash: { ticket_identifier: "REQ-#{SecureRandom.hex(4).upcase}" }
        return
      end

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
        redirect_to contact_success_path,
                    notice: contact_success_notice,
                    flash: { ticket_identifier: conversation.identifier }
      rescue StandardError => e
        flash.now[:alert] = I18n.t("help_center.contact.new.error", message: e.message)
        render :new, status: :unprocessable_entity
      end
    end

    def success
      # Only reachable right after a submission: the ticket identifier is carried
      # in the flash across the create redirect. A direct URL visit (or a refresh)
      # has no flash, so send the visitor back to the form instead.
      @ticket_identifier = flash[:ticket_identifier]
      redirect_to contact_path if @ticket_identifier.blank?
    end

    private

    def set_contact_form
      @contact_form = current_portal.contact_form_channel
    end

    def ensure_contact_form_enabled
      unless current_portal.show_contact_form? && @contact_form.present?
        redirect_to root_path
      end
    end

    # Reflects the contact form's `require_login` setting configured in the dashboard.
    #
    # NOTE: The help center portal does not yet have a customer sign-in flow, so
    # `current_customer` is always nil. Until that flow exists, enabling
    # `require_login` on a form will block all submissions. Wire `current_customer`
    # to the portal customer session once authentication is implemented.
    def ensure_customer_authenticated
      return unless @contact_form&.require_login?
      return if current_customer.present?

      redirect_to root_path, alert: I18n.t(
        "help_center.contact.new.login_required",
        default: "Please sign in to submit this form."
      )
    end

    def current_customer
      nil
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
      return [] unless @contact_form.allow_attachments?

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
