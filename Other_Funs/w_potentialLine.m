function [potential,seg_length] = w_potentialLine(scanrate,samplerate,cycle_num,highpotential,lowpotential)

% 本函数用来得到电势的信号，得到的电势分段放到一个大矩阵中，就像CHI导出的电势数据一样
% 但与CHI不同的是，这里将potential数据列成一个长的一维矩阵，而不是分段的，写代码的过程中发现，分段是很麻烦而且不必要的
% 其中的n表示段数，如果扫一圈那么就是两段，如果扫两圈，那么就是4段，以此类推

    scanrate = scanrate/1000;
    scanrate = scanrate/samplerate;     % 将电势扫面的速度转换成单位为V/帧的速度，
                                        % 目的是为了将电势的数据与图像帧数的数据直接对映起来
                                        
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