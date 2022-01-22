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
class User < ApplicationRecord
  has_many :phones , dependent: :destroy
  has_many :personal_phones, -> {
    where(address_id: nil).order(:id)
  },
           class_name: 'Phone',
           autosave: true

end

class Staff::CustomerController < ApplicationController

  def create
    @customer_form = Staff::CustomerForm.new
    @customer_form.assign_attributes(params[:form])
  end
end

class Staff::CustomerForm
  include ActiveModel::Model
  attr_accessor :customer
  def initialize(customer =nil)
    @customer = customer
    @customer ||= Customer.new(gender: 'male')
    (2 - @customer.personal_phones.size).times do
      @customer.personal_phones.build
    end
  end

  def assign_attributes(params = {})
    @params = params
    customer.assigh_attributes(customer_params)
    phones = phone_params(:customer).fetch(:phones)
    customer.personal_phones.size.times do |index|
      attributes = phones[index.to_s]
      if attributes && attributes[:number].present?
        customer.personal_phones[index].assigh_attributes(attributes)
      else
        customer.personal_phones[index].mark_for_destruction
      end
    end
  end

  private

  def customer_params
    @params.require(:customer).except(:phones).permit()
  end

  def phone_params(record_name)
    @params.require(record_name).slice(:phones).permit(phones: %i[number primary])

  end

end
params =
{
    customer: {
        phone: {
            "0" => {
                "number" => "",
                "primary" => ""
            },
            "1" => {
                "number" => "",
                "primary" => ""
            },

        }
    }
}