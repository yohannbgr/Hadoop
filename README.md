# Projet Hadoop – Analyse des accidents aux États-Unis

## Description
Ce projet consiste à analyser un jeu de données volumineux sur les accidents de la route aux États-Unis à l’aide des technologies Hadoop.

L’objectif est de mettre en pratique une architecture distribuée en utilisant :

HDFS pour le stockage des données,
MapReduce pour le traitement distribué,
YARN pour la gestion des ressources,
Hive pour l’analyse des données en SQL.

## Données

Le dataset utilisé est US Accidents (Kaggle).

Fichier : USA.csv
Taille : environ 2.8 Go
Contenu : informations sur les accidents (localisation, date, gravité, météo…)

## Structure du projet
/us_accidents/
│
├── mapper_state_count.py
├── reducer_state_count.py
├── mapper_severity_by_state.py
├── reducer_severity_by_state.py
├── hive_analysis.hql
└── README.md

## Fonctionnalités

### MapReduce

5 jobs ont été réalisés :

Nombre d’accidents par État
Gravité moyenne par État
Nombre d’accidents par mois
Nombre d’accidents par condition météo
Gravité moyenne par condition météo
Hive

Analyse des données via SQL :

Accidents par État
Gravité moyenne
Évolution temporelle
Analyse météo

Export des résultats dans HDFS.

## Lancer le projet
1. Charger les données dans HDFS
hdfs dfs -put USA.csv /user/cloudera/us_accidents/input/
2. Lancer un job MapReduce (exemple)
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -files mapper_state_count.py,reducer_state_count.py \
  -mapper "python mapper_state_count.py" \
  -reducer "python reducer_state_count.py" \
  -input /user/cloudera/us_accidents/input/USA.csv \
  -output /user/cloudera/us_accidents/output_state_count
3. Lancer les analyses Hive
hive -f hive_analysis.hql

## Résultats

Les résultats sont stockés dans HDFS :
/user/cloudera/us_accidents/hive_results/

## Conclusion

Ce projet montre comment traiter et analyser des données massives avec Hadoop, en combinant MapReduce et Hive pour obtenir des résultats fiables et exploitables.
