import 'bookingobject.dart';

class TableObject {
  late int tableid;
  late int areaid;
  late String tablename;
  late String shape;
  late BookingObject? booking;
  late double dx;
  late double dy;
  // bool isbooked = false;
  // TableObject(this.tableid, this.tablename, this.booking);
  TableObject(this.tableid,this.areaid, this.tablename, this.booking, this.dx, this.dy,this.shape);
}
