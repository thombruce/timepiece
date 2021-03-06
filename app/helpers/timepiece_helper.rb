module TimepieceHelper
  def timepiece(location = 'UTC', type: '24', lead: 'none', abbr_sep: 'none', id: '')
    # Note: On the inclusion of IDs, you should /not/ display them if none is given - HTML compliance.
  	Time.zone = location
  	hours = Time.now.in_time_zone.strftime('%H')
  	minutes = Time.now.in_time_zone.strftime('%M')
  	seconds = Time.now.in_time_zone.strftime('%S')
  	if type == '12'
      hours = hours.to_i
      if hours > 12
        hours = hours - 12
  	    var = 'pm'
      elsif hours == 0
  	    hours = 12
  	    var = 'am'
  	  elsif hours == 12
  	    var = 'pm'
  	  elsif hours < 12
  	    var = 'am'
  	  end
      if hours < 10
        if lead == '0' || lead == 'zero'
          hours = '0' + hours.to_s
        elsif lead == '_' || lead == 'space'
          hours = '&#8199;' + hours.to_s
        end
      end
      if abbr_sep == '.'
        var = var.gsub(/([apm])/, '\1.')
      end
    end
  	time = "<span class='timepiece-hours'>#{hours}</span>"\
           "<span class='timepiece-separator tp-separator-1 tp-hours-minutes'>:</span>"\
           "<span class='timepiece-minutes'>#{minutes}</span>"\
           "<span class='timepiece-separator tp-separator-2 tp-minutes-seconds'>:</span>"\
           "<span class='timepiece-seconds'>#{seconds}</span>"
    if type == '12'
      time = time + "<span class='timepiece-abbr timepiece-abbr-#{var}'>#{var}</span>"
    end
  	content_tag(:span, time.html_safe, class: 'timepiece', 'data-timezone' => location, 'data-tptype' => type, 'data-lead' => lead, 'data-abbr_separator' => abbr_sep, 'id' => (id unless id.blank?))
  end

  def analog(location = 'UTC', id: '', size: '10em')
    Time.zone = location
    hours = Time.now.in_time_zone.strftime('%H')
    minutes = Time.now.in_time_zone.strftime('%M')
    seconds = Time.now.in_time_zone.strftime('%S')
    if hours.to_i >= 6 && hours.to_i < 18
      time_of_day_class = 'timepiece-analog-day'
    else
      time_of_day_class = 'timepiece-analog-night'
    end
    if hours.to_i >= 12
      var = 'pm'
    elsif hours.to_i < 12
      var = 'am'
    end
    hours_angle = (hours.to_i * 30) + (minutes.to_i / 2)
    minutes_angle = minutes.to_i * 6
    seconds_angle = seconds.to_i * 6
    time = "<div class='timepiece-hours-container' style='-ms-transform:rotateZ(#{hours_angle}deg);-webkit-transform:rotateZ(#{hours_angle}deg);transform:rotateZ(#{hours_angle}deg);'><div class='timepiece-analog-hours'></div></div>"\
           "<div class='timepiece-minutes-container' style='-ms-transform:rotateZ(#{minutes_angle}deg);-webkit-transform:rotateZ(#{minutes_angle}deg);transform:rotateZ(#{minutes_angle}deg);'><div class='timepiece-analog-minutes'></div></div>"\
           "<div class='timepiece-seconds-container' style='-ms-transform:rotateZ(#{seconds_angle}deg);-webkit-transform:rotateZ(#{seconds_angle}deg);transform:rotateZ(#{seconds_angle}deg);'><div class='timepiece-analog-seconds'></div></div>"\
           "<div class='timepiece-analog-abbr'>" + var + "</div>"
    content_tag(:div, time.html_safe, class: 'timepiece-analog ' + time_of_day_class, 'data-timezone' => location, 'id' => (id unless id.blank?), 'style' => 'width:' + size + ';padding-bottom:' + size + ';')
  end

  def timer(time_since = Time.now, id: '')
    seconds_diff = (Time.now - time_since).to_i

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    time = "<span class='timepiece-hours'>#{"%02d" % hours}</span>"\
           "<span class='timepiece-separator tp-separator-hours-minutes'>:</span>"\
           "<span class='timepiece-minutes'>#{"%02d" % minutes}</span>"\
           "<span class='timepiece-separator tp-separator-minutes-seconds'>:</span>"\
           "<span class='timepiece-seconds'>#{"%02d" % seconds}</span>"
           # "<span class='timepiece-seconds'>#{seconds.to_s.rjust(2, '0')}</span>" # Note: rjust; it might be useful.

    content_tag(:span, time.html_safe, class: 'timepiece-timer', 'data-hours' => hours, 'data-minutes' => minutes, 'data-seconds' => seconds, 'id' => (id unless id.blank?))
  end
  if false
    def timer_in_words(time_since = Time.now, id: '')
      seconds_diff = (Time.now - time_since).to_i

      days = seconds_diff / 86400
      seconds_diff -= days * 86400

      hours = seconds_diff / 3600
      seconds_diff -= hours * 3600

      minutes = seconds_diff / 60
      seconds_diff -= minutes * 60

      seconds = seconds_diff

      time = "<span class='timepiece-days'>#{days.to_s}</span>"\
             "<span class='timepiece-descriptor tp-descriptor-days'> days </span>"\
             "<span class='timepiece-hours'>#{hours.to_s}</span>"\
             "<span class='timepiece-descriptor tp-descriptor-hours'> hours </span>"\
             "<span class='timepiece-minutes'>#{minutes.to_s}</span>"\
             "<span class='timepiece-descriptor tp-descriptor-minutes'> minutes </span>"\
             "<span class='timepiece-seconds'>#{seconds.to_s}</span>"\
             "<span class='timepiece-descriptor tp-descriptor-seconds'> seconds </span>"
             # "<span class='timepiece-seconds'>#{seconds.to_s.rjust(2, '0')}</span>" # Note: rjust; it might be useful.

      content_tag(:span, time.html_safe, class: 'timepiece-timer', 'data-days' => days, 'data-hours' => hours, 'data-minutes' => minutes, 'data-seconds' => seconds, 'id' => (id unless id.blank?))
    end
  end

  def countdown(time_until = Time.new(2016), id: '')
    seconds_diff = (time_until - Time.now).to_i

    days = seconds_diff / 86400
    seconds_diff -= days * 86400

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    time = "<span class='timepiece-days'>#{days.to_s}</span>"\
           "<span class='timepiece-separator tp-separator-days-hours'>:</span>"\
           "<span class='timepiece-hours'>#{"%02d" % hours}</span>"\
           "<span class='timepiece-separator tp-separator-hours-minutes'>:</span>"\
           "<span class='timepiece-minutes'>#{"%02d" % minutes}</span>"\
           "<span class='timepiece-separator tp-separator-minutes-seconds'>:</span>"\
           "<span class='timepiece-seconds'>#{"%02d" % seconds}</span>"
           # "<span class='timepiece-seconds'>#{seconds.to_s.rjust(2, '0')}</span>" # Note: rjust; it might be useful.

    content_tag(:span, time.html_safe, class: 'timepiece-countdown', 'data-days' => days, 'data-hours' => hours, 'data-minutes' => minutes, 'data-seconds' => seconds, 'id' => (id unless id.blank?))
  end
  def countdown_in_words(time_until = Time.new(2016), id: '')
    seconds_diff = (time_until - Time.now).to_i

    days = seconds_diff / 86400
    seconds_diff -= days * 86400

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    time = "<span class='timepiece-days'>#{days.to_s}</span>"\
           "<span class='timepiece-descriptor tp-descriptor-days'> days </span>"\
           "<span class='timepiece-hours'>#{hours.to_s}</span>"\
           "<span class='timepiece-descriptor tp-descriptor-hours'> hours </span>"\
           "<span class='timepiece-minutes'>#{minutes.to_s}</span>"\
           "<span class='timepiece-descriptor tp-descriptor-minutes'> minutes </span>"\
           "<span class='timepiece-seconds'>#{seconds.to_s}</span>"\
           "<span class='timepiece-descriptor tp-descriptor-seconds'> seconds </span>"
           # "<span class='timepiece-seconds'>#{seconds.to_s.rjust(2, '0')}</span>" # Note: rjust; it might be useful.

    content_tag(:span, time.html_safe, class: 'timepiece-countdown', 'data-days' => days, 'data-hours' => hours, 'data-minutes' => minutes, 'data-seconds' => seconds, 'id' => (id unless id.blank?))
  end
end