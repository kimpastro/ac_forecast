class Zipcode
  ZIP_REGEX = /\A\d{5}(-\d{4})?\z/.freeze

  def self.normalize(input)
    digits = input.to_s.gsub(/\D/, "")

    case digits.length
    when 5
      digits
    when 9
      "#{digits[0, 5]}-#{digits[5, 4]}"
    else
      nil
    end
  end

  def self.valid?(input)
    normalized = normalize(input)
    normalized.present? && ZIP_REGEX.match?(normalized)
  end
end
