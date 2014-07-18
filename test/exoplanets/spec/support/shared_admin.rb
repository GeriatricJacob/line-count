shared_examples 'an admin action' do
  it_behaves_like 'a logged action'

  it_should 'be forbidden', as_user
end
