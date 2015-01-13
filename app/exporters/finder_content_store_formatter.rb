class AbstractContentStoreFormatter
  def exportable_attributes
    {
      "base_path" => base_path,
      "format" => format,
      "content_id" => content_id,
      "title" => title,
      "description" => description,
      "public_updated_at" => public_updated_at,
      "update_type" => update_type,
      "publishing_app" => publishing_app,
      "rendering_app" => rendering_app,
      "routes" => routes,
      "details" => details,
      "links" => {
        "organisations" => organisations,
        "topics" => [],
        "related" => related,
      },
    }
  end

private
  def base_path
    raise NotImplementedError
  end

  def format
    raise NotImplementedError
  end

  def content_id
    raise NotImplementedError
  end

  def title
    raise NotImplementedError
  end

  def description
    raise NotImplementedError
  end

  def public_updated_at
    raise NotImplementedError
  end

  def update_type
    raise NotImplementedError
  end

  def publishing_app
    "specialist-publisher"
  end

  def rendering_app
    raise NotImplementedError
  end

  def routes
    [base_route] + extra_routes
  end

  def base_route
    {
      path: base_path,
      type: "exact",
    }
  end

  def extra_routes
    []
  end

  def details
    {}
  end

  def organisations
    []
  end

  def related
    []
  end
end
