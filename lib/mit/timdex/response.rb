module Mit::Timdex
  class Response < Blacklight::Solr::Response

    include Mit::Timdex

    # TODO: This is a handwave while I figure out how best to handle the distinction between our APIs structure for single and multiple records.
    def result_type
      if records?
        self['records']
      else
        self['record']
      end
    end

    # hash map
    def d(r)
      {
        id: r.id,
        source: r.source,
        title: r.title,
        contributors: r.contributors&.map { |c| c['value'] },
        format: r.content_format,
        resource_type: r.content_type,
        summary: r.summary,
        imprint: r.imprint,
        source_link: r.source_link,
        full_record_link: r.full_record_link,
        publication_date: r.publication_date,
        subjects: r.subjects,
        locations: r.locations&.map{ |l| [l['format'], l['location'], l['collection'], l['call_number']].join(' ') },
        content_type: r.content_type,
        content_format: r.content_format,
        isbns: r.isbns,
        issns: r.issns,
        oclcs: r.oclcs,
        lccn: r.lccn,
        notes: r.notes,
        # links: r.links,
        physical_description: r.physical_description,
        languages: r.languages,
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
      if result_type.kind_of?(Array)
        result_type.each do |r|
          dm = mapper(r)
          rs.append(dm)
        end
      else
        return if empty? && !record? # we need this for searches only, not retrieves
        dm = mapper(result_type)
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

  # We have a set of records in a search array
  def records?
    self['records'].present?
  end

  # We have a single record
  def record?
    self['record'].present?
  end
end
