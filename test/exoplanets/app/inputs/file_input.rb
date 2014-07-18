class FileInput < SimpleForm::Inputs::FileInput

  def input
    buffer = ''
    opts = input_html_options.merge(id: hidden_dom_id)
    buffer << @builder.hidden_field(:"#{attribute_name}_tmp", opts) if object.respond_to? :"#{attribute_name}_tmp"
    buffer << @builder.file_field(attribute_name, input_html_options)
    buffer << preview
    buffer.html_safe
  end

  def hidden_dom_id
    dup = self.dup
    "#{dup.__id__}_tmp"
  end

  def preview
    template.content_tag :div, class: 'preview' do
      if object.try("#{attribute_name}?")
        image= object.send(attribute_name)
        build_preview(image).html_safe
      else
        default_field_label
      end
    end
  end

  def default_field_label
    "<div class='label placeholder'>#{input_html_options[:placeholder]}</div>".html_safe
  end

  def build_preview image
    version = get_version(image)
    if version.present?
      '' << template.image_tag(version) << field_label(image)
    else
      ""
    end
  end

  def get_version image
    if image.respond_to?(:thumb)
      image.thumb
    end
  end

  def field_label res
    s = "<div class='label' title='#{res}'>#{res.to_s.split('/').last}</div>"
    s += "<div class='meta'>"
    s += "<div class='dimensions'><span class='number'>#{res.width}</span>x<span class='number'>#{res.height}</span>px</div>"
    s += "<div class='size'><span class='number'>#{res.file_size / 1024}</span>ko</div>"
    s += "</div>"

    s.html_safe
  end

end
