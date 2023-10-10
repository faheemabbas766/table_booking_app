import 'package:table_booking/Entities/areaobject.dart';
import 'package:table_booking/Entities/tableobject.dart';

class SearchObject {
  late int bookid;
  late String name;
  late DateTime bookedon;
  late DateTime bookedfor;
  late String email;
  late String phn;
  late String areaname;
  late String tablename;
  late int advance;
  late int ttlpersons;
  late DateTime? checkin;
  late DateTime? checkout;
  SearchObject(
    this.bookid,
    this.name,
    this.bookedon,
    this.bookedfor,
    this.email,
    this.phn,
    this.areaname,
    this.tablename,
    this.advance,
    this.ttlpersons,
    this.checkin,
    this.checkout,
  );
}
