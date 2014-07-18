shared_examples 'return a valid instance' do
  it '' do
    subject.should be_valid, subject.errors.full_messages.join(', ')
  end
end
