require "rubygems"
require "test/unit"
require "tempfile"
require File.expand_path("../../lib/gallery", __FILE__)

module YapgTest
  TEST_FILES_PATH = File.expand_path(File.dirname(__FILE__) + "/files")
  GALLERY_NAME = "testgallery"
  BASE_IMAGE_PATH = TEST_FILES_PATH + "/base.jpg"
end
