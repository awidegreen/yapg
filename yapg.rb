require 'sinatra'
require 'slim'

Slim::Engine.set_default_options :pretty => true 

module YAPGConfig
  GALLERIES_PATH = "public/galleries"
  IMAGE_FOLDER = "images"
end

class Yapg < Sinatra::Base
  get '/' do 
    @galleries = Dir.entries(YAPGConfig::GALLERIES_PATH).select { |entry| 
      !( entry.start_with?(".") )
    }
    slim :'index'
  end

  get "/gallery/:selected" do
    @gallery = params[:selected] 
    path = "#{YAPGConfig::GALLERIES_PATH}/#{@gallery}/#{YAPGConfig::IMAGE_FOLDER}/"
    img_pttrn = path + "*.jpg"
    # get all jpgs in dir - jpg is case-insensitive
    @files = Dir.glob(img_pttrn, File::FNM_CASEFOLD).map {
      |e| File.basename(e) 
    }.sort
    @gallery_path = "galleries/#{@gallery}"
    slim :'gallery'
  end
end

# set up the default variales for the app
Yapg.set :title, "Yet Another Photo Gallery"
