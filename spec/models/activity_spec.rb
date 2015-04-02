require 'rails_helper'

RSpec.describe Activity, :type => :model do
  describe '#valid_duration' do
    context 'Duration is nil' do
      it 'Should raise error - duration cant be blank' #do
      #end
    end
    context 'Duration is negative' do
      it 'should raise error - duration cant be less than 0' #do
      #end
    end
    context 'Duration is greater than one day' do
      it 'should be ' #do
      #end
    end
  end
end
