require 'spec_helper'

RSpec.describe 'recipes::replica' do
  describe service('solr-replica') do
    it { should be_running }
  end
end
