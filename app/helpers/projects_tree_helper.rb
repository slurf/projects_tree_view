# encoding: utf-8
#
module ProjectTreeHelper
	def render_projecttreeview(projects)
    #render_project_nested_lists(projects) do |project|
    #s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'my-project' : nil}")
    content_tag(:table,:class =>'list') do
    	concat(content_tag(:thead) do
      	concat(content_tag(:tr) do
        	concat content_tag(:th, l(:label_project))
          concat content_tag(:th, l(:field_description))
        end)
      end)
      concat(content_tag(:tbody) do
        ancestors = []
        options = {}
        @projects.each do |project|
          rowid = ""
          classes = ""
          spanicon = ""
          openonclick = ""
          options.clear

          if(!project.children.empty?)
            classes += " closed parent"
            rowid += project.id.to_s+"span"
            openonclick = "showHide('"+project.id.to_s+"','"+project.id.to_s+"span')"
            spanicon = "<span " + openonclick + " class=\"expander\">&nbsp  </span>"
            if rowid.present?
          	options[:id]=rowid
          	end
          else
            classes += " child"
          end

          if(project.parent_id == nil)
            ancestors.clear
            ancestors << project.id
          else
            while (ancestors.any? && !(project.parent_id == ancestors.last))
              ancestors.pop
            end
            classes += " hide"

            if( !(ancestors.detect {|pid| pid == project.parent_id }))
              prvclasses = "closed show parent"
              ancestors.each do |pid|
              	prvclasses += " " + pid.to_s
              end
              
              options[:class] = prvclasses
          		options[:id]=project.parent_id.to_s+"span"

              #<tr class="<%= prvclasses %>" id="<%= project.parent_id.to_s + "span" %>" >
              #<td class="name" ><span style="padding-left:<%=(2*(ancestors.length-1)).to_s%>em;"></span><span <%=raw openonclick%> class="expander" >&nbsp </span><%= h("<Private Project>") %><span <%=raw openonclick %> class="empty">&nbsp</span></td>
              #<td <%= raw openonclick %> >Project is private. </td>
              #</span>
              #</tr>

              openonclickprv = "showHide('"+project.parent_id.to_s+"','"+project.parent_id.to_s+"span')"

              concat(content_tag(:tr,nil,options) do
            	concat(content_tag(:td, nil, :class=>'name') do
            	helppadding="padding-left:"+(1.5*(ancestors.length-1)).to_s+"em;"
            	concat content_tag('span',nil,:'style'=>helppadding)
            	concat content_tag('span',"&nbsp;&nbsp;".html_safe,:class=>'expander',:onclick =>openonclickprv)
              concat h("<Private Project>")
              #concat content_tag(:p,ancestors)
            end)
            concat content_tag(:td, 'Project is private.', :class => 'wiki description',:onclick =>openonclickprv)
          end)
              ancestors << project.parent_id
            end
              
            ancestors.each do |pid|
              classes += " " + pid.to_s
            end
            ancestors << project.id
          end

          options[:class] = classes

          concat(content_tag(:tr,nil,options) do
            concat(content_tag(:td, nil, :class=>'name') do
            	helppadding="padding-left:"+(1.5*(ancestors.length-1)).to_s+"em;"
            	concat content_tag('span',nil,:'style'=>helppadding)
            	if openonclick.present?
              	concat content_tag('span',"&nbsp;&nbsp;".html_safe,:class=>'expander',:onclick =>openonclick)
            	else
            		concat content_tag('span',"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;".html_safe)
            	end
              concat link_to_project(project, {}, :class =>'project')
              concat content_tag(:span, nil, :class=>"'empty ' #{User.current.member_of?(project) ? 'my-project' : nil}",:onclick =>openonclick)

              #concat content_tag(:p,ancestors)
            end)
            concat openonclick.blank? ? content_tag(:td, textilizable(project.short_description, :project => project), :class => 'wiki description') : content_tag(:td, textilizable(project.short_description, :project => project), :class => 'wiki description', :onclick =>openonclick)
          end)
            #if rowid.present?
            #  concat(content_tag(:tr,nil,:class=>classes, :id=>rowid))
            #else
            #  concat(content_tag(:tr,nil,:class=>classes))
            #end
        end
      end)
      # concat content_tag(:li,project.name)
    end
      #if project.description.present?
        #s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
      #end
      #s
    #end
    
  end

  def render_project_useronline
  	if User.current.logged?
			content_tag(:p, content_tag(:span,l(:label_my_projects),:class=>'my-project'),:style=>'text-align:right;')
		end
	end
end