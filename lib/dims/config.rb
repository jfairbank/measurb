module Dims
  class Config
    def enable_defaults(*names)
      names.each do |name|
        require "dims/defaults/#{name}"
      end
    end
  end
end
