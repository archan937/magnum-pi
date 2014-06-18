require "stringio"

class Ax < Ox::Sax

  def initialize(xml)
    @stringio = StringIO.new xml
  end

  def each(pattern, &block)
    @pattern = pattern.split("/").collect{|x| x == "" ? "*" : x}
    @block = block

    @stringio.rewind
    Ox.sax_parse self, @stringio

  ensure
    @current_path = nil
    @elements = nil
    @regexp = nil
  end

  def start_element(name)
    current_path << name
    if current_element
      add_element name
    elsif entry?
      add_element
    else
      return
    end
  end

  def attr(name, str)
    if element = current_element
      element[name.to_s] = str
    end
  end

  def text(str)
    if element = current_element
      element[:text] = str
    end
  end

  def end_element(name)
    element = finalize_element
    if entry?
      @block.call element, current_path[-1]
    end
    current_path.pop
  end

  def to_hash
    hash = {}
    each "*" do |entry|
      hash.merge! entry
    end
    hash
  end

  alias :to_enum :to_hash

private

  def current_path
    @current_path ||= []
  end

  def elements
    @elements ||= []
  end

  def entry?
    @regexp ||= begin
      pattern = @pattern.join(%q{\/}).gsub("*", %q{[^\/]+})
      Regexp.new "^#{pattern}$"
    end
    !!current_path.join("/").match(@regexp)
  end

  def current_element
    elements[-1]
  end

  def add_element(name = nil)
    element = {}
    if parent = current_element
      values = parent[name.to_s] ||= []
      element[:values] = values
      element[:index] = values.size
    end
    elements << element
  end

  def finalize_element
    if element = elements.pop
      values = element.delete :values
      index = element.delete :index
      if text = element.delete(:text)
        if element.empty?
          element = text
        elsif element["content"]
          element["content"] = [element["content"]] unless element["content"].is_a?(Array)
          element["content"] << text
        else
          element["content"] = text
        end
      end
      values[index] = element if values
    end
    element
  end

end