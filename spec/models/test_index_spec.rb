require 'spec_helper'

describe TestIndex do
  describe 'methods' do
    subject { TestIndex }
    it { should respond_to :index }
    it { should respond_to :search }
  end

  describe '#index' do
    describe 'search options' do
      before do
        Factory(:test_index, :name => 'Foo')
        @item = Factory(:test_index)
        TestIndex.index { |i| i.search :name }
      end

      context 'and searching for an existing record' do
        subject { TestIndex.search(:search => @item.name) }
        it { should == [@item] }
      end

      context 'and searching for a non-existent record' do
        subject { TestIndex.search(:search => 'bar') }
        it { should == [] }
      end

      context 'and searching for a similar record' do
        subject { TestIndex.search(:search => @item.name[0..2]) }
        it { should == [@item] }
      end

      context 'and no search is provided' do
        subject { TestIndex.search }
        it { should == TestIndex.all }
      end
    end
    
    describe 'sort options' do
      before do
        @items = ['b','a','c'].collect { |c| Factory(:test_index, :name => "Item #{c}") }
        TestIndex.index do |i|
          i.sort :name, :created_at
          i.default_sort :name, :asc
        end
      end

      context 'sorting on name asc' do
        subject { TestIndex.search(:sort => 'name', :direction => 'asc') }
        it { should == @items.sort { |i,j| i.name <=> j.name } }
      end

      context 'sorting on name desc' do
        subject { TestIndex.search(:sort => 'name', :direction => 'desc') }
        it { should == @items.sort { |i,j| i.name <=> j.name }.reverse }
      end

      context 'sorting on default column and direction' do
        subject { TestIndex.search }
        it { should == @items.sort { |i,j| i.name <=> j.name } }
      end

      context 'sorting on default column desc' do
        subject { TestIndex.search(:direction => 'desc') }
        it { should == @items.sort { |i,j| i.name <=> j.name }.reverse }
      end

      context 'sorting on default column asc' do
        subject { TestIndex.search(:direction => 'asc') }
        it { should == @items.sort { |i,j| i.name <=> j.name } }
      end

      context 'soring on default direction name' do
        subject { TestIndex.search(:sort => 'name') }
        it { should == @items.sort { |i,j| i.name <=> j.name } }
      end

      context 'sorting on default direction created_at' do
        subject { TestIndex.search(:sort => 'created_at') }
        it { should == @items }
      end

    end

    describe 'paginate options' do
      before do
        @items = 1.upto(5).collect { Factory(:test_index) }
        TestIndex.index do |i|
          i.paginate 2
        end
      end

      context 'default paginatation' do
        subject { TestIndex.search }
        it { should == @items[0..1] }
      end

      context 'default pagination with page number' do
        subject { TestIndex.search(:page => 2) }
        it { should == @items[2..3] }
      end

      context 'custom pagination' do
        subject { TestIndex.search(:per_page => 3) }
        it { should == @items[0..2] }
      end
    end
  end
end
