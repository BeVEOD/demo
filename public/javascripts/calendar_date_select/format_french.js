Date.prototype.toFormattedString = function(include_time){
  str = Date.padded2(this.getDate()) + '/' + Date.padded2(this.getMonth() + 1) + "/" + this.getFullYear();
  if (include_time) { str += " " + this.getHours() + "h" + this.getPaddedMinutes() }
  return str;
}

Date.weekdays = $w("Lun Mar Mer Jeu Ven Sam Dim");
Date.first_day_of_week = 1;
Date.months = $w("Janvier Fevrier Mars Avril Mai Juin Juillet Aout Septembre Octobre Novembre Decembre");

_translations = {
  "OK": "OK",
  "Now": "Maintenant",
  "Today": "Aujourd'hui"
}

Date.parseFormattedString = function (string) {
    var regexp = "([0-9]{1,2})(/([0-9]{1,2})(/([0-9]{2,4})( ([0-9]{1,2})h([0-9]{2})?(:([0-9]{2}))?.*)?)?)?"
    var d = string.match(new RegExp(regexp, "i"));
    if (d==null) return Date.parse(string); // at least give javascript a crack at it.
    var offset = 0;
    var date = new Date(0, 0, d[1]);
    if (d[3]) { date.setMonth(d[3] - 1); }
    if (d[5]) { date.setYear((d[5] < 100) ? ((d[5] < 50) ? 2000 + d[5] : 1900 + d[5] ) : d[5]); }
    if (d[7]) { date.setHours(d[7]); }
    if (d[8]) { date.setMinutes(d[8]); }
    if (d[10]){ date.setSeconds(d[10]); }
  return date;
}
