import '../models/provider.dart';
import '../models/service_category.dart';
import 'demo_data.dart';
class DiscoveryService {
 Future<List<ServiceCategory>> categories() async=>DemoData.categories;
 Future<List<ServiceProvider>> providers({String query='',String? categoryId,double? lat,double? lng}) async {final q=query.trim().toLowerCase();return DemoData.providers.where((p){final categoryNames = {'delivery':'Livreur','plumbing':'Plombier','electricity':'Électricien','mechanic':'Mécanicien','hair':'Coiffeur','restaurant':'Restaurant','doctor':'Médecin spécialiste','pharmacy':'Pharmacie de garde','driver':'Chauffeur','teacher':'Enseignant à domicile','wash':'Lavage auto','farmer':'Éleveur','phone':'Vendeur de téléphones','repair':'Réparateur de téléphones'};final cat=categoryId==null||categoryId.isEmpty||p.id==categoryId||p.categoryName==categoryId||p.categoryName==categoryNames[categoryId];final hay='${p.name} ${p.profession} ${p.address} ${p.description} ${p.categoryName}'.toLowerCase();return cat&&(q.isEmpty||hay.contains(q));}).toList();}
 Future<ServiceProvider> provider(String id) async=>DemoData.providers.firstWhere((p)=>p.id==id);
}
