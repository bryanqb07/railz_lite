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

    if can_match?(path)
      file_server.call(env)
    else
      app.call(env)
    end
  end

  private

  def can_match?(path)
    root_paths.any? { |root| path.index("/#{root}") }
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

  def call(env)
    res = Rack::Response.new
    file_name = requested_file_name(env)

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

  def requested_file_name(env)
    req = Rack::Request.new(env)
    path = req.path
    dir = Dir.pwd
    File.join(dir, path)
  end
end
