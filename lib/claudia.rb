require "claudia/version"
require 'delegate'

module Claudia
	StringMethodError = Class.new(StandardError)
  class Presenter
  	def initialize(base_object)
  		@base_object = base_object
  	end

  	def __getobj__
  		@base_object
  	end

  	def method_missing(method_name, *arguments, &block)
  		if base_object_respond_to? method_name
  			result = __getobj__.public_send method_name
  			raise StringMethodError.new unless result.class == String
  			result
  		else
  			super
  		end
  	end

    private

    def base_object_respond_to?(method_name)
      __getobj__.respond_to?(method_name)
    end
  	
  end
end
