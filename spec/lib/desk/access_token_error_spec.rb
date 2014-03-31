require 'spec_helper'

describe Desk::AccessTokenError do

  describe '#message' do
    it 'should be an error' do
      expect(Desk::AccessTokenError.superclass).to eq StandardError
    end
  end

end
