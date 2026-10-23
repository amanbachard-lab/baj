import 'local_store.dart';
class AuthService {
 Future<void> login({required String identifier,required String password}) async {await LocalStore.login(identifier,password);}
 Future<void> register({required String firstName,required String lastName,required String identifier,required String password,required bool professional,required String termsVersion}) async {await LocalStore.register({'firstName':firstName,'lastName':lastName,'identifier':identifier.trim(),'password':password,'professional':professional,'termsVersion':termsVersion,'createdAt':DateTime.now().toIso8601String()});}
}
