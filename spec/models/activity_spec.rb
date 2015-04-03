require 'rails_helper'

RSpec.describe Activity, :type => :model do
  describe '#valid_duration' do
    context 'Duration is nil' do
      it 'Should raise error - duration cant be blank' do
        activity = Activity.new({:name => "running",
                              :duration => ""})
        assert !activity.valid?
        expect(activity.errors.full_messages[0]).to eq("Duration can't be blank")
      end
    end
    context 'Duration is negative' do
      it 'should raise error - duration cant be less than 0' do
        activity = Activity.new({:name => "running",
                              :duration => "-1"})
        assert !activity.valid?
        expect(activity.errors.full_messages[0]).to eq("Duration can't be less than 0")
      end
    end
    context 'Duration is greater than one day' do
      it 'should be ' do
        activity = Activity.new({:name => "running",
                              :duration => "1441"})
        assert !activity.valid?
        expect(activity.errors.full_messages[0]).to eq("Duration can't be over 24 hours")
      end
    end
    context 'Valid activity' do
      it 'Should be valid and raise no errors' do
        activity = Activity.new({:name => "running",
                              :duration => "50"})
        assert activity.valid?
        expect(activity.errors.full_messages[0]).to eq(nil)
      end
    end
  end
end
