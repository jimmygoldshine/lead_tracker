describe Gmail do

  let!(:gmail) {described_class.new}

  it "should be an instance of the email object" do
    expect(gmail.class).to eq Gmail
  end

  it "should respond to 'get_emails' with 2 args and output a hash" do
    expect(gmail.get_emails('subject: hiring', 10)).to_be instance_of Hash
  end
end
