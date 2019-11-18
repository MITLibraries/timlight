module Mit::Timdex
  class Response < Blacklight::Solr::Response

    include Mit::Timdex

    # hash map
    def d(r)
      {
        alternate_titles: r.alternate_titles,
        call_numbers: r.call_numbers,
        content_type: r.content_type,
        contributors: r.contributors&.map{ |x| "#{x.value} (#{x.kind})" },
        dois: r.dois,
        edition: r.edition,
        format: r.format,
        holdings: r.holdings,
        id: r.identifier,
        imprint: r.imprint,
        in_bibliography: r.in_bibliography,
        isbns: r.isbns,
        issns: r.issns,
        languages: r.languages,
        lccn: r.lccn,
        links: r.links&.map{ |x| x.url },
        literary_form: r.literary_form,
        notes: r.notes,
        numbering: r.numbering,
        oclcs: r.oclcs,
        physical_description: r.physical_description,
        place_of_publication: r.place_of_publication,
        related_items: r.related_items,
        related_place: r.related_place,
        source: r.source,
        source_link: r.source_link,
        subjects: r.subjects,
        summary: r.summary,
        title: r.title
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
      if response.data.respond_to?('record_id')
        return if empty? && !record? # we need this for searches only, not retrieves
        dm = mapper(response.data.record_id)
        rs.append(dm)
      elsif response.data.search.kind_of?(Array)
        response.data.search.each do |r|
          dm = mapper(r)
          rs.append(dm)
        end
      end
      rs
    end
    alias_method :docs, :documents

    # short cut to response['numFound']
    def total
      # TODO: our graphql endpoint doesn't provide this data. It should.
      1
    end

    def start
      0
    end

    def empty?
      total.zero?
    end
  end
end
