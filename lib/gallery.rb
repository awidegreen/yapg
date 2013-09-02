module YapgGallery
  require "mini_magick"
  @@GALLERY_IMAGE_SIZE = 1000
  @@GALLERY_THUMBNAIL_SIZE = 75
  @@GALLERY_IMAGES_PATH = "images/"
  @@GALLERY_THUMBNAILS_PATH = "thumbs/"

  def self.getImageSize
    @@GALLERY_IMAGE_SIZE
  end

  def self.getThumbSize
    @@GALLERY_THUMBNAIL_SIZE
  end

  def self.getImagePath
    @@GALLERY_IMAGES_PATH
  end

  def self.getThumbnailPath
    @@GALLERY_THUMBNAILS_PATH
  end

  # Create Thumbnail for  given file.
  # * +file_or_url base image as a file url or File instance
  # * +height The height of the target thumbnail
  # * +width The width of the target thumbnail
  def self.CreateThumbnail(file_or_url, out_file_url, size = @@GALLERY_THUMBNAIL_SIZE)
    return false unless File.exists?(file_or_url.to_s)

    puts "create thumb for #{file_or_url.to_s}: #{size}x#{size} to #{out_file_url}"
    image = MiniMagick::Image.open(file_or_url)
    image.combine_options do |c|
      c.resize "#{size}x#{size}^"
      c.gravity "center"
      c.crop "#{size}x#{size}+0+0"
      c.repage.+
      c.auto_orient
    end
    image.write out_file_url
    return true
  end


  # Creates a Gallery Image, depending on the configure max size, see parameter
  # and default value
  # * +file_or_url - The source file which should be used for creation.
  # * +out_file_url - The target, created file.
  # * +size The max dimensional size of the image, either height or width
  def self.CreateImage(file_or_url, out_file_url, size = @@GALLERY_IMAGE_SIZE)
    return false unless File.exists?(file_or_url)

    require 'mini_magick'

    image = MiniMagick::Image.open(file_or_url)
    image.combine_options do |c|
      c.auto_orient
      c.resize "#{size}x#{size}"
      c.repage.+
    end
    image.write "#{out_file_url}"
    return true
  end
  
  # Create gallery images from the +in_path_url to the +out_path_url.
  def self.CreateImages(in_path_url, out_path_url)
    # dir checks
    if !File.directory?(in_path_url) or !File.directory?(out_path_url)
      abort("One of the params is not a directory: #{in_path_url} and #{out_path_url}")
    end

    #in_path_url << "/" unless in_path_url.end_with?("/")
    #out_path_url << "/" unless out_path_url.end_with?("/")

    img_pttrn = in_path_url + "*.jpg"
    # get all jpgs in dir - jpg is case-insensitive
    Dir.glob(img_pttrn, File::FNM_CASEFOLD) do |file|
      bsnme = File.basename(file)
      abort "Could not create Gallery image." unless 
                          self.CreateImage(file, "#{out_path_url}#{bsnme}")
    end
  end

  # Create thumbnails for the given gallery path
  def self.CreateThumbnails(in_path_url, out_path_url)
    # dir checks
    if !File.directory?(in_path_url) or !File.directory?(out_path_url)
      abort("One of the params is not a directory: #{in_path_url} and #{out_path_url}")
    end

    img_pttrn = in_path_url + "*.jpg"
    # get all jpgs in dir - jpg is case-insensitive
    Dir.glob(img_pttrn, File::FNM_CASEFOLD) do |file|
      bsnme = File.basename(file)
      abort "Could not create Thumbnail." unless 
                          self.CreateThumbnail(file, "#{out_path_url}#{bsnme}")
    end
  end

  # Create a Gallery with directory as source directory a base path for
  # the galleries and the Gallery name which shall be created.
  def self.CreateGallery(in_path_url, galleries_base_path, gallery_name)
    # dir checks
    if !File.directory?(in_path_url) or !File.directory?(galleries_base_path)
      abort("One of the params is not a directory: #{in_path_url} and " +
            "#{galleries_base_path}")
    end
    puts "Using #{in_path_url} as image source"

    # path preparations
    galleries_base_path << "/" unless galleries_base_path.end_with?("/")
    in_path_url << "/" unless in_path_url.end_with?("/")

    gallery_path = galleries_base_path + gallery_name
    gallery_path << "/" unless gallery_path.end_with?("/")
    Dir.mkdir(gallery_path)

    gallery_image_out_path  = 
      "#{gallery_path}#{@@GALLERY_IMAGES_PATH}"
    # create <gallery path>/images if not exists
    unless Dir.exists?(gallery_image_out_path)
      puts "Going to create images directory: #{gallery_image_out_path}"
      Dir.mkdir(gallery_image_out_path) 
    end

    gallery_thumbs_out_path = 
      "#{gallery_path}#{@@GALLERY_THUMBNAILS_PATH}"
    # create <gallery path>/thumbs if not exists
    unless Dir.exists?(gallery_thumbs_out_path)
      puts "Going to create thumbnails directory: #{gallery_thumbs_out_path}"
      Dir.mkdir(gallery_thumbs_out_path) 
    end

    img_pttrn = in_path_url + "*.jpg"
    # get all jpgs in dir - jpg is case-insensitive
    Dir.glob(img_pttrn, File::FNM_CASEFOLD) do |file|
      puts "Create Gallery entry from file " + file 
      bsnme = File.basename(file)
      unless self.CreateImage(file, "#{gallery_image_out_path}#{bsnme}")
        puts "Could not create GalleryImage."
        return false
      end
      unless self.CreateThumbnail(file, "#{gallery_thumbs_out_path}#{bsnme}")
        puts "Could not create Thumbnail."
        return false
      end
    end              
    return true
  end
end

