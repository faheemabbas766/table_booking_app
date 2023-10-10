class BookingObject{
  late int bookid;
  late String name;
  late String phn;
  late int ttlpersons;
  late int advance;
  late DateTime booked_on;
  late DateTime booked_for;
  late DateTime? check_in;
  late DateTime? check_out;
  late DateTime? deleted;
  BookingObject(this.bookid,this.name,this.phn,this.booked_on,this.booked_for,this.check_in,this.check_out,this.deleted,this.ttlpersons,this.advance);
}