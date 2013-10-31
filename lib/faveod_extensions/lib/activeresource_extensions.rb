module Faveod
  module ActiveResourceExtensions
    module ClassMethods

    def default_scope(h)
      if h && h[:conditions]
        lambda { self.all.select{|e| 
            # TODO
          true
          }
        }
      else
        lambda { self.all }
      end
    end

    if Rails::VERSION::MAJOR > 2
      def scope(n, a)
        lambda {}
      end
    else

      def all(*args)
        opts = args.slice!(0) || {}
        opts.delete(:include) ; opts.delete(:joins)
        opts[:params] = opts.delete(:conditions) || {}
        opts[:params][:limit] = opts.delete(:limit) if opts[:limit]
        opts[:params][:offset] = opts.delete(:limit) if opts[:offset]
        find(:all, opts)
      end
      
      def first(*args)
        opts = args.slice!(0) || {}
        opts.delete(:include) ; opts.delete(:joins) ; opts.delete(:limit) ; opts.delete(:offset)
        opts[:params] = opts[:conditions] || {}
        find(:first, opts)
      end

      def named_scope(n, a)
        lambda {}
      end
    end



    if defined?(WillPaginate)
      def paginate(*args, &block)
        options = args.pop
        page, per_page, total_entries = wp_parse_options(options)
        all(options).paginate(:page => page, :per_page => per_page)
      end

    def paginate_old(*args, &block)
      options = args.pop
      page, per_page, total_entries = wp_parse_options(options)
 
      WillPaginate::Collection.create(page, per_page, total_entries) do |pager|
        count_options = options.except :page, :per_page, :total_entries, :finder
        find_options = count_options.except(:count).update(:offset => pager.offset, :limit => pager.per_page) 
        
        args << find_options
        # @options_from_last_find = nil
        find_results = self.all(*args, &block)
        pager.replace find_results
        # magic counting for user convenience:
        pager.total_entries = find_results.total_entries unless find_results.blank?
      end
    end
  end

    end
  end
end
  
