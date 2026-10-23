# BAJ-NEMO — Démo Flutter locale (sans backend)

Cette version de démonstration fonctionne sans serveur. Les comptes, la session, les favoris, les demandes de devis et les rendez-vous sont enregistrés localement sur le téléphone avec `shared_preferences`.

## Lancer
```bash
flutter pub get
flutter run
```

## Fonctions de démonstration
- Inscription et connexion locales (téléphone/e-mail + mot de passe).
- Accueil, catégories, recherche et profils prestataires fictifs.
- Appel, WhatsApp et itinéraire externe si l'appareil dispose des applications nécessaires.
- Conditions générales de démonstration intégrées localement.
- Demandes de devis, rendez-vous, favoris et profil local.
- Couleurs BAJ-NEMO et ressources de marque incluses.

## Important
- Les profils, avis, notes, prix et coordonnées de cette version sont fictifs. Ne les utilisez pas comme données réelles, notamment pour les médecins ou pharmacies de garde.
- Les demandes ne sont pas transmises à un prestataire : elles restent sur l'appareil.
- `shared_preferences` n'est pas un coffre-fort. Cette démo stocke le mot de passe localement pour simplifier les essais. Ne publiez pas cette version en production sans remplacer cela par un stockage sécurisé et une authentification backend.
- Les favoris sont enregistrés localement, mais cette démo ne synchronise rien entre appareils.
- Pour passer en production, remplacez les services de démo par les API backend et ajoutez des validations, gestion de compte et protections de données.
