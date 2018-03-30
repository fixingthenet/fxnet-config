require "fxnet/config/version"
require 'json'
require 'pathname'

module Fxnet
  class Config
    def initialize(dirs:[], prefix: 'FXNET', env: ENV, add: {})
      @config={}
      @prefix=prefix
      @dirs=dirs.map do |dir|
        raise "Config path #{dir} is not a directory!" unless File.directory?(dir)
        Pathname.new(dir)
      end
      load_from_dirs
      override_with(env)
      override_with(add)
      @config
    end

    def freeze
      @config.freeze
    end

    def to_h
      @config.dup
    end
    def dig(*path)
      path.inject(@config) do |conf,name|
        conf[name.to_s]
      end
    end

    private

    def load_from_dirs
      @dirs.each do |dir|
        dir.children.sort.each do |child|
          unless child.directory?
            @config=@config.merge(JSON.parse(File.read(child)))
          end
        end
      end
    end
    def override_with(hash)
      prefix_matcher=/^#{@prefix}__(.*)/
      hash.each do |key,value|
        if result=prefix_matcher.match(key)
          path=result[1].downcase.split('__')
          add(value, *path)
        end
      end
    end

    def add(value,*path)
      config=path[0..-2].inject(@config) do |config, name|
        @config[name.to_s] ||= {}
        @config[name.to_s]
      end
      config[path[-1].to_s]=value
    end
  end
end
