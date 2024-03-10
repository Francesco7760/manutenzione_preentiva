# progetto Data Challenge – PHM Asia Pacific 2023
Il seguente repository riguarda lo sviluppo del progetto d'esame del corso **MANUTENZIONE PREVENTIVA PER LA ROBOTICA E L'AUTOMAZIONE INTELLIGENTE**, è possibile trovare uno script Matlab usato per le analisi richieste e anche una documentazione dettagliata.

- Script -> **script_matalb.m**
- Documentazione [pdf] -> **documentazione.pdf**
- Documentazione [docx] -> **documentazione.docx**
## 
Per eseguire lo script basta caricarlo in **Matlab** e dare il **Run** direttamente dalla sezione **EDITOR**
Inoltre sono presenti varie sessioni di **Diagnostic Features Design** e **Classification Learner** utlizzate per portare a termine l'analisi, il contenuto e il ruole delle stesse è spiegato al interno della documentazione.

## Struttura directory 

La directory principale è cosi suddivisa:
### /dataset
contiene i dataset per il trainin e i dati da classificare

### sessioni di Diagiodti Features Design
- features_train_normal_abnormal.mat
- features_train_anomaly_fault.mat
- features_train_anomaly_position_BP_BV.mat
- features_train_fault_position_SV.mat
- features_train_fault_position_SV_percent.mat

### sessioni di Classification Learner
- classification_train_anomaly_fault_T-test.mat
- classification_train_anomaly_position_BP_BV_ANOVA.mat
- classification_train_fault_position_percent_SV_ANOVA.mat
- classification_train_fault_position_SV_ANOVA.mat
- classification_train_normal_abnormal_T-test.mat

### classificatori
- ensemble_boosted_tree_normal_abnormal.mat
- ensemble_subspace_discriminant_fault_anomaly.mat
- ensemble_bagged_trees_anomaly_position_BP_BV.mat
- ensemble_boosted_trees_fault_position_SV.mat
- ensemble_subspace_KNN_fault_position_SV_percent.mat

Studente: Francesco Di Bernardo
