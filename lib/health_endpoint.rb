class HealthEndpoint
  def initialize(app)
    @app = app
  end

  def call(env)
    return 204, {}, [] if env.fetch("PATH_INFO").eql?("/health")
    @app.call(env)
  end
end