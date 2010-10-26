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
  
  # Is it a directory or just a file?
  def is_leaf?
    !File.directory?(@filename)
  end
  
  # Filename
  def filename
    is_leaf? ? @filename : meta_file
  end
  
  
  def meta_file
    File.join(@filename, 'meta.txt')
  end
  
  
  def meta_data
    meta_yaml
  end
  
  # The meta information of this node. If it's a file, than the meta.txt of it's child files is taken, else
  # the file itself is taken. From this file the top part must be the YAML meta data.
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
  
  # The content of the node, that is: the part after
  # the yaml file.
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
  
  # Raw folder name of this node.
  # Strips out 0001_foldername to make positioning possible
  def raw_name 
    /.*\/[0-9]*(.*)(.txt)?/.match(@filename)[1].gsub('.txt', '')
  end

  # Searches breadth first till name is found
  def find_node(name)
    to_search = self.children
    while !to_search.empty?
      n = to_search.pop
      return n if n.raw_name == name
      to_search += n.children
    end
    nil
  end
  
  
  # Searches breadth first till name is found
  def all_nodes
    all = self.children
    to_search = self.children
    while !to_search.empty?
      n = to_search.pop
      to_search += n.children
      all += n.children
    end
    all
  end
  
  
  
  

end

