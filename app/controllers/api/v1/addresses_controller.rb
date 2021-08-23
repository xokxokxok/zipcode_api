module Api
  module V1
    class AddressesController < Api::V1::ApplicationController
      def show
        address = ZipCodeFinder.call(zip_code)
        if address.present?
          UserAddress.create(user_id: @current_user.id, address_id: address.id)
          render json: address.as_json
        else
          raise ActiveRecord::RecordNotFound, "Zip code not found"
        end
      end

    private

      def load_product
        @product = Product.find_by!(slug: params[:product_slug])
      end

      def zip_code
        params.permit(:zip_code).try(:[], :zip_code)
      end
    end
  end
end
