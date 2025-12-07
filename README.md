# Prime Work - Application Herbalife

Application mobile tout-en-un pour les distributeurs Herbalife, développée avec Flutter.

## 🎯 Description

Prime Work est une application complète conçue pour aider les distributeurs Herbalife à gérer leur activité de manière professionnelle et efficace. Elle combine CRM, gestion de tâches, suivi d'activité et bien plus encore.

## ✨ Fonctionnalités

### 🔐 Authentification
- Connexion par email/mot de passe
- Authentification sociale (Google, Apple, Microsoft)
- Système d'onboarding moderne
- Période d'essai gratuite de 7 jours

### 📊 Tableau de bord
- Vue d'ensemble de l'activité
- Statistiques en temps réel (clients, équipe, VP, objectifs)
- Actions rapides (nouveau prospect, commande, événement, tâche)
- Activités récentes
- Design moderne avec animations fluides

### 👥 CRM Clients & Prospects
- Gestion complète des prospects et clients
- Système de notifications intelligentes pour les relances
- Filtres avancés (à relancer, nouveaux, chauds, inactifs)
- Suivi des commandes par client
- Historique des interactions
- Statuts personnalisables

### 🏢 CRM Équipe
- Suivi de l'activité de votre équipe MLM
- Vue d'ensemble des performances
- Statistiques par membre (VP, taille d'équipe, activité)
- Niveaux de distributeur avec badges visuels
- Actions rapides (appel, message, profil)

### ✅ Gestion de Tâches (Matrice d'Eisenhower)
- Priorisation selon urgence et importance
- Vue matrice ou liste
- 4 quadrants : Urgent & Important, Important, Urgent, Autres
- Système de validation des tâches
- Date d'échéance et rappels

### 📈 Tracker d'Activité - Plan 90 Jours
- Méthode du plan à 90 jours
- Objectifs personnalisables
- Suivi quotidien, hebdomadaire, mensuel
- Validation quotidienne des réalisations
- Graphiques de progression
- Série de jours consécutifs (streak)
- Statistiques détaillées

### Fonctionnalités à venir
- 🛍️ Boutique produits Herbalife (en attente API officielle)
- 🗺️ Carte interactive des Shake Bars et Nutrition Clubs
- 📅 Calendrier d'événements communautaire
- 🤖 Assistant IA spécialisé Herbalife
- 🔗 Connexion réseaux sociaux
- 🔄 Synchronisation My Herbalife (en attente API)
- 💳 Système de paiement et abonnement (5€/mois ou 49€/an)

## 🎨 Design

L'application utilise un design system moderne avec :
- **Palette de couleurs professionnelle** : Indigo, Green, Amber
- **Typography** : Google Fonts (Inter)
- **Animations fluides** avec flutter_animate
- **Interface Material Design 3**
- **Dark mode** prêt (à activer)
- **Responsive design** pour tous les écrans

## 🛠️ Technologies

- **Framework** : Flutter 3.0+
- **Langage** : Dart
- **State Management** : Riverpod
- **Navigation** : GoRouter
- **Backend (prévu)** : Firebase
  - Authentication
  - Firestore
  - Storage
  - Cloud Messaging
- **Animations** : flutter_animate
- **Charts** : fl_chart, syncfusion_flutter_charts
- **Maps** : google_maps_flutter
- **Paiements** : flutter_stripe

## 📁 Structure du Projet

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── router/
│       └── app_router.dart
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   ├── crm/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   ├── tasks/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   └── tracker/
│       └── presentation/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## 🚀 Installation

### Prérequis
- Flutter SDK 3.0 ou supérieur
- Dart SDK 3.0 ou supérieur

### Étapes

1. Cloner le repository
```bash
git clone https://github.com/votre-repo/prime-work.git
cd prime-work
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Lancer l'application
```bash
flutter run
```

## 📱 Compatibilité FlutterFlow

Ce projet est conçu pour être compatible avec FlutterFlow :
- Structure de projet standard Flutter
- Widgets Flutter natifs
- Architecture clean et modulaire
- Possibilité d'import dans FlutterFlow pour développement futur

## 🎯 Roadmap

### Phase 1 - ✅ Complétée
- [x] Design system et thème
- [x] Authentification (UI)
- [x] Dashboard
- [x] CRM Clients & Équipe (UI)
- [x] Gestion de tâches (Eisenhower)
- [x] Tracker 90 jours (UI)

### Phase 2 - En cours
- [ ] Intégration Firebase
- [ ] Authentification fonctionnelle
- [ ] Base de données Firestore
- [ ] Notifications push
- [ ] Logique métier CRM

### Phase 3 - À venir
- [ ] API Herbalife (en attente partenariat)
- [ ] Boutique produits
- [ ] Carte interactive
- [ ] Calendrier événements
- [ ] Assistant IA
- [ ] Système d'abonnement

## 📄 Licence

Tous droits réservés © 2024

## 👨‍💻 Développeur

Projet développé pour les distributeurs Herbalife.

---

**Note importante** : Ce projet est en développement actif. Les fonctionnalités liées à l'API Herbalife nécessitent une autorisation officielle avant implémentation.
