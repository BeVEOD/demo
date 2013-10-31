module Faveod

  module GraphMaker
    POTENTIAL_FORMATS = %w(ps svg svgz fig mif hpgl pcl png jpg gif imap cmapx dot).freeze
    POTENTIAL_ALGOS = ['dot', 'neato', 'twopi', 'circo', 'fdp'].freeze
#       dot - filter for drawing directed graphs
#       neato - filter for drawing undirected graphs
#       twopi - filter for radial layouts of graphs
#       circo - filter for circular layout of graphs
#       fdp - filter for drawing undirected graphs

    def render_graph(template, format, algo = 'dot')
      raise "Unauthorized format: '#{format}'" unless POTENTIAL_FORMATS.include?(format)
      raise "Unauthorized algo: '#{algo}'" unless POTENTIAL_ALGOS.include?(algo)

      gtp = render_to_string(:partial => template, :layout => false)
      gv = IO.popen("/usr/bin/#{algo} -q -T#{format}", "w+")
      gv.puts(gtp)
      gv.close_write
      return gv.read
    end

  end

end
