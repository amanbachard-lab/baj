import 'local_store.dart';
import 'demo_data.dart';
class TransactionService {
 Future<void> requestQuote({required String providerId,required String description,String? preferredDate}) async {final u=await LocalStore.currentUser();final p=DemoData.providers.firstWhere((x)=>x.id==providerId);await LocalStore.addQuote({'id':DateTime.now().microsecondsSinceEpoch.toString(),'providerId':providerId,'providerName':p.name,'description':description,'preferredDate':preferredDate,'status':'En attente — démo locale','createdAt':DateTime.now().toIso8601String(),'userIdentifier':u?['identifier']});}
 Future<void> bookAppointment({required String providerId,required DateTime dateTime,String? note}) async {final u=await LocalStore.currentUser();final p=DemoData.providers.firstWhere((x)=>x.id==providerId);await LocalStore.addAppointment({'id':DateTime.now().microsecondsSinceEpoch.toString(),'providerId':providerId,'providerName':p.name,'dateTime':dateTime.toIso8601String(),'note':note,'status':'En attente — démo locale','createdAt':DateTime.now().toIso8601String(),'userIdentifier':u?['identifier']});}
 Future<dynamic> myAppointments()=>LocalStore.appointments();
 Future<dynamic> myQuotes()=>LocalStore.quotes();
}
