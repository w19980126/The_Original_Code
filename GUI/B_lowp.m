function y = B_lowp(x, f1, f3, rp, rs, Fs)

% ������˹��ͨ�˲���

fn = Fs/2;      %�ο�˹��Ƶ��
wp = f1/fn;     %ͨ����ֹƵ��
ws = f3/fn;     %�����ֹƵ��
[n,wn] = buttord(wp,ws,rp,rs,'s');   %�õ��б�ѩ���˲�������n�ͱ߽�Ƶ��Wn
[b,a] = butter(n,wn);                %�õ��������ݺ�������b�ͷ�ĸa
y = filter(b,a,x); %��ԭʼ���ݽ����˲�

end

