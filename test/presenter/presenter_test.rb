require_relative '../test_config'

class PresenterTest < MiniTest::Test
	StringStruct = Struct.new(:get_string)

	def string_example
		StringStruct.new 'testy string'
	end

	def test_presenter_delegates_string_methods
		presenter = Claudia::Presenter.new string_example
		assert_equal 'testy string', presenter.get_string
	end
end