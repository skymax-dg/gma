module ApplicationHelper
  def jdate_field(key, name, label, params = nil)
    if label
      if label =~ /^icon:/
        label = image_tag(get_icon(label.split(':')[1]))
      else
        label = "#{label}:"
      end
    end

    params ||= {}

    if params[:value]
      value = params[:value]
    else
      value = nil
    end

    res = ''

    if params[:date] || params[:time]
      size = 8
    elsif params[:date_time]
      size = 8
    end

    if value
      res = "<label for=\"#{"%s_%s"%[key,name]}\">#{label}</label>#{text_field(key, name, :size => size, :value => value, :onchange => params[:onchange]) }"
    else
      res = "<label for=\"#{"%s_%s"%[key,name]}\">#{label}</label>#{text_field(key, name, :size => size, :tooltipText => params[:tooltip], :onchange => params[:onchange]) }"
    end

    if params[:date]
      value = value.strftime("%d/%m/%Y") if value && value != ''
      res << "<script> jQuery(function() {  jQuery( \"#%s_%s\" ).datepicker( jQuery.datepicker.regional[\"it\" ] ); jQuery( \"#%s_%s\" ).datepicker( \"setDate\",\"#{value}\" ); jQuery( \"#%s_%s\" ).datepicker( \"option\", \"changeYear\", true  ); }); </script>"%[key,name,key,name,key,name]
    end
    if params[:date_time]
      dname = "#{name}_date"
      tname = "#{name}_time"
      if value
        dvalue = value.strftime("%d/%m/%Y")
        tvalue = value.strftime("%H:%M")
      end

      res = "<div class=\"ctx\" #{id} #{style}><div class=\"label\">#{label}</div> <div class=\"tf\">#{text_field(key, dname, :size => size, :value => dvalue, :tooltipText => params[:tooltip], :onchange => params[:onchange]) } #{text_field(key, tname, :size => size, :tooltipText => params[:tooltip], :value => tvalue,:onchange => params[:onchange]) }</div></div>"
      res << "<script> jQuery('#%s_%s_time').timepicker({timeText: 'Orario', hourText: 'Ora', minuteText: 'Minuti', timeOnlyTitle: 'Selezionare orario', closeText: 'Chiudi', currentText: 'Attuale'}); jQuery( \"#%s_%s_time\" ).datetimepicker( \"setDate\",\"#{tvalue}\" ); </script>"%[key,name,key,name]
      res << "<script> jQuery(function() {  jQuery( \"#%s_%s_date\" ).datepicker( jQuery.datepicker.regional[\"it\" ] ); jQuery( \"#%s_%s_date\" ).datepicker( \"setDate\",\"#{dvalue}\" ); jQuery( \"#%s_%s_date\" ).datepicker( \"option\", \"changeYear\", true  ); }); </script>"%[key,name,key,name,key,name]
    end

    if params[:time]
      #value = value.strftime("%d/%m/%Y H:M") if value && value != ''
      res << "<script> jQuery('#%s_%s').timepicker({timeText: 'Orario', hourText: 'Ora', minuteText: 'Minuti', timeOnlyTitle: 'Selezionare orario', closeText: 'Conferma', currentText: 'Chiudi'});
                       jQuery( \"#%s_%s\" ).timepicker( \"setDate\",\"#{value}\" ); 
              </script>"
              %[key,name,key,name]
    end
    if params[:mytime]
res << "<script> jQuery( \"#%s_%s\" ).timepicker({timeText: 'Orario',
                                                  hourText: 'Ora',
                                                  minuteText: 'Minuti',
                                                  timeOnlyTitle: 'Selezionare orario',
                                                  closeText: 'Conferma',
                                                  currentText: 'Chiudi',
                                                  timeFormat: 'hh:mm',
                                                  hour: \"#{value.strftime("%H")}\",
                                                  minute: \"#{value.strftime("%M")}\"});
        </script>"%[key,name]
#      res << "<script>
#               jQuery(
#                function()
#                 {jQuery( \"#%s_%s\" ).timepicker(jQuery.timepicker.regional[\"it\" ] );
#                  jQuery( \"#%s_%s\" ).timepicker( \"hour\",\"#{value.strftime("%H")}\" );
#                  jQuery( \"#%s_%s\" ).timepicker( \"minute\",\"#{value.strftime("%H")}\" );
#                  jQuery( \"#%s_%s\" ).timepicker( \"option\", \"changeYear\", true  );
#                 }
#                );
#              </script>"
#              %[key,name,key,name,key,name]
    end
    raw res
  end
end
