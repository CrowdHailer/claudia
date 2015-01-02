require_relative '../test_config'

class PresenterTest < MiniTest::Test
	StringStruct = Struct.new(:get_string)
	NumberStruct = Struct.new(:get_number)
	BooleanStruct = Struct.new(:boolean?)
	DateTimeStruct = Struct.new(:start_datetime)

	def string_example
		StringStruct.new 'testy string'
	end

	def test_presenter_delegates_string_methods
		presenter = Claudia::Presenter.new string_example
		assert_equal 'testy string', presenter.get_string
	end

	def test_presenter_errors_for_invalid_string_method
		object = NumberStruct.new 5
		presenter = Claudia::Presenter.new object
		assert_raises Claudia::StringMethodError do
			puts presenter.get_number
		end
	end

	def test_presenter_delegates_boolean_methods
		object = BooleanStruct.new true
		presenter = Claudia::Presenter.new object
		assert_equal true, presenter.boolean?
	end

	PTest = Class.new(Claudia::Presenter) do
		string_format :get_number, '%06.1f', :default => 0
	end
	def test_single_format
			
		object = NumberStruct.new 43
		presenter = PTest.new object
		puts presenter.get_number
		object = NumberStruct.new nil
		presenter = PTest.new object
		puts presenter.get_number
	
	end

	ToSTest = Class.new(Claudia::Presenter) do
		as_string :get_string
	end

	def test_to_string
		object = StringStruct.new a: 'b'
		presenter = ToSTest.new object
		puts presenter.get_string
	end

	STest = Class.new(Claudia::Presenter) do
		string_format :get_string, 'lovey %s'
		presented :overview, '%{get_string} noo'
	end

	def test_stringy_interpret
		object = StringStruct.new 'blueberries'
		presenter = STest.new object
		puts presenter.get_string
		puts presenter.overview
	end

	# def test_class_method_missing
	# 	require 'date'
	# 	object = DateTimeStruct.new DateTime.now

	# 	presenter = Claudia::Presenter.new object
	# 	puts presenter.start_datetime
	# end

	def test_date_time_formatting
		skip
		object = DateTimeStruct.new(DateTime.new(2010, 10, 5))
		presenter = Claudia::Presenter.new object
		puts presenter.start_date
		puts presenter.start_time
	end
end
