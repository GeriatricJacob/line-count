module SimpleFormHelper
  SKIPPED_COLUMNS = [
    :created_at, :updated_at, :created_on, :updated_on,
    :lock_version, :version,

    # Devise
    :encrypted_password, :reset_password_token, :reset_password_sent_at,
    :last_sign_in_at, :last_sign_in_ip,
    :current_sign_in_at, :current_sign_in_ip,
    :remember_created_at,

    # CarrierWave Meta
    :avatar_meta, :image_meta,
  ]

  def default_actions(options={}, &block)
    capture_haml do
      haml_tag 'fieldset', class: 'actions' do
        if request.referer.present? and not options[:no_cancel]
          haml_tag 'a', href: request.referer, class: "button red #{options[:class]}" do
            haml_tag 'span', class: options[:reset_icon] || 'icon-remove'

            haml_concat options[:cancel] || 'actions.cancel'.t
          end
        end

        capture_haml(&block) if block_given?

        haml_tag 'button', type: :submit, class: "button green #{options[:class]}" do
          haml_tag 'span', class: options[:icon] || 'icon-ok'
          haml_concat options[:submit] || 'actions.submit'.t
        end
      end
    end
  end

  def inputs_for model, form_builder
    cols = association_columns(model, :belongs_to)
    cols += content_columns(model)
    cols -= SKIPPED_COLUMNS
    cols.compact


    res = ''
    cols.each do |col|
      p col
      res << form_builder.input(col, placeholder: placeholder_for(model, col, form_builder))
    end
    res.html_safe
  end

  def placeholder_for(model, name, f)
    type = f.send(:default_input_type, name, model.class.columns_hash[name], {})

    s = I18n.t("simple_form.placeholders.#{model.class.name.underscore}.#{name}")

    if s =~ /translation missing/
      s = I18n.t("simple_form.placeholders.#{type}")
    end

    s
  end

  def association_columns object, *by_associations
    if object.present? && object.class.respond_to?(:reflections)
      object.class.reflections.collect do |name, association_reflection|
        if by_associations.present?
          if by_associations.include?(association_reflection.macro) && association_reflection.options[:polymorphic] != true
            name
          end
        else
          name
        end
      end.compact
    else
      []
    end
  end

  def default_columns_for_object
    cols = association_columns(:belongs_to)
    cols += content_columns
    cols -= SKIPPED_COLUMNS
    cols.compact
  end

  def content_columns object
    # TODO: NameError is raised by Inflector.constantize. Consider checking if it exists instead.
    klass = object.class
    return [] unless klass.respond_to?(:content_columns)
    klass.content_columns.collect { |c| c.name.to_sym }.compact
  end

end
