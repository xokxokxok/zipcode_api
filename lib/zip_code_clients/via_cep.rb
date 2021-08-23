module ZipCodeClients
  class ViaCep < Base
    HOST = 'https://viacep.com.br'

    def get_zip_code_details(zip_code)
      zip_code.gsub!(/[^0-9]/, '')

      parsed_response = get("#{HOST}/ws/#{zip_code}/json").parsed_response.with_indifferent_access

      return nil unless parsed_response[:cep].present?

      {
        zip_code: zip_code,
        address: "#{parsed_response[:logradouro]} #{parsed_response[:complemento]}".squish,
        neighborhood: parsed_response[:bairro].squish,
        city: parsed_response[:localidade].squish,
        state: parsed_response[:uf].squish,
        country: 'Brasil'
      }.with_indifferent_access
    rescue RateLimitError
      raise RateLimitError, "CepLa rate limit error for #{zip_code}"
    rescue ResponseError
      raise ResponseError, "CepLa response error for #{zip_code}"
    rescue ApiError => e
      raise ApiError, "CepLa api error: #{e.message} for #{zip_code}"
    end
  end
end
