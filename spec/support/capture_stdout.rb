# frozen_string_literal: true

module StdoutHelper
  def capture_stdout
    original_stdout = $stdout
    captured_output = StringIO.new
    $stdout = captured_output
    yield
    captured_output.string
  ensure
    $stdout = original_stdout
  end
end
