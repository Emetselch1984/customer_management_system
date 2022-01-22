## customer_form
## 該当のコード
```ruby
  def phone_params(record_name)
    @params.require(record_name).slice(:phones).permit(phones: %i[number primary])
  end
```
フォーム欄
```html
<%= f.fields_for :phones, phone, index: index do |ff| %>
  <%= markup(:li) do |m|
    m << ff.text_field(:number)
    m << ff.check_box(:primary)
    m << ff.label(:primary, "優先")
  end %>
<% end %>
```
## each_with_index
### 使用しなかった場合
```
form[customer][phone][number]
form[customer][phone][primary]
```
となる
### 使用した場合
```
form[customer][phone][0][number]
form[customer][phone][0][primary]

form[customer][phone][1][number]
form[customer][phone][1][primary]
```
となる
### params
よって、
```ruby
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
```
このようなハッシュが送れられてくる。
これを許可するには、
```
permit(phones: %i[number primary]
```
という表記にする。

