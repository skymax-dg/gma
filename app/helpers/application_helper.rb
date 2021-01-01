module ApplicationHelper
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def to_mydate(d)
    d ? "#{d.day} #{to_mymonth(d.month)} #{d.year}" : nil
  end

  def to_mymonth(m)
    ["","Gennaio", "Febbraio", "Marzo",     "Aprile",  "Maggio",   "Giungno",
        "Luglio",  "Agosto",   "Settembre", "Ottobre", "Novembre", "Dicembre"][m.to_i]
  end

  def to_currency(value)
    number_to_currency(value, :precision => 2, :separator => ",", :delimiter => ".", :format => "%n %u")
  end

  def to_date(date)
    date ? date.strftime("%d/%m/%Y") : ''
  end

  def to_datetime(date)
    date ? date.strftime("%d/%m/%y - %H.%M") : ''
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def resque_location(default)
    url = session[:return_to]
    clear_return_to
    return (url || default)
  end

  def clear_return_to
    session[:return_to] = nil
  end

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

    if params[:readonly]
      readonly = params[:readonly]
    else
      readonly = false
    end

    if params[:yearrange]
      yearrange = params[:yearrange]
    else
      yearrange = "1920:2030"
    end

    if params[:date] || params[:time]
      size = 8
    elsif params[:date_time]
      size = 8
    end

    if value
      res = "<label for=\"#{"%s_%s"%[key,name]}\">
               #{label}
             </label>
             #{text_field(key, name, :size => size, :value => value, :onchange => params[:onchange]) }"
    else
      res = "<label for=\"#{"%s_%s"%[key,name]}\">
               #{label}
             </label>
             #{text_field(key, name, :size => size, :tooltipText => params[:tooltip], :onchange => params[:onchange]) }"
    end

    if params[:date]
      value = value.strftime("%d/%m/%Y") if value && value != ''
      res << "<script>
               jQuery
               (function()
                 {jQuery(\"#%s_%s\").datepicker
                    (jQuery.datepicker.regional[\"it\" ]);
                  jQuery(\"#%s_%s\").datepicker(\"setDate\", \"#{value}\");
                  jQuery(\"#%s_%s\").datepicker(\"option\",  \"changeYear\", true);
                  jQuery(\"#%s_%s\").datepicker(\"option\",  \"yearRange\", \"#{yearrange}\");
                  jQuery(\"#%s_%s\").attr(\"readonly\", \"#{readonly}\");
                 }
               );
              </script>"%[key, name, key, name, key, name, key, name, key, name]
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
      res << "<script>
               jQuery
               (function()
                 {jQuery(\"#%s_%s\").timepicker
                    (jQuery.timepicker.regional[\"it\" ]);
                  jQuery(\"#%s_%s\").attr(\"readonly\", \"#{readonly}\");
                 }
               );
              </script>"%[key, name, key, name]
    end
    raw res
  end
end
