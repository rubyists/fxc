# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#

class FXC::Condition < Sequel::Model
  set_dataset FXC.db[:fs_conditions]
  one_to_many :actions, :class => 'FXC::Action'
  one_to_many :anti_actions, :class => 'FXC::AntiAction'
  many_to_one :extension, :class => 'FXC::Extension'
  TOD_FIELDS = {
    year: "Calendar Year, 0-9999",
    yday: "Day of Year 1-366",
    mon: "Month, 1-12",
    mday: "Day of Month, 1-31",
    week: "Week of Year, 1-52",
    wday: "Day of Week, 1-7 (Sun=1)",
    mweek: "Week of Month, 1-6",
    hour: "Hour, 0-23",
    minute: "Minute (of the hour), 0-59",
    minute_of_day: "Minute of the Day, 1-1440 (Midnight=1)"}

  def context
    extension.context
  end

  plugin :list, :scope => :extension_id

  def minute_of_day_to_times
    return nil unless minute_of_day
    start, stop = minute_of_day.match(/(\d+)-(\d+)/).captures
    start_hours, start_minutes = start.to_i.divmod(60)
    stop_hours, stop_minutes = stop.to_i.divmod(60)
    "%02d:%02d-%02d:%02d" % [start_hours, start_minutes, stop_hours, stop_minutes]
  end

  WDAYS = Hash[%w[sun mon tue wed thu fri sat].zip(Date::DAYNAMES)]

  def wdays
    WDAYS.values_at(*wday.split('-'))
  end

  def break_string
    case self.break
    when nil
      'on-false'
    when false
      'never'
    when true
      'on-true'
    end
  end

  def expression_string
    out = [expression.to_s]

    TOD_FIELDS.keys.each do |key|
      next unless value = self[key]
      out << ('%s="%s"' % [key, value])
    end

    out.join(' ')
  end

  protected
  def before_save
    base = FXC::Condition.filter(:extension_id => extension_id)
    base = base.filter(~{:id => self.id}) if self.id
    max = base.order(:position.asc).last.position rescue -1
    if self.position
      p = self.position.to_i
      if p > max
        self.position = max + 1
      else
        bigger = base.filter{|o| o.position >= p}
        bigger.update("position = (position + 1)")
      end
    else
      self.position = max + 1
    end
  end

end
