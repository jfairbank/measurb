module Measurb
  # Class for managing configuration of {Measurb}
  class Config
    # Enable defaults dimensions based on their name
    #
    # @api public
    #
    # @example
    #   Measurb.configure do |config|
    #     config.enable_defaults :inches, :feet
    #   end
    #
    # @param  names [Symbol, String]        The dimension names to enable
    # @return       [Array<Symbol, String>] The dimension names that were enabled
    def enable_defaults(*names)
      enabled = []

      names.each do |name|
        path = "measurb/defaults/#{name}"

        begin
          require path
          enabled << name
        rescue LoadError
          warn "'#{name}' is not a default dimension"
        end
      end

      enabled
    end
  end
end
