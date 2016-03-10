require 'rallyconnector'

describe RallyConnector do
  before :each do
    @connector = RallyConnector.new(YAML.load_file('./lib/configs/rally.yml'))
    @fetch = 'FormattedID,State'
    @workspace = '/workspace/' + @connector.workspace
  end
  
  describe "#new" do
    it "returns a RallyConnector object" do
        expect(@connector).to be_an_instance_of RallyConnector
        
    end
  end
  
  describe "#execute_request" do
    context "given query state=foobar" do
      it "total result count is 0 when state=foobar" do
        query = '(State = Foobar)'
        result = @connector.execute_request(:get, @connector.endpoint, {workspace: @workspace, fetch: @fetch, query: query})
        expect(result).to eql(0)
      end
    end
    context "given query state=fixed" do
      it "total result count is 1 when state=fixed" do
        query = '(State = Fixed)'
        result = @connector.execute_request(:get, @connector.endpoint, {workspace: @workspace, fetch: @fetch, query: query})
        expect(result).to eql(1)
      end
    end
  end
end