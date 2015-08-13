
/*
  Override the dates for momentjs and for datetimepicker
 */
Date.parseDate = function( input, format ){
  return moment(input,format).toDate();
};

Date.prototype.dateFormat = function( format ){
  return moment(this).format(format);
};