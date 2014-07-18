shared_examples 'be accessible' do |as_user|
  when_logged_in as_user do
    it { should respond_by :success }
  end
end

shared_examples 'be processable' do
  when_logged_in as_user do
    it { should respond_by :redirect }
  end
end

shared_examples 'be forbidden' do
  when_logged_in as_user do
    it { should respond_by :forbidden }
  end
end

shared_examples 'a logged action' do
  context 'when logged out' do
    it { should respond_by :redirect }
    it { should redirect_to new_user_session_path }
  end
end
