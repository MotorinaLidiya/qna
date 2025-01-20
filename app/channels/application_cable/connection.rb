module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    attr_reader :warden

    def connect
      self.current_user = env['warden'].user || reject_unauthorized_connection
      @warden = env['warden'] if current_user
    end

    def renderer
      ApplicationController.renderer.tap do |default_renderer|
        default_env = default_renderer.instance_variable_get(:@env)
        env_with_warden = default_env.merge('warden' => connection.warden)
        default_renderer.instance_variable_set(:@env, env_with_warden)
      end
    end
  end
end
