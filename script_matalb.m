% 1. Determine normal or abnormal  (normal_abnormal) 
% #### 0 = normal    1 = abnormal
% 2. Determine anomaly, fault, or unknown fault (anomaly_fault)
% #### 1 = unknow condtion   2 = anomaly   3 = fault
% 3. Determine anomaly position BV1, and BP1 to BP7 (anomaly_position_BP_BV)
% #### 1 = BP1  2 = BP2  3 = BP3 4 = BP4  5 = BPV5 6 = BP6  7 = BP7 8 = BV1
% 4. Determine fault position in SV1-4 (fault_position_SV)
% #### 1 = SV1  2 = SV2 3 = SV3 4 = SV4
% 5. Determine percent on fault SV1-4 0% <= Opening ration < 100% (fault_position_SV_percent)

% import file xlsx delle labels
table_labels_train = readtable('dataset/train/labels.xlsx');
table_labels_test = readtable('dataset/submission.csv');

% importare i files csv
file_train = dir(fullfile('dataset/train/data/', '*.csv'));
file_test = dir(fullfile('dataset/test/data/', '*.csv'));

% [1.1] creazione tabelle per dati training
for k = 1:numel(file_train)
    F = fullfile(file_train(k).folder, file_train(k).name);
    Train{k} = readtable(F);
end

% [1.2] creazione tabelle per dati di testing
for k = 1:numel(file_test)
    T = fullfile(file_test(k).folder, file_test(k).name);
    Test{k} = readtable(T);
end

% aggiunge colonna time_tables alla tabella labels
table_labels_train.Case_Table = Train';
table_labels_test.Case_Table = Test';

%% correzzioni tabella table_labels_train
[r_1,c_1] = size(table_labels_train);

% creazione colonna "normal_abnormal"
% - con fault code 'Normal' => 0
% - con fault code 'Fault' o 'Anomaly' => 1

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

% aggiungi colonna normal_abnormal  in labels test
table_labels_train.normal_abnormal = vector_normal_abnormal_train';

% creazione colonna "anomaly_fault"
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

table_labels_train.anomaly_fault = vector_anomaly_fault_train'

% creazione colonna "anomaly_position_BP_BV"
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

 table_labels_train.anomaly_position_BP_BV = vector_anomaly_position_BP_BV_train'

 % creazione colonna "fault_position_SV"
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

table_labels_train.fault_position_SV = vector_fault_position_SV_train'

% creazione colonna "fault_position_SV_percent"
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

table_labels_train.fault_position_SV_percent = vector_fault_position_SV_percent_train'

%% tabelle finali per train
table_labels_train_normal_abnormal = table_labels_train(:, [1, 17, 16])

table_labels_train_anomaly_fault = table_labels_train(:, [1, 18, 16])
table_labels_train_anomaly_fault =  table_labels_train_anomaly_fault((table_labels_train_anomaly_fault.anomaly_fault) ~= 0, :)

table_labels_train_anomaly_position_BP_BV = table_labels_train(:, [1, 19, 16])
table_labels_train_anomaly_position_BP_BV =  table_labels_train_anomaly_position_BP_BV((table_labels_train_anomaly_position_BP_BV.anomaly_position_BP_BV) ~= 0, :)

table_labels_train_fault_position_SV = table_labels_train(:, [1, 20, 16])
table_labels_train_fault_position_SV =  table_labels_train_fault_position_SV((table_labels_train_fault_position_SV.fault_position_SV) ~= 0, :)

table_labels_train_fault_position_SV_percent = table_labels_train(:, [1, 21, 16])
table_labels_train_fault_position_SV_percent =  table_labels_train_fault_position_SV_percent((table_labels_train_fault_position_SV_percent.fault_position_SV_percent) ~= 100, :)

%% correzione table_labels_test, considerando:
% - abbiamo solo situazioni di fault e anomaly
% - le percentuali sulla aperture degli ugelli delle valvole devono essere: 0, 25, 50, 75, 100 
table_labels_test = table_labels_test(table_labels_test.task2 ~= 1, :)

% creazione colonna "normal_abnormal"
table_labels_test = renamevars(table_labels_test,"task1","normal_abnormal")

% creazione colonna "anomaly_fault"
table_labels_test = renamevars(table_labels_test,"task2","anomaly_fault")

% creazione colonna "anomaly_position_BP_BV"
table_labels_test = renamevars(table_labels_test,"task3","anomaly_position_BP_BV")

% creazione colonna "fault_position_SV"
table_labels_test = renamevars(table_labels_test,"task4","fault_position_SV")

% creazione colonna "fault_position_SV_percent"
table_labels_test = renamevars(table_labels_test,"task5","fault_position_SV_percent")

