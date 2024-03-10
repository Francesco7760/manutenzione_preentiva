% 0. ETL datasets
% 1. Determine normal or abnormal  (normal_abnormal) 
% #### 0 = normal    1 = abnormal
% 2. Determine anomaly, fault, or unknown fault (anomaly_fault)
% #### 1 = unknow condtion   2 = anomaly   3 = fault
% 3. Determine anomaly position BV1, and BP1 to BP7 (anomaly_position_BP_BV)
% #### 1 = BP1  2 = BP2  3 = BP3 4 = BP4  5 = BPV5 6 = BP6  7 = BP7 8 = BV1
% 4. Determine fault position in SV1-4 (fault_position_SV)
% #### 1 = SV1  2 = SV2 3 = SV3 4 = SV4
% 5. Determine percent on fault SV1-4 0% <= Opening ration < 100% (fault_position_SV_percent)

%% [0.1] CARICAMENTO CSV E XLSX
% importare file xlsx delle labels
table_labels_train = readtable('dataset/train/labels.xlsx');
table_labels_test = readtable('dataset/test/labels_spacecraft.xlsx');

% importare i files csv
file_train = dir(fullfile('dataset/train/data/', '*.csv'));
file_test = dir(fullfile('dataset/test/data/', '*.csv'));

%% [0.2] CREAZIONE TABELLE PER TRAIN E INFERENZA 
% creazione tabelle per dati training
for k = 1:numel(file_train)
    F = fullfile(file_train(k).folder, file_train(k).name);
    Train{k} = readtable(F);
end

% creazione tabelle per dati per inferenza 
for k = 1:numel(file_test)
    T = fullfile(file_test(k).folder, file_test(k).name);
    Test{k} = readtable(T);
end

% aggiunge colonna time_tables alla tabella labels
table_labels_train.Case_Table = Train';
table_labels_test.Case_Table = Test';

%% [0.3] correzzioni tabella table_labels_train
[r_1,c_1] = size(table_labels_train);

% [0.3.1] CREAZIONE E AGGIUNTA COLONNA "normal_abnormal"
% creazione colonna "normal_abnormal"
% - con code 'Normal' => 0
% - con code 'Fault' o 'Anomaly' => 1

for x = 1:r_1
    switch table_labels_train.Var3{x}
        case 'Normal'
            vector_normal_abnormal_train(x) = 0
        case 'Fault'
            vector_normal_abnormal_train(x) = 1
        case 'Anomaly'
            vector_normal_abnormal_train(x) = 1
    end
end

% aggiungi colonna 'normal_abnormal' in labels test
table_labels_train.normal_abnormal = vector_normal_abnormal_train';

% [0.3.2] CREAZIONE E AGGIUNTA COLONNA "anomaly_fault"
% creazione colonna "anomaly_fault"
% con code 'Normal' => 0
% con code 'Fault' => 3
% con code 'Anomaly' => 2

for x = 1:r_1
    switch table_labels_train.Var3{x}
        case 'Normal'
            vector_anomaly_fault_train(x) = 0
        case 'Fault'
            vector_anomaly_fault_train(x) = 3
        case 'Anomaly'
            vector_anomaly_fault_train(x) = 2
    end
end

% aggiungi colonna 'anomaly_fault' in labels test
table_labels_train.anomaly_fault = vector_anomaly_fault_train'

