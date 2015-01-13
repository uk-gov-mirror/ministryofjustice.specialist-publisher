require "formatters/abstract_indexable_formatter"

class FinderIndexableFormatter < AbstractIndexableFormatter
private
  def description
    entity.description
  end

  def link
    entity.base_path
  end

  def indexable_content
    ""
  end

  def organisation_slugs
    entity.organisation_slugs
  end

  def last_update
    entity.public_updated_at
  end
end
