import '../models/provider.dart';
import '../models/service_category.dart';
class DemoData {
 static const categories = <ServiceCategory>[
  ServiceCategory(id:'delivery',name:'Livreur',description:'Livraison et courses'),
  ServiceCategory(id:'plumbing',name:'Plombier',description:'Dépannage plomberie'),
  ServiceCategory(id:'electricity',name:'Électricien',description:'Installation et réparation'),
  ServiceCategory(id:'mechanic',name:'Mécanicien',description:'Entretien automobile'),
  ServiceCategory(id:'hair',name:'Coiffeur',description:'Coiffure et soins'),
  ServiceCategory(id:'restaurant',name:'Restaurant',description:'Repas et restauration'),
  ServiceCategory(id:'doctor',name:'Médecin spécialiste',description:'Consultations'),
  ServiceCategory(id:'pharmacy',name:'Pharmacie de garde',description:'Appeler avant déplacement'),
  ServiceCategory(id:'driver',name:'Chauffeur',description:'Transport'),
  ServiceCategory(id:'teacher',name:'Enseignant à domicile',description:'Cours particuliers'),
  ServiceCategory(id:'wash',name:'Lavage auto',description:'Nettoyage de véhicule'),
  ServiceCategory(id:'farmer',name:'Éleveur',description:'Élevage et produits animaux'),
  ServiceCategory(id:'phone',name:'Vendeur de téléphones',description:'Téléphones et accessoires'),
  ServiceCategory(id:'repair',name:'Réparateur de téléphones',description:'Réparation mobile'),
 ];
 static const providers = <ServiceProvider>[
  ServiceProvider(id:'p1',name:'Moussa Garba',profession:'Plombier',description:'Dépannage, installation sanitaire et recherche de fuite.',phone:'22790000001',whatsapp:'22790000001',address:'Niamey, Plateau',latitude:13.5116,longitude:2.1254,rating:4.8,reviewCount:32,categoryName:'Plombier'),
  ServiceProvider(id:'p2',name:'Aïchatou Issaka',profession:'Coiffeuse',description:'Coiffure, tresses et soins à domicile sur rendez-vous.',phone:'22790000002',whatsapp:'22790000002',address:'Niamey, Yantala',latitude:13.5350,longitude:2.1010,rating:4.9,reviewCount:47,categoryName:'Coiffeur'),
  ServiceProvider(id:'p3',name:'Garage Wadata',profession:'Mécanicien',description:'Diagnostic, entretien et réparations automobiles.',phone:'22790000003',whatsapp:'22790000003',address:'Niamey, Wadata',latitude:13.5000,longitude:2.1150,rating:4.6,reviewCount:26,categoryName:'Mécanicien'),
  ServiceProvider(id:'p4',name:'Amadou Abdou',profession:'Électricien',description:'Installation électrique, éclairage et dépannage.',phone:'22790000004',whatsapp:'22790000004',address:'Niamey, Lazaret',latitude:13.5500,longitude:2.1300,rating:4.7,reviewCount:19,categoryName:'Électricien'),
  ServiceProvider(id:'p5',name:'Express Sahel',profession:'Livreur',description:'Courses, documents et petits colis dans Niamey.',phone:'22790000005',whatsapp:'22790000005',address:'Niamey, Centre-ville',latitude:13.5150,longitude:2.1170,rating:4.5,reviewCount:41,categoryName:'Livreur'),
  ServiceProvider(id:'p6',name:'Cabinet Santé Plus',profession:'Médecin spécialiste',description:'Cabinet médical de démonstration. Confirmez la spécialité et les disponibilités par téléphone.',phone:'22790000006',whatsapp:'22790000006',address:'Niamey, Terminus',latitude:13.5050,longitude:2.0900,rating:4.4,reviewCount:15,categoryName:'Médecin spécialiste'),
  ServiceProvider(id:'p7',name:'Restaurant Le Sahel',profession:'Restaurant',description:'Cuisine locale et plats du jour.',phone:'22790000007',whatsapp:'22790000007',address:'Niamey, Plateau',latitude:13.5200,longitude:2.1200,rating:4.3,reviewCount:58,categoryName:'Restaurant'),
  ServiceProvider(id:'p8',name:'Prof Mariama',profession:'Enseignante à domicile',description:'Accompagnement scolaire et cours particuliers.',phone:'22790000008',whatsapp:'22790000008',address:'Niamey, Yantala',latitude:13.5300,longitude:2.1050,rating:4.9,reviewCount:22,categoryName:'Enseignant à domicile'),
  ServiceProvider(id:'p9',name:'Phone Expert',profession:'Réparateur de téléphones',description:'Diagnostic et réparation de smartphones.',phone:'22790000009',whatsapp:'22790000009',address:'Niamey, Grand Marché',latitude:13.5160,longitude:2.1100,rating:4.6,reviewCount:34,categoryName:'Réparateur de téléphones'),
  ServiceProvider(id:'p10',name:'Pharmacie du Centre',profession:'Pharmacie',description:'Données fictives de démonstration. Vérifiez les horaires de garde par téléphone.',phone:'22790000010',whatsapp:'22790000010',address:'Niamey, Centre-ville',latitude:13.5170,longitude:2.1150,rating:4.2,reviewCount:12,categoryName:'Pharmacie de garde'),
 ];
}
