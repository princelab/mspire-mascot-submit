require 'spec_helper'

require 'mspire/mascot/submit'

describe "submitting" do
  it 'works' do
    form = Mspire::Mascot::Submit.new
    form.submit!
  end
end
