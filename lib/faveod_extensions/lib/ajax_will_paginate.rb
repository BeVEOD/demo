module WillPaginate
  module ViewHelpers

    # Renders Digg-style pagination.
    # Returns nil if there is only one page in total (can't paginate that).
    #
    # Options for will_paginate view helper:
    #
    #   class:        CSS class name for the generated DIV (default "pagination")
    #   prev_label:   default '&laquo; Previous',
    #   next_label:   default 'Next &raquo;',
    #   inner_window: how many links are shown around the current page, defaults to 4
    #   outer_window: how many links are around the first and the last page, defaults to 1
    #   separator:    string separator for page HTML elements, default " " (single space)
    #   param_name:   parameter name for page number in URLs, defaults to "page"
    #   update:       a div element to be updated with the result
    #   params:       additional params elements to be passed through the request when paginating
    #
    # All extra options are passed to the generated container DIV, so eventually
    # they become its HTML attributes.
    #
    def ajax_will_paginate(entries = @entries, options = {})
      update = options.delete(:update)
      options[:params] ||= {}
      submit = options[:params].delete(:submit)

      total_pages = entries.respond_to?(:page_count) ?  entries.page_count  : entries.total_pages

      if total_pages > 1
        options = options.symbolize_keys.reverse_merge(pagination_options)
        page, param = entries.current_page, options.delete(:param_name)

        inner_window, outer_window = options.delete(:inner_window).to_i, options.delete(:outer_window).to_i
        min = page - inner_window
        max = page + inner_window
        # adjust lower or upper limit if other is out of bounds
        if max > total_pages then min -= max - total_pages
        elsif min < 1  then max += 1 - min
        end

        current   = min..max
        beginning = 1..(1 + outer_window)
        tail      = (total_pages - outer_window)..total_pages
        visible   = [beginning, current, tail].map(&:to_a).flatten.sort.uniq
        links, prev = [], 0

        visible.each do |n|
          next if n < 1
          break if n > total_pages

          unless n - prev > 1
            prev = n
            links << ajax_page_link_or_span(update, submit, (n != page ? n : nil), 'current', n, param, options)
          else
            # ellipsis represents the gap between windows
            prev = n - 1
            links << '...'
            redo
          end
        end

        # next and previous buttons
        links.unshift ajax_page_link_or_span(update, submit, entries.previous_page, 'disabled', options.delete(:prev_label), param, options)
        links.push    ajax_page_link_or_span(update, submit, entries.next_page,     'disabled', options.delete(:next_label), param, options)

        content_tag :div, links.join(options.delete(:separator)), options
      end
    end

    protected
    def ajax_page_link_or_span(update, submit, page, span_class, text, param, options = {})
      unless page
        content_tag :span, text, :class => span_class
      else
        # page links should preserve GET parameters, so we merge params
        # We also needs to add additional parameters send through options[:params]
        options[:params] ||= {}
        hash_opts = {}
        hash_opts[:update] = update if !update.nil?
        hash_opts[:submit] = submit
        hash_opts[:url] = params.merge(param.to_sym => (page !=1 ? page : nil)).merge(options[:params])
        link_to_remote text, hash_opts
      end
    end
  end
end
