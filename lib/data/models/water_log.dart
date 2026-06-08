import 'package:objectbox/objectbox.dart';


@Entity()
class WaterLog {
  int id = 0;

  @Index()
  String uid = '';

  @Property(type: PropertyType.date)
  late DateTime date;
  late int      amountML;
  @Property(type: PropertyType.date)
  late DateTime time;

  double get glasses => amountML / 250;
}




