function [potential,seg_length] = w_potentialLine(scanrate,samplerate,cycle_num,highpotential,lowpotential)

% �����������õ����Ƶ��źţ��õ��ĵ��Ʒֶηŵ�һ��������У�����CHI�����ĵ�������һ��
% ����CHI��ͬ���ǣ����ｫpotential�����г�һ������һά���󣬶����Ƿֶεģ�д����Ĺ����з��֣��ֶ��Ǻ��鷳���Ҳ���Ҫ��
% ���е�n��ʾ���������ɨһȦ��ô�������Σ����ɨ��Ȧ����ô����4�Σ��Դ�����

    scanrate = scanrate/1000;
    scanrate = scanrate/samplerate;     % ������ɨ����ٶ�ת���ɵ�λΪV/֡���ٶȣ�
                                        % Ŀ����Ϊ�˽����Ƶ�������ͼ��֡��������ֱ�Ӷ�ӳ����
                                        
    potential_fall = highpotential:-scanrate:(lowpotential+scanrate);
    potential_rise = lowpotential:scanrate:(highpotential-scanrate);
    
    seg_length = length(potential_fall);
    potential = zeros(1,(cycle_num*seg_length*2+1));
    
    for ii = 1:cycle_num*2
        
        if mod(ii,2) ==0
            
            potential(1+(ii-1)*seg_length:ii*seg_length) = potential_rise;
            
        else
            
            potential(1+(ii-1)*seg_length:ii*seg_length) = potential_fall;
            
        end
        
    end
    
    potential(end) = 0;

%     potential3 = highpotential:-scanrate:lowpotential;
%     potential4 = (lowpotential+scanrate):scanrate:highpotential;
%     potential4 = (lowpotential+scanrate):scanrate:(highpotential-scanrate);
%     potential5 = highpotential:-scanrate:lowpotential;
%     potential6 = (lowpotential+scanrate):scanrate:highpotential;
%     potential = [potential1 potential potential3 potential4 potential5 potential6];

end