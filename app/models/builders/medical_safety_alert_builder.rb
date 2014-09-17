require "builders/specialist_document_builder"

class MedicalSafetyAlertBuilder < SpecialistDocumentBuilder
private
  def document_type
    "medical_safety_alert"
  end
end
