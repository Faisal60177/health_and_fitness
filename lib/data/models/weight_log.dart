import 'package:objectbox/objectbox.dart';


@Entity()
class WeightLog {
  int id = 0;

  @Index()
  String uid = '';

  @Property(type: PropertyType.date)
  late DateTime date;
  late double   weightKg;
  String notes = '';
}




