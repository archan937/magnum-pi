require "stringio"

class Aj < Oj::Saj

  def initialize(json)
    @stringio = StringIO.new json
  end

  def each(pattern, &block)
    @pattern = pattern.split("/").collect{|x| x == "" ? "*" : x}
    @block = block

    @stringio.rewind
    Oj.saj_parse self, @stringio

  ensure
    @types = nil
    @current_path = nil
    @entries = nil
    @regexp = nil
  end

  def hash_start(key)
    start_enum key, {}, :hash
  end

  def array_start(key)
    start_enum key, [], :array
  end

  def hash_end(key)
    end_enum
  end

  def array_end(key)
    end_enum
  end

  def add_value(value, key)
    if (entry = current_entry).nil?
      current_path << :nokey
      entries << {key => value}
      end_enum
    else
      entry[key] = value
    end
  end

  def to_enum
    enum = nil
    each "*" do |entry, key|
      enum ||= begin
        if key == :nokey
          entry
        elsif key.is_a?(String)
          {}
        else
          []
        end
      end
      enum[key] = entry if key != :nokey
    end
    enum
  end

private

  def types
    @types ||= []
  end

  def current_path
    @current_path ||= []
  end

  def entries
    @entries ||= []
  end

  def current_entry
    entries[-1]
  end

  def current_key
    current_path[-1]
  end

  def current_type
    types[-1]
  end

  def entry?
    @regexp ||= begin
      pattern = @pattern.join(%q{\/}).gsub("*", %q{[^\/]+})
      Regexp.new "^#{pattern}$"
    end
    !!current_path.join("/").match(@regexp)
  end

  def start_enum(key, entry, type)
    add_to_current_path key
    if current_entry || entry?
      add_entry entry
    end
    types << type
  end

  def end_enum
    entry = entries.pop
    if entry?
      @block.call entry, current_key
    end
    finalize_entry
  end

  def add_to_current_path(key)
    key ||= (current_entry || []).size if current_type == :array
    current_path << key if key
  end

  def add_entry(entry)
    if (parent = current_entry).nil?
      parent = (current_type == :hash ? {} : [])
      entries << parent
    end
    parent[current_key] = entry
    entries << entry
  end

  def finalize_entry
    current_path.pop
    types.pop
  end

end