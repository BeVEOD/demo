pdf.tags(:h1 => {:font_size => '2em', :font_weight => :bold},
	 :h2 => {:font_size => '1.5em', :font_weight => :bold},
	 :p => {}, :hr => {})
pdf.font("Times-Roman")

	pdf.text('<h1>'+(_("%{record} from %{records}") % {:record => @system_setting.disp_name, :records => _("System Settings")})+'</h1>', :align => :center, :style => :bold, :size => 16)
pdf.move_down(50)

pdf.styles({:value_for_name=>{}, :label_for_name=>{}, :value_for_value=>{}, :label_for_value=>{}, :value_for_root_container=>{}, :label_for_root_container=>{}})
pdf.text("<span class=\"label_for_name\">Name: </span><span class=\"value_for_name\">#{@system_setting.name}</span>")
pdf.text("<span class=\"label_for_value\">Value: </span>")

