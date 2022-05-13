require "sshcm/version"
require 'carioca'
require 'secure_yaml'

Carioca::Registry.configure do |spec|
  spec.debug = true
  spec.init_from_file = false
  spec.config_file = '~/.sshcm/settings.yml'
  spec.config_root = 'sshcm'
end


module SSHcm
  class Error < StandardError; end
  # Your code goes here...


  class Application < Carioca::Container
    def test
      logger.info(self.to_s) { "Log me as an instance method" }
    end


  end


  class SecureStore

    def initialize




      @data = SecureYaml::load(File.open('./database.yml'))
    end

  end

  

end



