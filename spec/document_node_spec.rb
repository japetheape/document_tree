require 'spec_helper'

require 'document_tree'
require 'document_node'
include DocumentTree

describe DocumentNode do
  
  
  it "should have some children" do
    DocumentTree.root.children.size.should > 0
    DocumentTree.root.children.first.kind_of?(DocumentNode).should be true
  end
  
  it "should have a folder with children" do
    folder_with_children = false
    DocumentTree.root.children.each do |c|
      folder_with_children = folder_with_children || !c.children.empty?
    end
    folder_with_children.should == true
  end
  
  
  it "should read meta data of a directory without meta.txt" do
    DocumentTree.root.children[1].is_leaf?.should == false
    DocumentTree.root.children[1].meta_data[:name].should == "section"
  end
  
  
  it "should read meta data of a file with meta.txt" do
    node = DocumentTree.root.children[2]
    node.children.empty?.should == true
    node.is_leaf?.should == false
    File.exist?(node.meta_file).should == true
    node.name.should == "Some section"
    node.content.should == "sdfsdf"
  end
  
  
  it "should read meta data of a normal file" do
    node = DocumentTree.root.children[3]
    node.meta_data['name'].should == "Men"
    node.content.should == "Testerdetest"
  end


  it "should find a node" do
    found = DocumentTree.root.find_node('other_section')
    found.should_not be_nil
  end
  
  it "should have all nodes" do
    all = DocumentTree.root.all_nodes
    all.length.should == 5
  end


  it "should have a name and stuff like that" do
    node = DocumentTree.root.find_node("other_section")
    node.name.should == "adsfadasd"
    node.content.should == "asdasdasd\nasd\nasdasdasd"
  end

  it "should have a name" do
    node = DocumentTree.root
    node.name.should == "doc_tree"
  end

  describe "#raw_name" do
    it "should take a :txt options" do
      node = DocumentTree.root.find_node("other_section")
      node.raw_name.should == "other_section"
      node.raw_name(:ext => true).should == "other_section.txt"
    end
  end
  
  it "should be root" do
    DocumentTree.root.is_root?.should == true
  end
  
  
  it "should strip the 0001_" do 
    DocumentTree.root.children[0].raw_name.should == "somepage"
  end

end
