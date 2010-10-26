require 'yaml'
class DocumentNode

  def initialize(filename)
    @filename = filename
  end
  
  def children
    files = Dir.glob(File.join(@filename, '*'))
    files.reject {|x| /meta\.txt/.match(x) }.map{ |x| DocumentNode.new(x) }
  end


  def is_root?
    @filename == DocumentTree.root
  end
  
  def is_leaf?
    !File.directory?(@filename)
  end
  
  
  def filename
    is_leaf? ? @filename : meta_file
  end
  
  
  def meta_file
    File.join(@filename, 'meta.txt')
  end
  
  
  def meta_data
    meta_yaml
  end
  
  def meta_yaml
    if is_leaf?
      passed = false
      out = ""
      File.open(filename).each_line do |line|
        break if passed
        out << line
        passed = true if line == "\n"
      end
      YAML::load(out)
    elsif File.exist?(meta_file)
      YAML::load(File.open(meta_file))
    else
      {:name => raw_name}
    end
  end
  
  
  def content
    out = ""
    passed = false

    File.open(filename) do |f|      
      f.each_line do |line|
        out << line if passed
        passed = true if line == "\n"
      end
    end
    out
  end
  
  def raw_name 
    /.*\/(.*)/.match(@filename)[1]
  end

  

  

end

