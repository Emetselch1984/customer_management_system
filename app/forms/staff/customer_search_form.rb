# このフォームオブジェクトはテキスト通りに書いただけで、意味はない。
# 意味がないとは、各属性はnilなので、nilを正規化した後、
# ransackの結果が表示されるから。
# よって、このフォームオブジェクトを作らなくていい。
# 勉強用で保存。
class Staff::CustomerSearchForm
  include ActiveModel::Model
  include Ransack
  include StringNormalizer

  attr_accessor :family_name_kana, :given_name_kana,
                :birth_year, :birth_month, :birth_mday,
                :address_type, :prefecture, :city, :phone_number,
                :gender, :postal_code, :last_four_digits_of_phone_number
  def search(object)
    normalize_values
    object.result
  end

  private

  def normalize_values
    self.family_name_kana = normalize_as_furigana(family_name_kana)
    self.given_name_kana = normalize_as_furigana(given_name_kana)
    self.city = normalize_as_name(city)
    self.phone_number = normalize_as_phone_number(phone_number)
                        .try(:gsub, /\D/, '')
    self.postal_code = normalize_as_postal_code(postal_code)
    self.last_four_digits_of_phone_number =
      normalize_as_phone_number(last_four_digits_of_phone_number)
  end
end


