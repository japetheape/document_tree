require 'spec_helper'

require 'document_tree'
require 'document_node'
include DocumentTree

describe DocumentTree do
  
  it "should be able to set another location" do
    DocumentTree.location.should_not be_nil

  end
  
  it "should have a root node" do
    DocumentTree.root.should_not be_nil
  end
  
end