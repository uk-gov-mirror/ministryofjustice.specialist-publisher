require "delegate"

class ManualWithDocuments < SimpleDelegator
  def self.create(attrs)
    ManualWithDocuments.new(
      SectionBuilder.new,
      Manual.new(attrs),
      sections: [],
    )
  end

  def initialize(section_builder, manual, sections:, removed_sections: [])
    @manual = manual
    @sections = sections
    @removed_sections = removed_sections
    @section_builder = section_builder
    super(manual)
  end

  def documents
    @sections.to_enum
  end

  def removed_documents
    @removed_sections.to_enum
  end

  def build_section(attributes)
    section = section_builder.call(
      self,
      attributes
    )

    add_section(section)

    section
  end

  def publish
    manual.publish do
      documents.each(&:publish!)
    end
  end

  def reorder_sections(section_order)
    unless section_order.sort == @sections.map(&:id).sort
      raise(
        ArgumentError,
        "section_order must contain each section_id exactly once",
      )
    end

    @sections.sort_by! { |doc| section_order.index(doc.id) }
  end

  def remove_section(section_id)
    found_section = @sections.find { |d| d.id == section_id }

    return if found_section.nil?

    removed = @sections.delete(found_section)

    return if removed.nil?

    @removed_sections << removed
  end

private

  attr_reader :section_builder, :manual

  def add_section(section)
    @sections << section
  end
end
