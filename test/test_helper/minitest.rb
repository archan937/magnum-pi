class MiniTest::Test
  def setup
    $stringio ||= StringIO.new
    $stdout = $stringio
  end
  def teardown
    $stdout = STDOUT
    $stringio.truncate $stringio.rewind
  end
end