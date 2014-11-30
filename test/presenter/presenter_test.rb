require_relative '../test_config'

class PresenterTest < MiniTest::Test
	StringStruct = Struct.new(:get_string)
	NumberStruct = Struct.new(:get_number)

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
end