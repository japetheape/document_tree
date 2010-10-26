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
    @filename == DocumentTree.root.raw_filename
  end
  
  def raw_filename
    @filename
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
    if !(!is_leaf? && !File.exist?(meta_file))
      passed = false
      out = ""
      File.open(filename).each_line do |line|
        passed = true if line == "\n"
        break if passed
        out << line
      end
      YAML::load(out)
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
        if line == "\n" && !passed
          passed = true 
        else
          out << line if passed
        end
      end
    end
    out
  end
  
  # Raw folder name of this node.
  # Strips out 0001_foldername to make positioning possible
  def raw_name(options = {})
    out = /.*\/[0-9]*_?(.*)(.txt)?/.match(@filename)[1]
    out.gsub!('.txt', '') unless options[:ext]
    out
    #out.gsub('.txt', '') #
    out
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
  
  
  def name
    meta_yaml['name'] || raw_name
  end
  
  
  
  

end

