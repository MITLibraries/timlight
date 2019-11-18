require 'timdex'
module Mit::Timdex
  class Repository < Blacklight::AbstractRepository

    def find(id, params = {})
      response = Timdex.new.retrieve(id)
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
      response = Timdex.new.search(params[:q] || '')
      blacklight_config.response_model.new(
        response, {},
        document_model: blacklight_config.document_model,
        blacklight_config: blacklight_config
      )
    end
  end
end