%% tabelle finali per test
table_labels_test_normal_abnormal = table_labels_test(:, [1, 2, 7])
table_labels_test_normal_abnormal = renamevars(table_labels_test_normal_abnormal,["id"],["Var1"])

table_labels_test_anomaly_fault = table_labels_test(:, [1, 3, 7])
table_labels_test_anomaly_fault =  table_labels_test_anomaly_fault((table_labels_test_anomaly_fault.anomaly_fault) ~= 0, :)
table_labels_test_anomaly_fault = renamevars(table_labels_test_anomaly_fault,["id"],["Var1"])

table_labels_test_anomaly_position_BP_BV = table_labels_test(:, [1, 4, 7])
table_labels_test_anomaly_position_BP_BV =  table_labels_test_anomaly_position_BP_BV((table_labels_test_anomaly_position_BP_BV.anomaly_position_BP_BV) ~= 0, :)
table_labels_test_anomaly_position_BP_BV = renamevars(table_labels_test_anomaly_position_BP_BV,["id"],["Var1"])

table_labels_test_fault_position_SV = table_labels_test(:, [1, 5, 7])
table_labels_test_fault_position_SV =  table_labels_test_fault_position_SV((table_labels_test_fault_position_SV.fault_position_SV) ~= 0, :)
table_labels_test_fault_position_SV = renamevars(table_labels_test_fault_position_SV,["id"],["Var1"])

table_labels_test_fault_position_SV_percent = table_labels_test(:, [1, 6, 7])
table_labels_test_fault_position_SV_percent =  table_labels_test_fault_position_SV_percent((table_labels_test_fault_position_SV_percent.fault_position_SV_percent) ~= 100, :)
table_labels_test_fault_position_SV_percent = renamevars(table_labels_test_fault_position_SV_percent,["id"],["Var1"])

