require "action_view"

class PublishFormViewAdapter
  # include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def initialize(document, other_metadata, current_finder)
    @document = document
    @slug_unique = other_metadata.fetch(:slug_unique)
    @publishable = other_metadata.fetch(:publishable)
    @current_finder = current_finder
    @locals = {}
    set_text
  end

  def render
    view_renderer.render(
      template: "specialist_documents/publish_form",
      formats: ["html"],
      locals: {
        warning: locals[:warning],
        notification: locals[:notification],
        disabled: locals[:disabled],
        document: document
      }
    )
  end

private
  attr_reader :document, :current_finder

  def set_text
    publish_form_text = publish_text_hash
    if !current_user_can_publish?(document.document_type) || !slug_unique || !publishable
      if !current_user_can_publish?(document.document_type)
        locals = publish_form_text[:no_permission]
      elsif !publishable
        locals = publish_form_text[:already_published]
      elsif !slug_unique
        locals = publish_form_text[:slug_not_unique]
      end
    elsif publishable
      if !document.change_note.blank?
        locals = publish_form_text[:major_update]
      elsif document.minor_update
        locals = publish_form_text[:minor_update]
      else
        locals = publish_form_text[:new_document]
      end
    end
  end

  def publish_text_hash
    {
      no_permission: {
        disabled: true,
        warning: "You can't publish this document",
        notification: "You don't have permission to publish.",
      },
      already_published: {
        disabled: true,
        warning: "You can't publish this document",
        notification: "There's no changes to publish.",
      },
      slug_not_unique: {
        disabled: true,
        warning: "You can't publish this document",
        notification: "This document has a duplicate slug.<br/> You need to #{link_to "edit the document", [:edit, document]} and change the title to be able to be published.",
      },
      major_update: {
        disabled: false,
        warning: "You are about to publish a <strong>major edit</strong> with a public change note.",
        notification: "This will email subscribers to #{current_finder[:title]}.",
      },
      minor_update: {
        disabled: false,
        warning: nil,
        notification: "You are about to publish a <strong>minor edit</strong>.",
      },
      new_document: {
        disabled: false,
        warning: nil,
        notification: "This will email subscribers to #{current_finder[:title]}.",
      }
    }
  end


end
