#!/usr/bin/env ruby

require File.expand_path("../../lib/gallery", __FILE__)

if ARGV.size < 2
  abort "I need 'src-dir' and 'target-dir' as parameter"
end

src_dir = ARGV[0]
target_dir = ARGV[1]

puts "Going to use src: #{src_dir} and target: #{target_dir}"
YapgGallery::CreateGalleryImages(src_dir, target_dir)
puts "Done, have a nice one!"