%% commentati
%[1.3] classificazione normal o abnormal
% load("features_data_normal_abnormal.mat")
% load("KernelNaiveBayes_model_normal_abnormal.mat")
% 
% [label_data_class_normal_abnormal,scores_data_class_normal_abnormal] = KernelNaiveBayes_model_normal_abnormal.predictFcn(features_data_normal_abnormal)
% 
% % [2.1] costruzione tabelle per estrarre features fault e anomaly
% z = 1
% for j=1:46
%     vector_normal_abnormal_summ_row{j}= label_data_class_normal_abnormal(z) + label_data_class_normal_abnormal(z + 1) + label_data_class_normal_abnormal(z + 2) + label_data_class_normal_abnormal(z + 3) + label_data_class_normal_abnormal(z + 4);
%     z = z + 5
% end 
% 
% vector_summ_normal_abnormal = vector_normal_abnormal_summ_row';
% 
% table_labels_data.sum_normal_abnormal = vector_summ_normal_abnormal;
% 
% table_labels_fault_anomaly_data =  table_labels_data(cell2mat(table_labels_data.sum_normal_abnormal) > 2, :)
% 
% % [2.2] costruzione dataset train per la distizioni di situazioni di Fault o Anomaly
% table_labels_fault_anomaly_train =  table_labels_train(table_labels_train.Var3 ~= string('Normal'), :)
% 
% % [2.3] classificazione fault o anomaly
% load("KernelNativeBayes_model_fault_anomaly.mat")
% load("features_data_fault_anomaly")
% 
% [label_data_class_fault_anomaly,scores_data_class_fault_anomaly] = KernelNativeBayes_model_fault_anomaly.predictFcn(features_data_fault_anomaly)
% 
% % [2.4] raggruppamento per ogni "member" su fault o anomaly
% 
% % - Fault -> 0
% % - Anomaly -> 1
% for x = 1:numel(label_data_class_fault_anomaly)
%     switch label_data_class_fault_anomaly{x}
%         case 'Fault'
%             vector_data_class_fault_anomaly_row{x} = 0
%         case 'Anomaly'
%             vector_data_class_fault_anomaly_row{x} = 1
%         otherwise
%             vector_data_class_fault_anomaly_row{x} = 1
%     end
% end
% 
% vector_data_class_fault_anomaly = cell2mat(vector_data_class_fault_anomaly_row');
% 
% [r_1,c_1] = size(vector_data_class_fault_anomaly)
% 
% z = 1
% for j=1:(r_1/5)
%     vector_fault_anomaly_summ_row{j}= vector_data_class_fault_anomaly(z) + vector_data_class_fault_anomaly(z + 1) + vector_data_class_fault_anomaly(z + 2) + vector_data_class_fault_anomaly(z + 3) + vector_data_class_fault_anomaly(z + 4);
%     z = z + 5
% end 
% 
% vector_fault_anomaly_summ = vector_fault_anomaly_summ_row'
% 
% table_labels_fault_anomaly_data.fault_anomaly = vector_fault_anomaly_summ
% 
% table_labels_fault_data =  table_labels_fault_anomaly_data(cell2mat(table_labels_fault_anomaly_data.fault_anomaly) < 3, :)
% 
% table_labels_anomaly_data =  table_labels_fault_anomaly_data(cell2mat(table_labels_fault_anomaly_data.fault_anomaly) > 2, :)
% 
% % [3.1] train set per determinare posizione bolle in tubature per 'anomaly'
% table_labels_anomaly_BP_train =  table_labels_train(table_labels_train.Var3 == string('Anomaly'), :)
% 
% [r_2,c_2] = size(table_labels_anomaly_BP_train);
% 
% for x = 1:r_2
%     switch table_labels_anomaly_BP_train.BV1{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BV1'
%     end
% 
%      switch table_labels_anomaly_BP_train.BP1{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP1'
%      end
% 
%      switch table_labels_anomaly_BP_train.BP2{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP2'
%      end
% 
%     switch table_labels_anomaly_BP_train.BP3{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP3'
%     end
% 
%     switch table_labels_anomaly_BP_train.BP4{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP4'
%     end
% 
%     switch table_labels_anomaly_BP_train.BP5{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP5'
%     end
% 
%     switch table_labels_anomaly_BP_train.BP6{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP6'
%     end
% 
%     switch table_labels_anomaly_BP_train.BP7{x}
%         case 'Yes'
%             vector_anomaly_BP_row{x} = 'BP7'
%     end
% end
% 
% vector_anomaly_BP_train = vector_anomaly_BP_row';
% 
% table_labels_anomaly_BP_train.Position_B = vector_anomaly_BP_train;
% 
% % [3.2] classificazione delle anomaly, per distinguere le posizioni delle
% % bolle 
% load("KernelNaiveBayve_model_anomaly_BP_position.mat")
% load("features_data_anomaly_BP.mat")
% 
% [label_data_class_anomaly_BP,scores_data_class_anomaly_BP] = KernelNaiveBayve_model_anomaly_BP_position.predictFcn(features_data_anomaly_BP)
% 
% for x = 1:numel(label_data_class_anomaly_BP)/5
%     BP_BV_position_row{x} = label_data_class_anomaly_BP{5*x}
% end 
% 
% BP_BV_position = BP_BV_position_row'
% 
% table_labels_anomaly_data.BP_BV_position = BP_BV_position
% 
% % [4.1] train set per determinare valvole non funzionanti in 'fault'
% table_labels_fault_SV_train =  table_labels_train(table_labels_train.Var3 == string('Fault'), :)
% 
% [r_3,c_3] = size(table_labels_fault_SV_train)
% 
% for x = 1:r_3
%     switch table_labels_fault_SV_train.SV1(x)
%         case 0 
%             vector_fault_SV_row{x} = 'SV1'
%             vector_fault_SV_percent_row{x} = '0'
%     end
%     switch table_labels_fault_SV_train.SV2(x)
%         case 0 
%             vector_fault_SV_row{x} = 'SV2'
%              vector_fault_SV_percent_row{x} = '0'
%     end
%     switch table_labels_fault_SV_train.SV3(x)
%         case 0 
%             vector_fault_SV_row{x} = 'SV3'
%              vector_fault_SV_percent_row{x} = '0'
%     end
%     switch table_labels_fault_SV_train.SV4(x)
%         case 0 
%             vector_fault_SV_row{x} = 'SV4'
%              vector_fault_SV_percent_row{x} = '0'
%     end
% 
%     switch table_labels_fault_SV_train.SV1(x)
%         case 25 
%             vector_fault_SV_row{x} = 'SV1'
%             vector_fault_SV_percent_row{x} = '25'
%     end
%     switch table_labels_fault_SV_train.SV2(x)
%         case 25
%             vector_fault_SV_row{x} = 'SV2'
%              vector_fault_SV_percent_row{x} = '25'
%     end
%     switch table_labels_fault_SV_train.SV3(x)
%         case 25
%             vector_fault_SV_row{x} = 'SV3'
%              vector_fault_SV_percent_row{x} = '25'
%     end
%     switch table_labels_fault_SV_train.SV4(x)
%         case 25
%             vector_fault_SV_row{x} = 'SV4'
%              vector_fault_SV_percent_row{x} = '25'
%     end    
% 
%     switch table_labels_fault_SV_train.SV1(x)
%         case 50 
%             vector_fault_SV_row{x} = 'SV1'
%             vector_fault_SV_percent_row{x} = '50'
%     end
%     switch table_labels_fault_SV_train.SV2(x)
%         case 50 
%             vector_fault_SV_row{x} = 'SV2'
%              vector_fault_SV_percent_row{x} = '50'
%     end
%     switch table_labels_fault_SV_train.SV3(x)
%         case 50 
%             vector_fault_SV_row{x} = 'SV3'
%              vector_fault_SV_percent_row{x} = '50'
%     end
%     switch table_labels_fault_SV_train.SV4(x)
%         case 50 
%             vector_fault_SV_row{x} = 'SV4'
%              vector_fault_SV_percent_row{x} = '50'
%     end    
% 
%     switch table_labels_fault_SV_train.SV1(x)
%         case 75
%             vector_fault_SV_row{x} = 'SV1'
%             vector_fault_SV_percent_row{x} = '75'
%     end
%     switch table_labels_fault_SV_train.SV2(x)
%         case 75
%             vector_fault_SV_row{x} = 'SV2'
%              vector_fault_SV_percent_row{x} = '75'
%     end
%     switch table_labels_fault_SV_train.SV3(x)
%         case 75
%             vector_fault_SV_row{x} = 'SV3'
%              vector_fault_SV_percent_row{x} = '75'
%     end
%     switch table_labels_fault_SV_train.SV4(x)
%         case 75
%             vector_fault_SV_row{x} = 'SV4'
%              vector_fault_SV_percent_row{x} = '75'
%     end    
% end
% 
% vector_fault_SV = vector_fault_SV_row'
% vector_fault_SV_percent = vector_fault_SV_percent_row'
% 
% table_labels_fault_SV_train.fault_SV = vector_fault_SV
% table_labels_fault_SV_train.fault_SV_percent = vector_fault_SV_percent
% 
% % [4.2] classificazione dei fault, distinguere valvola non funzionante 
% load("KernelNaiveBayes_model_SV_position.mat")
% load("features_data_SV_position_percent.mat")
% 
% [label_data_class_fault_SV,scores_data_class_fault_SV] = KernelNaiveBayes_model_SV_position.predictFcn(features_data_SV_position_percent)
% % partendo dalla classificaizone [4.2] etichettiamo le istanze in "table_labels_fault_data" 
% 
% [r_4,c_4] = size(table_labels_fault_data)
% 
% for i = 1:r_4         
%     count_sv1 = 0
%     count_sv2 = 0
%     count_sv3 = 0
%     count_sv4 = 0
% 
%     for j = 1:5 
%         switch label_data_class_fault_SV{j + (i-1)*5}
%             case 'SV1' 
%                 count_sv1 = count_sv1 + 1
%             case 'SV2' 
%                 count_sv2 = count_sv2 + 1
%             case 'SV3' 
%                 count_sv2 = count_sv3 + 1
%             case 'SV4'
%                 count_sv4 = count_sv4 + 1
%         end
%     end         
%         vector = [count_sv1, count_sv2,count_sv3, count_sv4]
%         vector_2 = ["SV1", "SV2", "SV3","SV4"]
%         [m, index_max] = max(vector)
%         row_fault_SV_position{i} = vector_2(index_max)
% end 
% 
% % aggiunta delle corrispondenti posizioni delle valvole mal funzionanti
% vector_fault_SV_position = row_fault_SV_position'
% table_labels_fault_data.fault_SV_position = vector_fault_SV_position
% 
% % [4.3] determinare la percentuale di apertura per le valvole
% % malfunzionanti
% load('KernelNaiveBayes_model_SV_percent.mat')
% load('features_data_SV_position_percent.mat')
% 
% [label_data_class_fault_SV_percent,scores_data_class_fault_SV_percent] = KernelNaiveBayes_model_SV_percent.predictFcn(features_data_SV_position_percent)
% 
% for  i = 1:r_4         
%     count_0 = 0
%     count_25 = 0
%     count_50 = 0
%     count_75 = 0
% 
%     for j = 1:5
%          switch label_data_class_fault_SV_percent{j + (i-1)*5}
%              case '0' 
%                 count_0 = count_0 + 1
%             case '25' 
%                 count_25 = count_25 + 1
%             case '50' 
%                 count_50 = count_50 + 1
%             case '75'
%                 count_75 = count_75 + 1
%         end
%     end 
%         vector_percent = [count_0, count_25,count_50, count_75]
%         vector_percent_2 = ["0", "25", "50","75"]
%         [m_percent, index_max_percent] = max(vector_percent)
%         row_fault_SV_percent{i} = vector_percent_2(index_max_percent)
% end