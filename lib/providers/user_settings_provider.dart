import 'package:hdmgr/models/spending_limit.dart';
import 'package:hdmgr/models/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
part 'user_settings_provider.g.dart';

@riverpod
class UserSettings extends _$UserSettings {
  SharedPreferences? sharedPrefs;
  @override
  Future<UserData> build() async {
    sharedPrefs = await SharedPreferences.getInstance();
    developer.log(sharedPrefs.toString());
    if(sharedPrefs == null){
      return UserData(spendingLimitList: [SpendingLimit(value: 100000)]);
    }
    List<String>? spendingLimitString = sharedPrefs!.getStringList('spending_limits');
    List<SpendingLimit> spendingLimits = [];
    //spendingLimit:
    //every [DoW]: ['every,1,1000', ...]
    //every day: ['all,1000']
    //specific date: ['only,yyyy-MM-dd,1000', ...]
    //NO SPACE BETWEEN COMMAS
    for (String element in spendingLimitString!) {
      List<String> tmp = element.split(',');
      if(tmp[0] == 'every'){
        spendingLimits.add(SpendingLimit(duration: SpendingLimitType.every, value: double.parse(tmp[2]), dayOfWeek: int.parse(tmp[1])));
      }
      if(tmp[0] == 'all'){
        spendingLimits.add(SpendingLimit(value: double.parse(tmp[1]), duration: SpendingLimitType.all));
      }
      if(tmp[0] == 'only'){
        spendingLimits.add(SpendingLimit(value: double.parse(tmp[2]), duration: SpendingLimitType.only, dateTime: DateTime.parse(tmp[1])));
      }
    }
    return UserData();
  }
  Future<void> setSpendingLimit(List<String> spendingLimit) async {
    await sharedPrefs!.setStringList('spending_limits', spendingLimit);
    ref.invalidateSelf();
    await future;
  }

}