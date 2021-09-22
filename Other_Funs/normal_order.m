%% ͻȻ�䷢����ʵ����Ҫ��һ�εģ�С�����˸����������ݴ���ڶ�����������Excel����¼�������Ϣ
%�������ݱ���·������Ϣ���Ա�����ļ�����
%�ڼ�������
%��ģ�����ļ���
%MATLABʱ������ļ�
%CVɨ���ٶ�
%����·��
prompt = {'Reference number of Data in Exp group:',...
          'Enter the folder of Masks for the Data:',...
          'Enter the matlab file of Data timeline:',...
          'Enter the scan rate of cyclic voltammetry (mV):',...
          'Save route:'};

dlg_title = 'Input';
num_lines = 1;

defaultans = {'A1',...
              'F:\TaS2\20190324_TaS2_0318_ITO\MaskA1',...
              'G:\TaS2\20190318_TaS2_ITO\matlab_data\B2.mat',...
              '100',...
              'F:\TaS2\20190324_TaS2_0318_ITO\result'};

answer = inputdlg(prompt, dlg_title, num_lines, defaultans);
expName = answer{1};
maskPath = answer{2};
loader = answer{3};
rate = str2num(answer{4});
saveRoute = answer{5};
 
% if DC
% TaS2_DC(expName, tifPath, maskPath, saveRoute);
% if CV
TaS2(expName, maskPath, loader, rate, saveRoute);
%% ��ȡ�ӵ�ʱ��
%����һ���ṹ�壬������frame���־�˼ӵ�ʱ�̶�Ӧ֡��
varMat = load('G:\TaS2\TaS2_1008_ITO\_Timer\B3_data.mat');
Fs = expTab(8).sampleRate;
begin = triggerTime(varMat.data, varMat.t, Fs);
% Fs_SPR = 50; Fs_BF = 40;
% begin = triggerTime_2Cam(varMat.data, varMat.t, Fs_SPR, Fs_BF);
% begin = triggerTime_DC(varMat.data);
expTab(8).begin = begin;
%% 20190501_TaS2_ITO
load('G:\TaS2\TaS2_1008_ITO\_Result\expTab.mat')

hwait = waitbar(0, 'Please wait for the test >>>>>>>>');
for m = 1:size(expTab, 1)
% for m = [3 4]
    expName = expTab(m).expName;
    tifPath = expTab(m).tifPath;
    Mask = expTab(m).Mask;
    begin = expTab(m).begin; 
    saveRoute = expTab(m).saveRoute;
    rate = expTab(m).ScanRate;
    zone  = expTab(m).zone;
    Fs = expTab(m).sampleRate;
    
    TaS2_batch(expName, tifPath, Mask, begin, rate, saveRoute, zone, Fs);
    
    disp(['The latest progress is about ' num2str(m) '.']);
    processBar(size(expTab, 1), m, hwait)
    
end
delete(hwait);
%% 20190506_TaS2_ITO
% ��ǰ�������ת�浽expTab�ṹ����
prefix = ('G:\TaS2\TaS2_1008_ITO\_Result\mat_1\');
d = sortObj(dir([prefix, '*.mat']));
for ii = 1:size(expTab, 1)
% for ii = [3 4]
    load([prefix, d(ii).name]);
%     m = length(Value.validDir);
%     expTab(ii).line = (0:(-0.8/m):-0.8)';
%     expTab(ii).dIntensity = Value.outside(:, 1:2);
%     expTab(ii).potential = Value.potential;
    expTab(ii).ROImean = Value.ROImean;
    expTab(ii).dROImean = Value.dROImean;
    
    expTab(ii).cycle = (0:2/(length(Value.dROImean)):2)';
    expTab(ii).timeline = (1:length(Value.ROImean))';
end

























