#require 'RMagick'

module Thumbnailer

  def get_thumbnail(bin, options={})
    maxwidth = options[:maxwidth] || 128
    maxheight = options[:maxheight] || 128
    aspectratio = maxwidth.to_f / maxheight.to_f

    pic = Magick::Image.from_blob(bin).first
    imgwidth = pic.columns
    imgheight = pic.rows
    imgratio = imgwidth.to_f / imgheight.to_f
    scaleratio = imgratio > aspectratio ? maxwidth.to_f / imgwidth : maxheight.to_f / imgheight
    return  pic.thumbnail(scaleratio)
  end

  def make_thumbnail(path, options={})
    maxwidth = options[:maxwidth] || 128
    maxheight = options[:maxheight] || 128
    aspectratio = maxwidth.to_f / maxheight.to_f

    pic = Magick::Image.read(path).first
    imgwidth = pic.columns
    imgheight = pic.rows
    imgratio = imgwidth.to_f / imgheight.to_f
    scaleratio = imgratio > aspectratio ? maxwidth.to_f / imgwidth : maxheight.to_f / imgheight
    thumb = pic.thumbnail(scaleratio)

    dest_path = File.join(File.dirname(path) + '__thumbs', File.basename(path))
    thumb.write(dest_path)
 end

end
