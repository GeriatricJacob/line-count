ALL_CRUD_METHODS = [
  :index,
  :create,
  :new,
  :show,
  :edit,
  :update,
  :destroy
]

shared_examples 'routes resources' do |options|
  resource_name = options[:model]
  resource_path = options[:path]
  resource_controller = options[:controller] || resource_path
  resource_methods = options[:methods] || ALL_CRUD_METHODS
  resource_scope = options[:scope] || {}

  if resource_methods.include? :index
    it "routes GET /#{resource_path} to #{resource_controller}#index" do
      expect(get: "/#{resource_path}").to route_to({
        controller: resource_controller,
        action: 'index',
      }.merge resource_scope)
    end
  end

  if resource_methods.include? :show
    it "routes GET /#{resource_path}/:id to #{resource_controller}#show" do
      expect(get: "/#{resource_path}/42").to route_to({
        controller: "#{resource_controller}",
        action: 'show',
        id: '42'
      }.merge resource_scope)
    end
  end

  if resource_methods.include? :edit
    it "routes GET /#{resource_path}/:id/edit to #{resource_controller}#edit" do
      expect(get: "/#{resource_path}/42/edit").to route_to({
        controller: "#{resource_controller}",
        action: "edit",
        id: "42"
      }.merge resource_scope)
    end
  end

  if resource_methods.include? :new
    it "routes GET /#{resource_path}/new to #{resource_controller}#new" do
      expect(get: "/#{resource_path}/new").to route_to({
        controller: "#{resource_controller}",
        action: "new",
      }.merge resource_scope)
    end
  end

  if resource_methods.include? :update
    it "routes PUT /#{resource_path}/:id/update to #{resource_controller}#update" do
      expect(put: "/#{resource_path}/42").to route_to({
        controller: "#{resource_controller}",
        action: "update",
        id: "42"
      }.merge resource_scope)
    end
  end

  if resource_methods.include? :destroy
    it "routes DELETE /#{resource_path}/:id to #{resource_controller}#destroy" do
      expect(delete: "/#{resource_path}/42").to route_to({
        controller: "#{resource_controller}",
        action: "destroy",
        id: "42"
      }.merge resource_scope)
    end
  end

  if resource_methods.include? :create
    it "routes POST /#{resource_path} to #{resource_controller}#create" do
      expect(post: "/#{resource_path}").to route_to({
        controller: "#{resource_controller}",
        action: "create",
      }.merge resource_scope)
    end
  end
end

