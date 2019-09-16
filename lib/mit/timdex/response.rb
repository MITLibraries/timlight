module Mit::Timdex
  class Response < Blacklight::Solr::Response

    include Mit::Timdex

    # TODO: This is a handwave while I figure out how best to handle the distinction between our APIs structure for single and multiple records.
    def handwave
      if self['records'].present?
        self['records']
      else
        self['record']
      end
    end

    # hash map
    def d(r)
      {
        id: r.id,
        title: r.title,
        format: r.content_format,
        abstract: r.summary,
        resource_type: r.content_type,
        source_link: r.source_link,
        full_record_link: r.full_record_link,
        imprint: r.imprint,
        publication_date: r.publication_date,
        contributors: r.contributors&.map { |c| c['value'] },
        subjects: r.subjects
      }
    end

    def mapper(r)
      blacklight_config.document_model.new(
        d(r),
        self
      )
    end

    def documents
      rs = []
      if handwave.kind_of?(Array)
        handwave.each do |r|
          dm = mapper(r)
          rs.append(dm)
        end
      else
        dm = mapper(handwave)
        rs.append(dm)
      end
      rs
    end
    alias_method :docs, :documents

    # short cut to response['numFound']
    def total
      self['hits'].to_s.to_i
    end

    def start
      0
    end

    def empty?
      total.zero?
    end
  end

end
