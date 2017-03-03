module ApplicationHelper
  def nav_link(link_text, link_path)
    if current_page?(link_path)
      content_tag(:li, class: 'active') do
        link_to link_text, link_path
      end
    else
      content_tag :li, link_text do
        link_to link_text, link_path
      end
    end
  end

  def tab_link(link_text, link_path)
    if link_text == "All" && !params[:p]
      content_tag :li, class: "admin-page__header_link--active" do
        link_to link_text, link_path
      end
    elsif params[:p].present? && params[:p] == link_text.downcase
      content_tag :li, class: "admin-page__header_link--active" do
        link_to link_text, link_path
      end
    else
      content_tag :li, class: "admin-page__header_link" do
        link_to link_text, link_path
      end
    end
  end

  def profile_link(link_text, link_path)
    if current_page?(link_path)
      link_to link_text, link_path, class: 'list-group-item active'
    else
      link_to link_text, link_path, class: 'list-group-item'
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = association.to_s.classify.constantize.new
    id = new_object.object_id
    fields = f.fields_for(association.to_s + "[]", new_object, child_index: id) do |builder|
      render association.to_s + "_fields", f: builder
    end
    link_to name, "#", class: "add_fields", data: { id: id, fields: fields.gsub("\n", "")}
  end
end
