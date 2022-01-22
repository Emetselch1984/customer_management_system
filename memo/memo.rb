class Staff::CustomerSearchForm
  include ActiveModel::Model
  include Ransack
  include StringNormalizer

  attr_accessor :family_name_kana, :given_name_kana,
                :birth_year, :birth_month, :birth_mday,
                :address_type, :prefecture, :city, :phone_number,
                :gender, :postal_code, :last_four_digits_of_phone_number

  def search(object)
    binding.pry
    normalize_values
    object.result
  end

  private
  
  def normalize_values
    self.family_name_kana = normalize_as_furigana(family_name_kana)
    self.given_name_kana = normalize_as_furigana(given_name_kana)
    self.city = normalize_as_name(city)
    self.phone_number = normalize_as_phone_number(phone_number)
                            .try(:gsub,/\D/,'')
    self.postal_code = normalize_as_postal_code(postal_code)
    self.last_four_digits_of_phone_number = normalize_as_phone_number(last_four_digits_of_phone_number)
  end
end

class Staff::CustomersController < ApplicationController
  def index
    @q = Customer.ransack(params[:q])
    @search_form = Staff::CustomerSearchForm.new
    @customers = @search_form.search(@q).includes(:addresses,:phones).page(params[:page])
  end
end
