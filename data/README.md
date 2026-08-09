# Data

This folder is intentionally empty of data files (they are git-ignored) because
of their size and licensing. To reproduce the analysis, add the files below.

## 1. Raw dataset (needed for scripts 02-03)
Download **Google Play Store Apps** from Kaggle and save it here as
`Google-Playstore.csv`:
<https://www.kaggle.com/datasets/gauthamp10/google-playstore-apps>

(~2.3M rows. Check the dataset license before redistributing any derivative.)

## 2. Manually coded sample (needed for scripts 04-13)
The stratified sample of 200 apps with manually coded gamification variables:

- `muestra_200_RECONCILIADA.xlsx` (sheet `CODIFICACION`) - reconciled sample
- `muestra_200_CODIFICADA.xlsx`   (sheet `CODIFICACION`) - rater 1 coding
- `codificacion_juez2.xlsx`       - rater 2 coding (used only for Cohen's kappa)

## Column reference
Binary coded columns keep their original names so the code matches the source
files. Their meaning:

| Column                | Meaning                                              |
|-----------------------|------------------------------------------------------|
| `V_Niveles`           | Levels                                               |
| `V_Recompensas`       | Rewards                                              |
| `V_Ranking`           | Ranking / leaderboards                               |
| `V_Avatares`          | Avatars                                              |
| `V_Feedback`          | Feedback                                             |
| `EstratoPopularidad`  | Popularity stratum: Baja / Media / MediaAlta / Alta  |
|                       | (= Low / Mid / Upper-Mid / High)                     |
