# QuantBot v1.0 — Guide d'installation MetaTrader 5

## Étape 1 : Copier le fichier EA

1. Ouvrir MetaTrader 5
2. Menu : **Fichier → Ouvrir le dossier des données**
3. Naviguer vers : `MQL5 / Experts /`
4. Copier `QuantBot_v1.mq5` dans ce dossier

## Étape 2 : Compiler

1. Dans MT5, ouvrir **MetaEditor** (touche F4)
2. Dans l'arborescence à gauche : `Expert Advisors → QuantBot_v1`
3. Cliquer **Compiler** (F7)
4. Vérifier qu'il n'y a aucune erreur en bas

## Étape 3 : Backtest (OBLIGATOIRE avant live)

1. Ouvrir le **Testeur de stratégie** (Ctrl+R)
2. Paramètres :
   - Expert Advisor : `QuantBot_v1`
   - Symbole : `BTCUSD` ou `EURUSD`
   - Période : `D1` (journalier)
   - Mode : **Chaque tick basé sur ticks réels** (plus précis)
   - Dates : 2 ans minimum
3. Lancer le backtest et analyser les résultats

## Étape 4 : Déploiement sur compte DÉMO

1. Ouvrir un graphique (ex: BTCUSD, D1)
2. Dans le **Navigateur** (Ctrl+N) : `Expert Advisors → QuantBot_v1`
3. Glisser l'EA sur le graphique
4. Dans les paramètres :
   - Onglet **Commun** : cocher "Autoriser le trading automatique"
   - Onglet **Entrées** : configurer selon les presets
5. Vérifier que le bouton "Auto Trading" en haut est bien **activé** (vert)
6. Surveiller pendant 2-4 semaines sur DEMO

## Étape 5 : Passage en live (après validation DEMO)

- Changer le compte dans MT5 pour ton compte réel
- Réduire `RiskPct` à 0.5% pour commencer
- Garder `MaxDailyLoss` à 3%

## Brokers compatibles MT5 avec crypto

- **ICMarkets** — BTCUSD, ETHUSD, spreads compétitifs
- **Pepperstone** — large gamme crypto, bon support EA
- **Admiral Markets** — crypto + forex + actions
- **XM** — démo illimitée pour tester

## Paramètres recommandés par type d'actif

| Actif     | Timeframe | Stratégie          | RiskPct |
|-----------|-----------|-------------------|---------|
| BTCUSD    | D1        | Combined / Bollinger | 0.5-1% |
| ETHUSD    | D1        | Volume Trend       | 0.5-1% |
| EURUSD    | H4        | MACD / Combined    | 0.5%   |
| SPY/NDX   | D1        | Golden Cross       | 1%     |

## Avertissement

Ce bot est un outil d'aide à la décision. Les marchés peuvent être
imprévisibles. Ne jamais investir plus que ce que tu es prêt à perdre.
Toujours tester sur démo en premier.
