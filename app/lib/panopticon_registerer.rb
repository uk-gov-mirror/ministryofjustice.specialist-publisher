require "gds_api/panopticon"

class PanopticonRegisterer
  def initialize(dependencies)
    @artefact = dependencies.fetch(:artefact)
    @api = dependencies.fetch(:api)
    @error_logger = dependencies.fetch(:error_logger)
  end

  def call
    create_or_update_artefact

    nil
  end

private
  attr_reader :artefact, :api, :error_logger

  def create_or_update_artefact
    api
      .artefact_for_slug(slug)
      .on_success { |_response| notify_of_update }
      .on_error { |_response| register_new_artefact } # TODO: make this on_not_found
  end

  def register_new_artefact
    api
      .create_artefact!(artefact_attributes)
      .on_error(&method(:log_error))
  end

  def notify_of_update
    api
      .put_artefact!(slug, artefact_attributes)
      .on_error(&method(:log_error))
  end

  def log_error(error, *_api_args)
    error_logger.call(error)
  end

  def slug
    artefact.slug
  end

  def artefact_attributes
    artefact.attributes.merge(
      owning_app: owning_app,
    )
  end

  def owning_app
    "specialist-publisher"
  end
end