% [0.3.3] CREAZIONE A AGGIUNTA COLONNA  "anomaly_position_BP_BV"
% creazione colonna "anomaly_position_BP_BV"
% con code 'BV1' => 8
% con code 'BP1' => 1
% con code 'BP2' => 2
% con code 'BP3' => 3
% con code 'BP4' => 4
% con code 'BP5' => 5
% con code 'BP6' => 6
% con code 'BP7' => 7
% con code 'senza anomaly' => 0

 for x = 1:r_1
     if isequal(table_labels_train.BV1{x}, 'No') & isequal(table_labels_train.BP1{x}, 'No') & isequal(table_labels_train.BP2{x}, 'No') & isequal(table_labels_train.BP3{x}, 'No') & isequal(table_labels_train.BP4{x}, 'No') & isequal(table_labels_train.BP5{x}, 'No') & isequal(table_labels_train.BP6{x}, 'No') & isequal(table_labels_train.BP7{x}, 'No') 
         vector_anomaly_position_BP_BV_train(x) = 0
     else
    switch table_labels_train.BV1{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 8
     end
 
      switch table_labels_train.BP1{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 1
      end
 
      switch table_labels_train.BP2{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 2
      end
 
     switch table_labels_train.BP3{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 3
     end
 
     switch table_labels_train.BP4{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 4
     end
 
     switch table_labels_train.BP5{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 5
     end
 
     switch table_labels_train.BP6{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 6
     end
 
     switch table_labels_train.BP7{x}
         case 'Yes'
             vector_anomaly_position_BP_BV_train(x) = 7
     end
     end
 end

 % aggiungi colonna 'anomaly_position_BP_BV'  in labels test
 table_labels_train.anomaly_position_BP_BV = vector_anomaly_position_BP_BV_train'

% [0.3.4] CREAZIONE E AGGIUNTA COLONNA  'fault_position_SV'
% creazione colonna 'fault_position_SV'
% con code 'SV1' => 1
% con code 'SV2' => 2
% con code 'SV3' => 3
% con code 'SV4' => 4
% con code 'senza fault' => 0

for x=1:r_1 
    if isequal(table_labels_train.SV1(x), 100) & isequal(table_labels_train.SV2(x), 100) &isequal(table_labels_train.SV3(x), 100) & isequal(table_labels_train.SV4(x), 100)
        vector_fault_position_SV_train(x) = 0
    elseif isequal(table_labels_train.SV1(x), 0) | isequal(table_labels_train.SV1(x), 25) | isequal(table_labels_train.SV1(x), 50) | isequal(table_labels_train.SV1(x), 75)
        vector_fault_position_SV_train(x) = 1
    elseif isequal(table_labels_train.SV2(x), 0) | isequal(table_labels_train.SV2(x), 25) | isequal(table_labels_train.SV2(x), 50) | isequal(table_labels_train.SV2(x), 75)
        vector_fault_position_SV_train(x) = 2
    elseif isequal(table_labels_train.SV3(x), 0) | isequal(table_labels_train.SV3(x), 25) | isequal(table_labels_train.SV3(x), 50) | isequal(table_labels_train.SV3(x), 75)
        vector_fault_position_SV_train(x) = 3
    elseif isequal(table_labels_train.SV4(x), 0) | isequal(table_labels_train.SV4(x), 25) | isequal(table_labels_train.SV4(x), 50) | isequal(table_labels_train.SV4(x), 75)
        vector_fault_position_SV_train(x) = 4
    end
end

% aggiungi colonna 'fault_position_SV'  in labels test
table_labels_train.fault_position_SV = vector_fault_position_SV_train'

% [0.3.5] CREAZIONE E AGGIUNTA COLONNA "fault_position_SV_percent"
% creazione colonna 'fault_position_SV_percent'
% descrizione dettagliata nella relazione

 for x = 1:r_1
     if isequal(table_labels_train.fault_position_SV(x), 0) 
         vector_fault_position_SV_percent_train(x) = 100
     else
    switch  table_labels_train.fault_position_SV(x)
        case 1
             vector_fault_position_SV_percent_train(x) = table_labels_train.SV1(x)
     end
    switch  table_labels_train.fault_position_SV(x)
         case 2
             vector_fault_position_SV_percent_train(x) = table_labels_train.SV2(x)
    end
        switch  table_labels_train.fault_position_SV(x)
         case 3
             vector_fault_position_SV_percent_train(x) = table_labels_train.SV3(x)
        end
            switch  table_labels_train.fault_position_SV(x)
         case 4
             vector_fault_position_SV_percent_train(x) = table_labels_train.SV4(x)
        end
     end
 end

 % aggiunta colonna 'fault_position_SV_percent' in labels test
table_labels_train.fault_position_SV_percent = vector_fault_position_SV_percent_train'

%% [0.4] tabelle finali per training
% per facilitare l'estrazione e selezione delle features si è separato
% l'intero dataset di train in singole tabelle contenenti solo la colonne
% necessarie

% [0.4.1]
% per l'analisi 'normal_abnormal' consideriamo solo le colonne 1, 17 e 16
table_labels_train_normal_abnormal = table_labels_train(:, [1, 17, 16])

% [0.4.2]
% per l'analisi 'anomaly_fault' consideriamo solo le colonne 1, 18 e 16
table_labels_train_anomaly_fault = table_labels_train(:, [1, 18, 16])
table_labels_train_anomaly_fault =  table_labels_train_anomaly_fault((table_labels_train_anomaly_fault.anomaly_fault) ~= 0, :)

% [0.4.3]
% per l'analisi 'anomaly_position_BP_BV' consideriamo solo le colonne 1, 19 e 16
table_labels_train_anomaly_position_BP_BV = table_labels_train(:, [1, 19, 16])
table_labels_train_anomaly_position_BP_BV =  table_labels_train_anomaly_position_BP_BV((table_labels_train_anomaly_position_BP_BV.anomaly_position_BP_BV) ~= 0, :)

% [0.4.4]
% per l'analisi 'fault_position_SV' consideriamo solo le colonne 1, 20 e 16
table_labels_train_fault_position_SV = table_labels_train(:, [1, 20, 16])
table_labels_train_fault_position_SV =  table_labels_train_fault_position_SV((table_labels_train_fault_position_SV.fault_position_SV) ~= 0, :)

% [0.4.5]
% per l'analisi 'position_SV_percent' consideriamo solo le colonne 1, 21 e 16
table_labels_train_fault_position_SV_percent = table_labels_train(:, [1, 21, 16])
table_labels_train_fault_position_SV_percent =  table_labels_train_fault_position_SV_percent((table_labels_train_fault_position_SV_percent.fault_position_SV_percent) ~= 100, :)

% [0.5] caricamento tabella features test, per classificare tutti i dati Test (INFERENZA)
load('table_features_test.mat')

%% [1] INFERENZA "normal_abnormal"
% [1.1] caricamento tabella features dei dati di test per "normal_abnormal"
load('ensemble_boosted_tree_normal_abnormal.mat')

% [1.2] classificazione "normal_abnormal"
[data_classification_normal_abnormal, scores_data_classification_normal_abnormal] = ensemble_boosted_tree_normal_abnormal.predictFcn(table_features_test)
data_classification_normal_abnormal = [table_features_test.Case_, data_classification_normal_abnormal]

[r_2, c_2] = size(table_labels_test)
z = 1
for x=1:r_2
    vector_summ_normal_abnormal(x,1) = data_classification_normal_abnormal(z,1)
    vector_summ_normal_abnormal(x,2) = data_classification_normal_abnormal(z,2) + data_classification_normal_abnormal(z+1,2) + data_classification_normal_abnormal(z+2,2)
    z = z + 3
end

% [1.3] determinare le situazioni di normalità
% per ogni Case_ abbiamo 3 elementi classificati
% - Case_ con 3 membri = 0 ->  situazione "normal" (0)
% - Case_ con 1 o più membri diversi da 0 -> situazione "abnormal" (1)

for x=1:r_2 
    if vector_summ_normal_abnormal(x,2) >= 1
        vector_result_classification_normal_abnormal(x) = 1
        vector_case_result_clssification_normal_abnormal(x) = vector_summ_normal_abnormal(x,1)
            else 
        vector_result_classification_normal_abnormal(x) = 0
        vector_case_result_clssification_normal_abnormal(x) = vector_summ_normal_abnormal(x,1)
    end
    vector_signal_result_classification_normal_abnormal(x) = table_labels_test(table_labels_test.Case_ == vector_summ_normal_abnormal(x,1), :).Case_Table
end

result_classification_normal_abnormal = table
result_classification_normal_abnormal.Case_ = vector_case_result_clssification_normal_abnormal'
result_classification_normal_abnormal.normal_abnormal= vector_result_classification_normal_abnormal'
result_classification_normal_abnormal.Case_Table = vector_signal_result_classification_normal_abnormal'

%% [2] INFERENZA "anomaly_fault"

% [2.1] caricamento tabella feaures dei dati di test per "anomaly_fault"
load("table_features_test_anomaly_fault.mat")

% [2.2] classificazione "anomaly_fault"
% consideriamo solo le situizoni abnormali quindi:% per semplificazione consideriamo solo situazioni di:
% - anomaly = 2
% - fault = 3
% "table_features_test_anomaly_fault" tabella che contiene le features dei dati da classificare 
table_labels_test_anomaly_fault = result_classification_normal_abnormal((result_classification_normal_abnormal.normal_abnormal) == 1,: )
load('ensemble_subspace_discriminant_fault_anomaly.mat')

[data_classification_anomaly_fault, scores_data_classification_anomaly_fault] = ensemble_subspace_discriminant_fault_anomaly.predictFcn(table_features_test_anomaly_fault)
data_classification_anomaly_fault = [table_features_test_anomaly_fault.Case_, data_classification_anomaly_fault]

% [2.3] determinare le situazioni di anomaly o fault
% per ogni Case_ abbiamo 3 elementi classificati
% - Case_ con 3 membri = 2 ->  situazione "fault" (2)
% - Case_ con 3 membri = 3 ->  situazione "anomaly" (3)
% - Case_ con 1 o più membri diversi  -> situazione "unknown" (-1)
[r_3,c_3] = size(table_labels_test_anomaly_fault)

for x=1:r_3
    count_2 = 0
    count_3 = 0
    for y= 1:3         
        switch data_classification_anomaly_fault(y + (x-1)*3,2) 
            case 2
                count_2 = count_2 + 1
            case 3
                count_3 = count_3 + 1
        end
 end
        if count_2 == 3
            vector_case_result_clssification_anomaly_fault(x) = data_classification_anomaly_fault(x*3 ,1)
            vector_result_classification_anomaly_fault(x) = 2    
            
        elseif count_3 == 3
            vector_case_result_clssification_anomaly_fault(x) = data_classification_anomaly_fault(x*3,1)
            vector_result_classification_anomaly_fault(x) = 3
        
        else
            vector_case_result_clssification_anomaly_fault(x) = data_classification_anomaly_fault(x*3,1)
            vector_result_classification_anomaly_fault(x) = -1
       
    end
    vector_signal_result_classification_anomaly_fault(x) = table_labels_test_anomaly_fault.Case_Table(x)

end

result_classification_anomaly_fault = table
result_classification_anomaly_fault.Case_ = vector_case_result_clssification_anomaly_fault'
result_classification_anomaly_fault.anomaly_fault= vector_result_classification_anomaly_fault'
result_classification_anomaly_fault.Case_Table = vector_signal_result_classification_anomaly_fault'

%% [3] INFERENZA "anomaly_position_BP_BV"

% [3.1] caricamento tabella feaures dei dati di test per "anomaly_position_BP_BV"
load("table_features_test_anomaly_position_BP_BV.mat")

% [3.2] classificazione "anomaly_position_BP_BV"
% iniziamo con il determinare le solo situazioni di anomaly dal precedente
% risultato:
% - 1 = BP1  
% - 2 = BP2  
% - 3 = BP3 
% - 4 = BP4  
% - 5 = BPV5 
% - 6 = BP6  
% - 7 = BP7 
% - 8 = BV1
% - -1 = unknown
% "table_features_test_anomaly_position_BP_BV" tabella che contiene le features dei dati da classificare
table_labels_test_anomaly_position_BP_BV = result_classification_anomaly_fault((result_classification_anomaly_fault.anomaly_fault) == 2,: )
load("ensemble_bagged_trees_anomaly_position_BP_BV.mat")

[data_classification_anomaly_position_BP_BV, scores_data_classification_anomaly_position_BP_BV] = ensemble_bagged_trees_anomaly_position_BP_BV.predictFcn(table_features_test_anomaly_position_BP_BV)
data_classification_anomaly_position_BP_BV = [table_features_test_anomaly_position_BP_BV.Case_, data_classification_anomaly_position_BP_BV]

% [3.3] determinare le situazioni di anomaly o fault
% per ogni Case_ abbiamo 3 elementi classificati
% - Case_ con 3 membri = 1 ->  situazione "BP1" (1)
% - Case_ con 3 membri = 2 ->  situazione "BP2" (2)
% - Case_ con 3 membri = 3 ->  situazione "BP3" (3)
% - Case_ con 3 membri = 4 ->  situazione "BP4" (4)
% - Case_ con 3 membri = 5 ->  situazione "BP5" (5)
% - Case_ con 3 membri = 6 ->  situazione "BP6" (6)
% - Case_ con 3 membri = 7 ->  situazione "BP7" (7)
% - Case_ con 3 membri = 8 ->  situazione "BV1" (8)
% - Case_ con 1 o più membri diversi  -> situazione "unknown" (-1)
[r_4,c_4] = size(table_labels_test_anomaly_position_BP_BV)

for x=1:r_4
    count_1 = 0
    count_2 = 0
    count_3 = 0
    count_4 = 0
    count_5 = 0
    count_6 = 0
    count_7 = 0
    count_8 = 0
    for y= 1:3         
        switch data_classification_anomaly_position_BP_BV(y + (x-1)*3,2) 
            case 1
                count_1 = count_1 + 1
            case 2
                count_2 = count_2 + 1
            case 3
                count_3 = count_3 + 1
            case 4
                count_4 = count_4 + 1
            case 5
                count_5 = count_5 + 1
            case 6
                count_6 = count_6 + 1
            case 7
                count_7 = count_7 + 1
            case 8
                count_8 = count_8 + 1
        end
 end
        if count_1 == 3
            vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 1    
            
        elseif count_2 == 3
            vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 2
        elseif count_3 == 3
            vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 3
        elseif count_4 == 3
            vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 4
        elseif count_5 == 3
             vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 5
        elseif count_6 == 3
             vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 6
        elseif count_7 == 3
             vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 7
        elseif count_8 == 3
             vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3 ,1)
            vector_result_classification_anomaly_position_BP_BV(x) = 8
        
        else
            vector_case_result_clssification_anomaly_position_BP_BV(x) = data_classification_anomaly_position_BP_BV(x*3,1)
            vector_result_classification_anomaly_position_BP_BV(x) = -1
       
    end
    vector_signal_result_classification_anomaly_position_BP_BV(x) = table_labels_test_anomaly_position_BP_BV.Case_Table(x)

end

result_classification_anomaly_position_BP_BV = table
result_classification_anomaly_position_BP_BV.Case_ = vector_case_result_clssification_anomaly_position_BP_BV'
result_classification_anomaly_position_BP_BV.anomaly_position_BP_BV= vector_result_classification_anomaly_position_BP_BV'
result_classification_anomaly_position_BP_BV.Case_Table = vector_signal_result_classification_anomaly_position_BP_BV'

%% [4] INFERENZA "fault_position_SV"

% [4.1] caricamento tabella feaures dei dati di test per "fault_position_SV"
load("table_features_test_fault_position_SV.mat")

% [4.2] classificazione "fault_position_SV"
% iniziamo con il determinare le solo situazioni di fault dal precedente:
% 1 = SV1  
% 2 = SV2 
% 3 = SV3 
% 4 = SV4
% -1 = unknown
table_labels_test_fault_position_SV = result_classification_anomaly_fault((result_classification_anomaly_fault.anomaly_fault) == 3,: )
load("ensemble_boosted_trees_fault_position_SV.mat")

[data_classification_fault_position_SV, scores_data_classification_fault_position_SV] = ensemble_boosted_trees_fault_position_SV.predictFcn(table_features_test_fault_position_SV)
data_classification_fault_position_SV = [table_features_test_fault_position_SV.Case_, data_classification_fault_position_SV]

% [4.3] determinare le situazioni di anomaly o fault
% per ogni Case_ abbiamo 3 elementi classificati
% - Case_ con 3 membri = 1 ->  situazione "SV1" (1)
% - Case_ con 3 membri = 2 ->  situazione "SV2" (2)
% - Case_ con 3 membri = 3 ->  situazione "SV3" (3)
% - Case_ con 3 membri = 4 ->  situazione "SV4" (4)
% - Case_ con 1 o più membri diversi  -> situazione "unknown" (-1)
[r_5,c_5] = size(table_labels_test_fault_position_SV)

for x=1:r_5
    count_1 = 0
    count_2 = 0
    count_3 = 0
    count_4 = 0
    for y= 1:3         
        switch data_classification_fault_position_SV(y + (x-1)*3,2) 
            case 1 
                count_1 = count_1 + 1
            case 2
                count_2 = count_2 + 1
            case 3
                count_3 = count_3 + 1
            case 4 
                count_4 = count_4 + 1
        end
 end
        if count_1 == 3
            vector_case_result_clssification_fault_position_SV(x) = data_classification_fault_position_SV(x*3 ,1)
            vector_result_classification_fault_position_SV(x) = 1    
            
        elseif count_2 == 3
            vector_case_result_clssification_fault_position_SV(x) = data_classification_fault_position_SV(x*3,1)
            vector_result_classification_fault_position_SV(x) = 2 

        elseif count_3 == 3
            vector_case_result_clssification_fault_position_SV(x) = data_classification_fault_position_SV(x*3,1)
            vector_result_classification_fault_position_SV(x) = 3

        elseif count_4 == 3
            vector_case_result_clssification_fault_position_SV(x) = data_classification_fault_position_SV(x*3,1)
            vector_result_classification_fault_position_SV(x) = 4 
        
        else
            vector_case_result_clssification_fault_position_SV(x) = data_classification_fault_position_SV(x*3,1)
            vector_result_classification_fault_position_SV(x) = -1
       
    end
    vector_signal_result_classification_fault_position_SV(x) = table_labels_test_fault_position_SV.Case_Table(x)

end

result_classification_fault_position_SV = table
result_classification_fault_position_SV.Case_ = vector_case_result_clssification_fault_position_SV'
result_classification_fault_position_SV.fault_position_SV= vector_result_classification_fault_position_SV'
result_classification_fault_position_SV.Case_Table = vector_signal_result_classification_fault_position_SV'

%% [5] INFERENZA "fault_position_SV_percent"

% [5.1] caricamento tabella feaures dei dati di test per "fault_position_SV_percent"
load("table_features_test_fault_position_SV_percent.mat")

% [5.2] classificazione "fault_position_SV_percent"
% iniziamo con il determinare le percentuali per ogni fault:
% 0 = 0%  
% 25 = 25% 
% 50 = 50% 
% 75 = 75%
% -1 = unknown
load("ensemble_subspace_KNN_fault_position_SV_percent.mat")

[data_classification_fault_position_SV_percent, scores_data_classification_fault_position_SV_percent] = ensemble_subspace_KNN_fault_position_SV_percent.predictFcn(table_features_test_fault_position_SV)
data_classification_fault_position_SV_percent = [table_features_test_fault_position_SV.Case_, data_classification_fault_position_SV_percent]

% [5.3] determinare le situazioni di anomaly o fault
% per ogni Case_ abbiamo 3 elementi classificati
% - Case_ con 3 membri = 1 ->  situazione "0" (1)
% - Case_ con 3 membri = 2 ->  situazione "25" (2)
% - Case_ con 3 membri = 3 ->  situazione "50" (3)
% - Case_ con 3 membri = 4 ->  situazione "75" (4)
% - Case_ con 1 o più membri diversi  -> situazione "unknown" (-1)
[r_5,c_5] = size(table_labels_test_fault_position_SV)

for x=1:r_5
    count_0 = 0
    count_25 = 0
    count_50 = 0
    count_75 = 0
    for y= 1:3         
        switch data_classification_fault_position_SV_percent(y + (x-1)*3,2) 
            case 0
                count_0 = count_0 + 1
            case 25
                count_25 = count_25 + 1
            case 50
                count_50 = count_50 + 1
            case 75
                count_75 = count_75 + 1
        end
 end
        if count_0 == 3
            vector_case_result_clssification_fault_position_SV_percent(x) = data_classification_fault_position_SV_percent(x*3 ,1)
            vector_result_classification_fault_position_SV_percent(x) = 0    
            
        elseif count_25 == 3
            vector_case_result_clssification_fault_position_SV_percent(x) = data_classification_fault_position_SV_percent(x*3,1)
            vector_result_classification_fault_position_SV_percent(x) = 25 

        elseif count_50 == 3
            vector_case_result_clssification_fault_position_SV_percent(x) = data_classification_fault_position_SV_percent(x*3,1)
            vector_result_classification_fault_position_SV_percent(x) = 50

        elseif count_75 == 3
            vector_case_result_clssification_fault_position_SV_percent(x) = data_classification_fault_position_SV_percent(x*3,1)
            vector_result_classification_fault_position_SV_percent(x) = 75 
        
        else
            vector_case_result_clssification_fault_position_SV_percent(x) = data_classification_fault_position_SV_percent(x*3,1)
            vector_result_classification_fault_position_SV_percent(x) = -1
       
    end
    vector_signal_result_classification_fault_position_SV_percent(x) = table_labels_test_fault_position_SV.Case_Table(x)

end

result_classification_fault_position_SV_percent = table
result_classification_fault_position_SV_percent.Case_ = vector_case_result_clssification_fault_position_SV_percent'
result_classification_fault_position_SV_percent.fault_position_SV_percent= vector_result_classification_fault_position_SV_percent'
result_classification_fault_position_SV_percent.Case_Table = vector_signal_result_classification_fault_position_SV_percent'

