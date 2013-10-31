module ActionView
  module Helpers
    module FormOptionsHelper
      def option_groups_from_hash_for_select(h, option_key_method, option_value_method, selected_key = nil)
        html = []
        h.keys.sort.each do |k|
          html << "<optgroup label=\"#{html_escape(k.to_s)}\">"
          html << options_from_collection_for_select(h[k], option_key_method, option_value_method, selected_key)
          html << "</optgroup>\n"
        end
        return html.join.html_safe
      end
    end
  end
end
