require "graphql/client"
require "graphql/client/http"

module TIMDEX
  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new("https://timdex.mit.edu/graphql") do
    def headers(context)
      # Optionally set any HTTP headers
      { "User-Agent": "timlight" }
    end
  end  

  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)
  # TODO: store cached copy of schema in repo
  # However, it's smart to dump this to a JSON file and load from disk
  #
  # Run it from a script or rake task
  #   GraphQL::Client.dump_schema(SWAPI::HTTP, "path/to/schema.json")
  #
  # Schema = GraphQL::Client.load_schema("path/to/schema.json")

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  Search = TIMDEX::Client.parse <<-'GRAPHQL'
    query($q: String!){
      search(searchterm: $q) {
        hits
        records {
          alternateTitles
          callNumbers
          contentType
          contents
          contributors {
            kind
            value
          }
          dois
          edition
          format
          holdings {
            callnumber
            collection
            format
            location
            notes
            summary
          }
          identifier
          imprint
          inBibliography
          isbns
          issns
          languages
          lccn
          links {
            kind
            restrictions
            text
            url
          }
          literaryForm
          notes
          numbering
          oclcs
          physicalDescription
          placeOfPublication
          publicationDate
          publicationFrequency
          relatedItems {
            kind
            value
          }
          relatedPlace
          source
          sourceLink
          subjects
          summary
          title
        }
      }
    }
  GRAPHQL

  Retrieve = TIMDEX::Client.parse <<-'GRAPHQL'
  query($id: String!){
    recordId(id: $id) {
      alternateTitles
      callNumbers
      contentType
      contents
      contributors {
        kind
        value
      }
      dois
      edition
      format
      holdings {
        callnumber
        collection
        format
        location
        notes
        summary
      }
      identifier
      imprint
      inBibliography
      isbns
      issns
      languages
      lccn
      links {
        kind
        restrictions
        text
        url
      }
      literaryForm
      notes
      numbering
      oclcs
      physicalDescription
      placeOfPublication
      publicationDate
      publicationFrequency
      relatedItems {
        kind
        value
      }
      relatedPlace
      source
      sourceLink
      subjects
      summary
      title
    }
  }
GRAPHQL
end
