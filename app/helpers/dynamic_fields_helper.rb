module DynamicFieldsHelper

  def link_to_add_dynamic_fields(*args, &block)
    block_given? \
      ? link_to_dynamic_fields_with_block(*args, &block)
      : link_to_dynamic_fields_without_block(*args)
  end

  def link_to_remove_dynamic_fields(text, form, options = {})
    form.hidden_field(:_destroy) + link_to(text, 'javascript:;', options.deep_merge(data: { behavior: "remove-dynamic-fields" }))
  end

  def render_dynamic_fields(form, association, object, partial)
    form.fields_for(association, object, child_index: "new_dynamic_fields") do |f|
      render(partial, f: f)
    end
  end

  private

    def link_to_dynamic_fields_with_block(*args, &block)
      text    = args[0]
      options = args[1] || {}
      fields  = capture(&block)
      render_link_to text, fields, options
    end

    def link_to_dynamic_fields_without_block(*args)
      text        = args[0]
      form        = args[1]
      association = args[2]
      options     = args[3] || {}
      partial     = default_partial_fields_name(association)
      object      = association.to_s.classify.constantize.new
      fields      = render_dynamic_fields(form, association, object, partial)
      render_link_to(text, fields, options)
    end

    def render_link_to(text, fields, options)
      link_to text, 'javascript:;', options.deep_merge({data: {behavior: 'add-dynamic-fields', fields: html_escape_once(fields)}})
    end

    def default_partial_fields_name(association)
      association.to_s.singularize + "_fields"
    end
end