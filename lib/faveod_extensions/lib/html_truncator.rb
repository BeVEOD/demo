module Faveod
module HtmlTruncator

  def truncatewords_with_closing_tags(input, opts = {})
    return '' if input.blank?
    wordlist = input.to_s.split
    l = (opts[:words] || 15).to_i - 1
    l = 0 if l < 0
    wordstring = wordlist.length > l ? wordlist[0..l].join(" ") : input

    h1 = {}
    h2 = {}
    wordstring.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |t| h1[t[0]] ? h1[t[0]] += 1 : h1[t[0]] = 1 }
    wordstring.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each { |t| h2[t[0]] ? h2[t[0]] += 1 : h2[t[0]] = 1 }
    h1.each {|k,v|
      wordstring << "</#{k}>" * (h1[k] - h2[k].to_i) if h2[k].to_i < v
    }
    return wordstring + (opts[:end_string] || '...')
  end

  def truncate_with_closing_tags(input, opts = {})
    return truncatewords_with_closing_tags(input, opts) if opts[:words]
    return '' if input.blank?
    chars = opts[:chars] || 100
    code = truncate(input, chars).chop.chop.chop
    h1 = {}
    h2 = {}
    code.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |t| h1[t[0]] ? h1[t[0]] += 1 : h1[t[0]] = 1 }
    code.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each { |t| h2[t[0]] ? h2[t[0]] += 1 : h2[t[0]] = 1 }
    h1.each {|k,v|
      code << "</#{k}>" * (h1[k] - h2[k].to_i) if h2[k].to_i < v
    }
    return code + (opts[:end_string] || '...')
  end

end
end
