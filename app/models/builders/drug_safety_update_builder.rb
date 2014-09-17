require "builders/specialist_document_builder"

class DrugSafetyUpdateBuilder < SpecialistDocumentBuilder
private
  def document_type
    "drug_safety_update"
  end
end
