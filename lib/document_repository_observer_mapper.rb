class DocumentRepositoryObserverMapper
  def initialize(mapping = nil)
    @mapping = mapping || repository_listeners_map
  end

  def all
    mapping.values
  end

  def for_types(*document_types)
    document_types.map { |type| mapping.fetch(type) }
  end

private
  attr_reader :mapping

  def repository_listeners_map
    {
      "cma_case" => RepositoryObserversTuple.new(
        repository_registry.for_type("cma_case"),
        CmaCaseObserversRegistry.new.republication,
      ),
      "aaib_report" => RepositoryObserversTuple.new(
        repository_registry.for_type("aaib_report"),
        AaibReportObserversRegistry.new.republication,
      ),
      "international_development_fund" => RepositoryObserversTuple.new(
        repository_registry.for_type("international_development_fund"),
        InternationalDevelopmentFundObserversRegistry.new.republication,
      ),
      "medical_safety_alert" => RepositoryObserversTuple.new(
        repository_registry.for_type("medical_safety_alert"),
        MedicalSafetyAlertObserversRegistry.new.republication,
      ),
      "drug_safety_update" => RepositoryObserversTuple.new(
        repository_registry.for_type("drug_safety_update"),
        DrugSafetyUpdateObserversRegistry.new.republication,
      ),
      "raib_report" => RepositoryObserversTuple.new(
        repository_registry.for_type("raib_report"),
        RaibReportObserversRegistry.new.republication,
      ),
    }
  end

  def repository_registry
    @repository_registry ||= SpecialistPublisherWiring.get(:repository_registry)
  end

  class RepositoryObserversTuple < Struct.new(:repository, :observers); end
end
