require "test_helper"

class YapgTestCase < Test::Unit::TestCase
  include YapgGallery
  include YapgTest

  def test_create_thumb
    tmp_file = Tempfile.new("thumb")
    assert YapgGallery::CreateThumbnail(BASE_IMAGE_PATH, tmp_file.path)

    tmp_file.rewind

    chk_thmb = MiniMagick::Image.read(tmp_file)
    assert chk_thmb.valid?
    assert chk_thmb[:width]  == YapgGallery::getThumbSize()
    assert chk_thmb[:height] == YapgGallery::getThumbSize()
    
    tmp_file.close!
  end

  def test_create_image
    tmp_file = Tempfile.new("image")
    assert YapgGallery::CreateImage(BASE_IMAGE_PATH, tmp_file.path)
    
    assert File.exists?(tmp_file)
    chk_img = MiniMagick::Image::read(tmp_file)
    assert chk_img.valid?

    assert ( chk_img[:height] == YapgGallery::getImageSize() || 
             chk_img[:width] == YapgGallery::getImageSize())

    tmp_file.close!
  end

  def test_create_gallery

    Dir.mktmpdir { |tmpdir|
      assert YapgGallery::CreateGallery(TEST_FILES_PATH, 
                                        tmpdir, GALLERY_NAME)
      str = tmpdir + GALLERY_NAME + "/" +  YapgGallery::getThumbnailPath()
      assert File.directory?(str)
      assert File.directory?(tmpdir + "/" + GALLERY_NAME + "/" +
                             YapgGallery::getImagePath())
    }
  end
end

