module ApplicationHelper

  # Conditional HTML Classes

  def cc_html(options={}, &blk)
    cls = options.delete(:class)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7]> <html#{attrs} class='lt-ie9 lt-ie8 lt-ie7 #{cls}'> <![endif]-->",
      "<!--[if IE 7]> <html#{attrs} class='lt-ie9 lt-ie8 #{cls}'> <![endif]-->",
      "<!--[if IE 8]> <html#{attrs} class='lt-ie9 #{cls}'> <![endif]-->",
      "<!--[if IE 9]> <html#{attrs} class='ie9 #{cls}'> <![endif]-->",
      "<!--[if gt IE 9]><!--> <html#{attrs} class='#{cls}'> <!--<![endif]-->",
      capture_haml(&blk).strip.html_safe,
      "</html>"
    ].join("\n").html_safe
  end

  def h(str); Rack::Utils.escape_html(str); end

  # Controllers

  def current_controller? name
    controller_name.to_s == name.to_s
  end

  def icon(icon)
    content_tag(:i, '', class: "icon-#{icon}").html_safe
  end

  def nav_link(options={})
    ctrlr = options.delete(:for)
    icon_name = options.delete(:icon)
    admin = options.delete(:admin).present?

    scope = admin ? [:admin] : []
    path = scope + [ctrlr]

    ctrlr_text = path.join '-'

    cls = options.delete(:class) || ''
    cls += ' ' + ctrlr_text

    current = (controller.controller_scope + [controller_name]).join('-')

    p ctrlr_text
    p current

    cls += ' active' if ctrlr_text == current

    url = options.delete(:url) || polymorphic_url(path)

    content_tag :li, class: cls do
      content_tag :a, class: cls, href: url do
        s = ''
        s += icon(icon_name) if icon_name
        s += "#{scope.empty? ? '' : 'admin.'}links.#{ctrlr}".t
        s.html_safe
      end
    end
  end

  # Markdown

  def markdown text
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true))
    markdown.render(text || '').html_safe
  end

  # Collection

  def collection collection, options={}
    local = options[:local] || collection.klass.name.tableize.to_sym
    partial = options[:partial] || "admin/#{collection.klass.name.tableize}/index"
    page_param = options[:page_param] || (action_name == 'index' ? :page : "#{local}_page")

    collection = collection.page(params[page_param])

    if collection.empty?
      raw "<p><em>#{'admin.no_data'.t}</em></p>"

    else

      if File.exist?("#{Rails.root}/app/views/#{partial}")
        html = render(partial, local => collection)
      else
        html = render('admin/application/list', collection: collection)
      end

      pagination = paginate(collection, param_name: page_param)

      res = pagination + html + pagination
      res
    end
  end

  def resource_label_for resource
    if resource.respond_to? :name
      label = resource.name
    elsif resource.respond_to? :title
      label = resource.title
    end
    label = resource.to_s if label.nil?
    label
  end

  def resource_label
    resource_label_for resource
  end

  # Breadcrumb

  def breadcrumb caption, *args
    scope = @virtual_path.split(%r{/_?})[0..-2]
    caption = caption.t(scope: scope) if caption.is_a? Symbol

    @_breadcrumb_paths ||= []
    @_breadcrumb_paths << [caption, *args].compact
  end

  def breadcrumbs divider=''
    return nil unless @_breadcrumb_paths.present?

    content_tag :ul, class: 'breadcrumb' do
      concat(content_tag(:li, class: 'home') do
        concat link_to(content_tag(:i, nil, class: 'icon-home'), [:admin, :root])
      end)

      (@_breadcrumb_paths || []).each.with_index do |path, i|
        caption = content_tag(:span, path[0])
        caption = link_to(*path) if path[1]

        li_class = path[2].delete(:class) if path[2]

        concat(content_tag(:li, class: li_class) { concat caption })
      end
    end
  end

  # Pills

  def pill caption, *args
    caption = caption.t(scope: [:actions, default_i18n_scope]) if caption.is_a? Symbol

    @_pills ||= []
    @_pills << [caption, *args].compact
  end

  def pills
    return nil unless @_pills.present?

    content_tag :ul, class: 'pills' do
      @_pills.each do |path|
        caption = path[0]
        caption = link_to(*path) if path[1]

        li_class = path[2].delete(:class) if path[2]

        concat content_tag(:li, caption, class: li_class)
      end
    end
  end
end
