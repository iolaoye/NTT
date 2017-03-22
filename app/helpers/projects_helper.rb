module ProjectsHelper
  def sort_link(column, title = nil)
    title ||= column.titleize
	debugger
	case column
		when "Last Modifed"
			column = "updated_at"
		when "Ultima Modificacion"
			column = "updated_at"
		when "Nombre"
			column = "name"
	end  #end case
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    link_to "#{title} <span class='#{icon}'></span>".html_safe, {column: title, direction: direction}
  end
end
