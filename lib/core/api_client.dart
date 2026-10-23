import '../services/local_store.dart';
import '../services/demo_data.dart';
class ApiClient {
 ApiClient._(); static final ApiClient instance=ApiClient._();
 Future<dynamic> get(String path,{Map<String,String>? query}) async {
  if(path=='/api/account') return await LocalStore.currentUser() ?? <String,dynamic>{};
  if(path=='/api/legal/terms') return {'version':'DEMO-1.0','content':'BAJ-NEMO — Conditions générales de démonstration\n\n1. BAJ-NEMO facilite la mise en relation entre utilisateurs et prestataires.\n2. Les profils, avis, notes, tarifs et coordonnées sont fictifs.\n3. Vérifiez les qualifications, tarifs et disponibilités avant toute décision.\n4. Les devis et rendez-vous restent sur cet appareil et ne sont pas envoyés à un prestataire.\n5. Les informations de santé et de pharmacie de garde doivent être vérifiées directement.\n6. Cette version est une démonstration locale, sans service serveur.'};
  if(path=='/api/favorites') { final ids=await LocalStore.favorites(); return DemoData.providers.where((p)=>ids.contains(p.id)).map((p)=>{'provider':{'id':p.id,'name':p.name,'profession':p.profession}}).toList(); }
  return [];
 }
 Future<void> clearSession()=>LocalStore.setCurrentUser(null);
}
