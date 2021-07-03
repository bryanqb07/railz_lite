require 'rack'

class Static
  attr_reader :app, :file_server, :root_paths

  def initialize(app)
    @app = app
    @root_paths = ['public', 'assets']
    @file_server = FileServer.new
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    asset_dir = get_asset_dir(path)

    if asset_dir.nil?
      app.call(env)
    else
      file_server.call(env, asset_dir)
    end
  end

  private

  # return the root directory of asset request ex => 'films/assets/app.css' would return 'assets'
  def get_asset_dir(path)
    root_paths.each { |root| return root if path.include?(root) }
    nil
  end
end


class FileServer
  MIME_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip',
    '.css' => 'text/css',
    '.js' => 'text/javascript'
  }

  def call(env, asset_dir)
    res = Rack::Response.new
    file_name = requested_file_name(env, asset_dir)

    if File.exist?(file_name)
      serve_file(file_name, res)
    else
      res.status = 404
      res.write('File not found')
    end
    [res.status, res.headers, res.body]
  end

  private

  def serve_file(file_name, res)
    extension = File.extname(file_name)
    content_type = MIME_TYPES[extension]
    file = File.read(file_name)
    res['Content-type'] = content_type
    res.write(file)
  end

  def requested_file_name(env, asset_dir)
    req = Rack::Request.new(env)
    dir = Dir.pwd
    path = req.path
    filename = File.basename(path)
    File.join(dir, asset_dir, filename)
  end
end
