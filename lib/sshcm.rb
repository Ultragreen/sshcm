# frozen_string_literal: true

require 'sshcm/version'
require 'carioca'
require 'openssl'
require 'fileutils'
require 'base64'
require 'json'

Carioca::Registry.configure do |spec|
  spec.debug = true
  spec.init_from_file = false
  spec.config_file = '~/.sshcm/settings.yml'
  spec.config_root = 'sshcm'
end

module SSHcm
  class Error < StandardError; end
  # Your code goes here...

  class SecureStore
    attr_accessor :data

    extend Carioca::Injector
    inject service: :logger

    def initialize(storefile: '~/.sshcm/secure_store.yml', keyfile: '~/.sshcm/master.key')
      @storefile = File.expand_path(storefile)
      @keyfile = File.expand_path(keyfile)
      unless initialized?
        init!
        logger.warn(to_s) { 'Secure Store initialized' }
      end
      @data = decrypt
    end

    def initialized?
      File.exist?(@storefile) && File.exist?(@keyfile)
    end

    def add_group(name:, description: '')
      @data[:sshcm][:groups][name] = { servers: [] }
      @data[:sshcm][:groups][name][:description] = description if description
    end

    def add_server(host:, user:, password:, group:, description: '', port: 22, env: :production)
      raise 'group not found' unless @data[:sshcm][:groups].include? group

      params = method(__method__).parameters.map(&:last)
      record = params.to_h { |p| [p, binding.local_variable_get(p)] }
      record.delete(:group)
      record.delete(:description) if record[:description].empty?
      @data[:sshcm][:groups][group][:servers].push record
    end

    def save!
      encrypt(@data)
    end

    def init!
      path = File.dirname(@storefile)
      FileUtils.mkdir_p path
      generate_key
      init_data = { sshcm: { groups: {} } }
      encrypt(init_data)
    end

    private

    def generate_key
      cipher = OpenSSL::Cipher.new('aes-256-cbc')
      cipher.encrypt
      key = cipher.random_key
      iv = cipher.random_iv
      encoded_key = Base64.encode64("#{key}|#{iv}")
      unless File.exist? @keyfile
        File.write(@keyfile, encoded_key)
        FileUtils.chmod 0o400, @keyfile
      end
    end

    def decrypt
      decipher = OpenSSL::Cipher.new('aes-256-cbc')
      decipher.decrypt
      encoded_key = File.read(@keyfile)
      key, iv = Base64.decode64(encoded_key).split('|')
      decipher.key = key
      decipher.iv = iv
      encoded = File.read(@storefile)
      encrypted = Base64.decode64(encoded)
      plain = decipher.update(encrypted) + decipher.final
      YAML.load(plain)
    end

    def encrypt(data)
      encoded_key = File.read(@keyfile)
      key, iv = Base64.decode64(encoded_key).split('|')
      cipher = OpenSSL::Cipher.new('aes-256-cbc')
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv
      encrypted = cipher.update(data.to_yaml) + cipher.final
      encoded = Base64.encode64(encrypted)
      File.write(@storefile, encoded)
    end
  end

  class Application < Carioca::Container
    def initialize
      @store = SecureStore.new
      p @store.data
      @store.add_group name: 'APP1', description: 'desc'
      @store.add_group name: 'APP2'
      @store.add_server host: 'server1', user: 'user1', password: 'password', group: 'APP1'
      p @store.data
    end
  end
end
