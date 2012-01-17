module FXC
  class Dialstring
    attr_reader :user, :targets, :default_dialstring, :provider

    def initialize(user, targets, default_dialstring = nil, provider = nil)
      @user = user
      @targets = targets
      @default_dialstring = default_dialstring || @user.values[:dialstring]

      @provider = provider ||
        FXC::Provider[:priority => 0] ||
        FXC::Provider.new(host: "sip.example.com", prefix: "1")
    end

    def to_s
      dialstring
    end

    def dialstring
      if targets.size > 0
        # If they have forwarding targets, sort them by priority and create an array
        # of arrays of targets.
        targets.sort_by { |p| p.priority }.inject([[]]) do |dial_array, current|
          last = dial_array.last
          # If we're the same priority or the first entry, add to the targets
          # in the last array
          if last.size == 0 or last.last.priority == current.priority
            last << current
          else
            # Otherwise we must be a new (lower) priority, add that to dial_array as a
            # new array of lower priority level targets
            dial_array << [current]
          end
          dial_array
          # Then we inject the dialstring string representation of the Targets
          # into another array, join it on commas, and join the different
          # levels of priority target strings on pipes
        end.inject([]) do |l, t|
          l << t.map do |tgt|
            provider.format(tgt.value)
          end.join(",")
        end.join("|")
      else
        default_dialstring
      end
    end

  end
end

