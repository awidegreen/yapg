#!/usr/bin/env ruby

require File.expand_path("../../lib/gallery", __FILE__)

if ARGV.size < 3
  abort "I need 'image source folder' and 'gallery-folder' and " +
  "'gallery name' as parameters"
end

in_dir = ARGV[0].dup
base_gallery_dir = ARGV[1].dup
gallery_name = ARGV[2].dup

puts "Going to create Gallery '#{gallery_name}' from #{in_dir} " +
      "in #{base_gallery_dir}"
YapgGallery::CreateGallery(in_dir, base_gallery_dir, gallery_name)
puts "Done, have a nice one!"

