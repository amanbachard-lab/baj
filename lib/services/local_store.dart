import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class LocalStore {
 static const _users='baj_demo_users', _current='baj_demo_current', _favorites='baj_demo_favorites', _quotes='baj_demo_quotes', _appointments='baj_demo_appointments';
 static Future<List<Map<String,dynamic>>> _list(String key) async { final p=await SharedPreferences.getInstance(); final s=p.getString(key); if(s==null)return []; return (jsonDecode(s) as List).map((e)=>Map<String,dynamic>.from(e as Map)).toList(); }
 static Future<void> _save(String key,List<Map<String,dynamic>> v) async { final p=await SharedPreferences.getInstance(); await p.setString(key,jsonEncode(v)); }
 static Future<List<Map<String,dynamic>>> users()=>_list(_users);
 static Future<Map<String,dynamic>?> currentUser() async { final p=await SharedPreferences.getInstance(); final s=p.getString(_current); return s==null?null:Map<String,dynamic>.from(jsonDecode(s) as Map); }
 static Future<void> setCurrentUser(Map<String,dynamic>? u) async { final p=await SharedPreferences.getInstance(); if(u==null){await p.remove(_current);}else{await p.setString(_current,jsonEncode(u));} }
 static Future<void> register(Map<String,dynamic> u) async { final l=await users(); final id='${u['identifier']}'.trim().toLowerCase(); if(l.any((e)=>'${e['identifier']}'.trim().toLowerCase()==id)) throw Exception('Un compte existe déjà avec ce téléphone ou cet e-mail.'); l.add(u); await _save(_users,l); await setCurrentUser(u); }
 static Future<Map<String,dynamic>> login(String id,String pw) async { for(final u in await users()){if('${u['identifier']}'.trim().toLowerCase()==id.trim().toLowerCase() && '${u['password']}'==pw){await setCurrentUser(u);return u;}} throw Exception('Identifiants incorrects sur cet appareil.'); }
 static Future<List<String>> favorites() async {final p=await SharedPreferences.getInstance();return p.getStringList(_favorites)??[];}
 static Future<void> toggleFavorite(String id) async {final p=await SharedPreferences.getInstance();final l=p.getStringList(_favorites)??[];if(l.contains(id)){l.remove(id);}else{l.add(id);}await p.setStringList(_favorites,l);}
 static Future<List<Map<String,dynamic>>> quotes()=>_list(_quotes);
 static Future<void> addQuote(Map<String,dynamic> q) async {final l=await quotes();l.insert(0,q);await _save(_quotes,l);}
 static Future<List<Map<String,dynamic>>> appointments()=>_list(_appointments);
 static Future<void> addAppointment(Map<String,dynamic> a) async {final l=await appointments();l.insert(0,a);await _save(_appointments,l);}
}
