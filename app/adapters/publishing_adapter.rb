require "adapters"

class PublishingAdapter
  def save(manual, republish: false, include_sections: true, include_links: true)
    update_type = (republish ? "republish" : nil)

    save_manual_links(manual) if include_links
    save_manual_content(manual, update_type: update_type)

    if include_sections
      manual.sections.each do |section|
        if section.needs_exporting? || republish
          save_section(section, manual, update_type: update_type, include_links: include_links)
        end
      end
    end
  end

  def save_section(section, manual, update_type: nil, include_links: true)
    save_section_links(section, manual) if include_links
    save_section_content(section, manual, update_type: update_type)
  end

  def redirect_section(section, to:)
    PublishingAPIRedirecter.new(
      publishing_api: Services.publishing_api,
      entity: section,
      redirect_to_location: to
    ).call
  end

private

  def organisation_for(manual)
    Adapters.organisations.find(manual.organisation_slug)
  end

  def save_manual_links(manual)
    organisation = organisation_for(manual)

    Services.publishing_api.patch_links(
      manual.id,
      links: {
        organisations: [organisation.content_id],
        sections: manual.sections.map(&:uuid),
      }
    )
  end

  def save_manual_content(manual, update_type: nil)
    organisation = organisation_for(manual)

    ManualPublishingAPIExporter.new(
      organisation, manual, update_type: update_type
    ).call
  end

  def save_section_links(section, manual)
    organisation = organisation_for(manual)

    Services.publishing_api.patch_links(
      section.uuid,
      links: {
        organisations: [organisation.content_id],
        manual: [manual.id],
      }
    )
  end

  def save_section_content(section, manual, update_type: nil)
    organisation = organisation_for(manual)

    SectionPublishingAPIExporter.new(
      organisation, manual, section, update_type: update_type
    ).call
  end
end
