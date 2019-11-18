module Mit::Timdex
  class Repository < Blacklight::AbstractRepository

    def find(id, params = {})
      response = TIMDEX::Client.query(TIMDEX::Retrieve, variables: {id: id})
      blacklight_config.response_model.new(
        response, {},
        document_model: blacklight_config.document_model,
        blacklight_config: blacklight_config
      )
      # TODO: handle unfound records
      # rescue
      #   raise Blacklight::Exceptions::RecordNotFound
    end

    def search(params = {})
      response = TIMDEX::Client.query(TIMDEX::Search, variables: {q: params[:q] || ''})
      blacklight_config.response_model.new(
        response, {},
        document_model: blacklight_config.document_model,
        blacklight_config: blacklight_config
      )
    end
  end
end
