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
        if method_name.to_s =~ /.+\?$/
    			raise BooleanMethodError.new unless result.class == TrueClass || FalseClass
        else
          raise StringMethodError.new "#{method_name} should return a string" unless result.class == String
        end
  			result
  		else
  			super
  		end
  	end


    def self.presented(attribute, format)
      values = format.scan(/{([^{}]*)}/).flatten.map(&:to_sym)
      define_method attribute, ->(){
        h = values.each_with_object({}) do |v, o|
          o[v] = public_send(v)
        end
        sprintf(format, h)
      }
    end

    def self.string_format(attribute, format, options={})
      define_method attribute, ->(){
        format % (__getobj__.public_send(attribute) || options[:default])
      }
    end

    def self.as_string(attribute)
      # option of with, inspect etc etc
      define_method attribute, ->() {
        __getobj__.public_send(attribute).to_s
      }      
    end

    def self.method_missing(method_name, *arguments, &block)
      super
    end

    def self.html_date(method_name)
      define_method method_name, ->(){
        __getobj__.public_send(method_name).strftime('%Y-%m-%d')
      }
    end

    private

    def base_object_respond_to?(method_name)
      __getobj__.respond_to?(method_name)
    end
  	
  end
end

# Array join method
# base to call from __getobj__
# call to call on self
# strip option