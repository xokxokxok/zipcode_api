require 'zip_code_clients'

class ZipCodeFinder
  attr_reader :zip_code, :client, :address

  def self.call(*args)
    new(*args).call
  end

  def initialize(zip_code, client_name = 'via_cep')
    @zip_code = zip_code.gsub(/[^0-9]/, '')
    @client = "ZipCodeClients::#{client_name.classify}".constantize
  end

  def call
    return unless valid_zip_code
    return cache_read if cache_read.present?

    get_zip_code_from_database || get_zip_code_from_api

    address
  end

  private

  # Just for Brazil
  def valid_zip_code
    zip_code.length == 8
  end

  def get_zip_code_from_database
    @address = Address.find_by_zip_code(zip_code).presence
    cache_write if address.present?
  end

  def get_zip_code_from_api
    addr = Address.new(client.get_zip_code_details(zip_code))

    if addr.save
      @address = addr
      cache_write
    end
  end

  def cache_read
    @cache_readed ||= Rails.cache.read("#{zip_code}/finder")
  end

  def cache_write
    Rails.cache.write("#{zip_code}/finder", address, expires_in: ENV['RAILS_CACHE_MINUTES'].to_i.minutes)
  end
end
