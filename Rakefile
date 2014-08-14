require "uglifier"
require "cssminify"

ASSETS_DIR = File.join(File.dirname(__FILE__), "public", "assets")
TMP_DIR = File.join(File.dirname(__FILE__), "tmp")

namespace :assets do
  namespace :js do
    desc "Clean tmp directory"
    task :clean_tmp do
      `rm -rf #{TMP_DIR}/js`
    end

    desc "Compile CoffeeScript files into minified JavaScript"
    task :compile => :clean_tmp do
      uglifier = Uglifier.new

      exclude = ["interactive.coffee"]

      Dir.chdir("#{ASSETS_DIR}/js") do
        Dir.glob(File.join("**", "*.coffee")) do |filename|
          next if exclude.include?(filename)

          js_filename = filename.gsub(/\.coffee\z/, '.js')

          puts "Compiling #{filename} => #{js_filename}"
          `coffee --compile --output #{TMP_DIR}/js #{filename}`

          puts "Minifying #{js_filename} and adding to build.js"
          File.write(
            "#{ASSETS_DIR}/js/build.js",
            uglifier.compile(File.read("#{TMP_DIR}/js/#{js_filename}")),
            mode: "a"
          )
        end
      end
    end
  end

  namespace :css do
    desc "Clean tmp directory"
    task :clean_tmp do
      `rm -rf #{TMP_DIR}/css`
      `mkdir #{TMP_DIR}/css`
    end

    desc "Compile LESS files into minified CSS"
    task :compile => :clean_tmp do
      compressor = CSSminify.new

      Dir.chdir("#{ASSETS_DIR}/css") do
        Dir.glob(File.join("**", "*.less")) do |filename|
          css_filename = filename.gsub(/\.less\z/, '.css')

          puts "Compiling #{filename} => #{css_filename}"
          `lessc --no-color #{ASSETS_DIR}/css/#{filename} #{TMP_DIR}/css/#{css_filename}`

          puts "Minifying #{css_filename} and adding to build.css"
          File.write(
            "#{ASSETS_DIR}/css/build.css",
            compressor.compress(File.read("#{TMP_DIR}/css/#{css_filename}")),
            mode: "a"
          )
        end
      end
    end
  end

  desc "Compile all static assets"
  task :compile => ["js:compile", "css:compile"]
end

task :default => "assets:compile"
