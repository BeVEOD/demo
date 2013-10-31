# chart_hash makes guesses about what values would a human set as
# a graph's lower and upper boundaries, and the steps he would use.
# You can pass an optional "approx_nb_steps" number (defaults 10)
# which will try to match

# all credit for the algorithm goes to Flotr, an MIT-licensed JS lib.
# http://code.google.com/p/flot/source/browse/trunk/jquery.flot.js

class Range

 def chart_hash(approx_nb_steps=10)
   min = self.first; max = self.last
   delta = (max - min).to_f / approx_nb_steps

   dec  = (Math.log(delta) / Math.log(10))

   mag  = 10**(dec.floor)  # order of magnitude
   norm = (delta) / mag;   # norm is in [0, 1]

   step = case norm
          when 1..1.5    then 1
          when 1.5..2.25 then 2
          when 2.25..3   then 2.5
          when 3..7.5    then 5
          else
            10
          end
   step *= mag
   max -= max % step
   max += step if max < self.last

   return { :min => (min - min % step).to_f, :max => max.to_f, :steps => step.to_f}
 end

 def number_list(approx_nb_steps=10)
   h = self.chart_hash(approx_nb_steps)
   res = [h[:min]]
   while(res.last <= h[:max]) do
     res << res.last + h[:steps]
   end
   return res
 end

 def date_list(app_steps=20)
   min_date = self.first.to_date
   max_date = self.last.to_date
   if app_steps.is_a?(Fixnum)
     mini = min_date.to_time.to_i
     step = case (max_date - min_date).to_i
            when 0..60 then 1.day
            when 61..200 then 7.days
            when 201..1000 then 1.month
            else 1.year
            end
     stepdays = step / 86400
     return (((max_date - min_date).to_i.days / step).to_i+1).times.map {|i| (min_date + (i*stepdays.to_f)).to_s}
   else
     l = [min_date]
     case app_steps
     when :day
       while (l.last < max_date) do
         l << l.last.tomorrow
         break if l.last == max_date
       end
     when :week
       while (l.last < max_date) do
         l << l.last.next_week
         break if l.last.cweek == max_date.cweek && l.last.year == max_date.year
       end
     when :month
       while (l.last < max_date) do
         l << l.last.next_month
         break if l.last.month == max_date.month && l.last.year == max_date.year
       end
     when :year
       while (l.last < max_date) do
         l << l.last.next_year
         break if l.last.year == max_date.year
       end
     end
     return l
   end
 end

end

module Enumerable
 def chart_hash(approx_nb_steps=10)
   (self.min .. self.max).chart_hash(approx_nb_steps)
 end
end
