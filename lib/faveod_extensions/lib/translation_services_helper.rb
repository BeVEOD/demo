module Faveod

module TranslationServicesHelper

  LOCALES_TO_FLAG = {:fr => 'france', :ch => 'switzerland', :fr_ch => 'switzerland',
                     :en => 'great_britain', :us => 'usa', :en_us => 'usa',
                     :es => 'spain',
                     :ar => 'saudi_arabia'}.freeze

  def locale_to_png(loc)
    symb = case loc
           when String then loc.downcase.to_sym
           when nil then ''
           when Locale
             if !loc.country.blank?
               loc.country.downcase.to_sym
             else
               loc.to_s.downcase.to_sym
             end
           end

    return "flag_#{LOCALES_TO_FLAG[symb]}.png"
  end

  def std_image_flag(loc, opts={})
    size = case opts[:size]
           when 48 then 48
           else 48
           end
    return image_tag("/images/std/flags/#{size}x#{size}_plain/#{locale_to_png(loc)}", opts)
  end

end


end
