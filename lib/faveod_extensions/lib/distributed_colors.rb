module Faveod
  module DistributedColors

    PRESETS = {}

    protected
    def hsv2rgb(h, s, v)
      h = h % 360; s = s % 256; v = v % 256
      f = (h * 6) % 360
      i = (255 - s * f / 360) * v / 255
      r = (255 - s ) * v / 255
      d = (255 - s * (360 - f) / 360) * v / 255
      return([v, d, r]) if(h <  60)
      return([i, v, r]) if(h < 120)
      return([r, v, d]) if(h < 180)
      return([r, i, v]) if(h < 240)
      return([d, r, v]) if(h < 300)
      return([v, r, i])
    end

    def nth_color_h(n, i, s=255, v=255)
      sprintf('#%02x%02x%02x', *hsv2rgb(360/n*i, s, v))
    end

    def nth_color_s(n, i, h=255, v=255)
      sprintf('#%02x%02x%02x', *hsv2rgb(h, 255/n*i, 255))
    end

    def nth_color_v(n, i, h=255, s=255)
      sprintf('#%02x%02x%02x', *hsv2rgb(h, s, 255/n*i))
    end

    def nth_color(n, i, j=nil, k=nil)
      j ||= i
      k ||= n - i + 1
      sprintf('#%02x%02x%02x', *hsv2rgb(360/n*j, 255 - 155/n*i, 255)) # 155/n*i, 195 + (30*(j%3))))
    end

    def get_nth_color(n, i, opts={})
      if opts[:colors]
        a = opts[:colors]
        a[n % a.size]
      elsif opts[:preset] && PRESETS[opts[:preset]]
        a = PRESETS[opts[:preset]]
        a[n % a.size]
      else
        # j = opts[:contiguous] ? i : 2*i % (n + (1 - n%2))
        d = opts[:divisions] ? opts[:divisions] : 3
        j = opts[:contiguous] ? i : (((n/d)*(i%d) + (i-1)/d) % n)
        hsv = case opts[:mode]
              when :rainbow
                nth_color_h(n, j)
              when :darken
                nth_color_s(n, j)
              when :lighten
                nth_color_v(n, j)
              else
                nth_color(n, i, j)
              end
      end
    end

    def n_colors(n, opts={})
      if opts[:preset] && PRESETS[opts[:preset]]
        a = PRESETS[opts[:preset]]
        a = n >= a.size ? a : (a* (n/a.size + 1))
        a[0..(n-1)]
      else
        (1..n).map{|i| get_nth_color(n, i, opts)}
      end
    end

  end
end
