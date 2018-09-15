
%  1-D�ź�ѹ�����е�ʵ��(����ƥ��׷�ٷ�Orthogonal Matching Pursuit)
%  ������M>=K*log(N/K),K��ϡ���,N�źų���,���Խ�����ȫ�ع�
%  �����--��۴�ѧ���ӹ���ϵ ɳ��  Email: wsha@eee.hku.hk
%  ���ʱ�䣺2008��11��18��
%  �ĵ�����: http://www.eee.hku.hk/~wsha/Freecode/freecode.htm 
%  �ο����ף�Joel A. Tropp and Anna C. Gilbert 
%  Signal Recovery From Random Measurements Via Orthogonal Matching
%  Pursuit��IEEE TRANSACTIONS ON INFORMATION THEORY, VOL. 53, NO. 12,
%  DECEMBER 2007.
 
clc;clear
 
%%  1. ʱ������ź�����
K=10;      %  ϡ���(��FFT���Կ�����)
N=2560;    %  �źų���
M=64;     %  ������(M>=K*log(N/K),����40,���г���ĸ���)
f1=50;    %  �ź�Ƶ��1
f2=100;   %  �ź�Ƶ��2
f3=200;   %  �ź�Ƶ��3
f4=300;   %  �ź�Ƶ��4
fs=64000;   %  ����Ƶ��
ts=1/fs;  %  �������
Ts=1:N;   %  ��������
x=0.3*cos(2*pi*f1*Ts*ts)+0.6*cos(2*pi*f2*Ts*ts)+0.1*cos(2*pi*f3*Ts*ts)+0.9*cos(2*pi*f4*Ts*ts);  %  �����ź�,��4���źŵ��Ӷ���


% ����ͼ�� �Լ� �� Ƶ��ͼ
subplot(3,1,1);
plot(x);
subplot(3, 1, 2);
plot(abs(fft(x)));


s_T = randperm(N,M);                                %  �����������ʱ��� ����
samp_mat = eye(N);
Phi = samp_mat(s_T, :);                             %  ���ݲ���ʱ��� ���� �����������
s = x(s_T);                                         %  ���ݲ�������ģ�����
s = s';


%%  3.  ����ƥ��׷�ٷ��ع��ź�(��������L_1�������Ż�����)
%ƥ��׷�٣��ҵ�һ�����ǿ���ȥ���ռ�����������ص�С������������ȥ�������ǵ�����ӡ���������ظ�ֱ����������С����ǡ����͡��ռ������������ݡ�
 
m=2*K;                                            %  �㷨��������(m>=K)����x��K-sparse��
Psi=fft(eye(N,N))/sqrt(N);                        %  ����Ҷ���任����
T=Phi*Psi';                                       %  �ָ�����(��������*�������任����)
 
hat_y=zeros(1,N);                                 %  ���ع�������(�任��)����                     
Aug_t=[];                                         %  ��������(��ʼֵΪ�վ���)
r_n=s;                                            %  �в�ֵ
 
for times=1:m;                                    %  ��������(�������������,�õ�������ΪK)
    for col=1:N;                                  %  �ָ����������������
        product(col)=abs(T(:,col)'*r_n);          %  �ָ�������������Ͳв��ͶӰϵ��(�ڻ�ֵ) 
    end
    [val,pos]=max(product);                       %  ���ͶӰϵ����Ӧ��λ�ã����ҵ�һ�����ǿ���ȥ���ռ�����������ص�С��
    Aug_t=[Aug_t,T(:,pos)];                       %  ��������    
    
    T(:,pos)=zeros(M,1);                          %  ѡ�е������㣨ʵ����Ӧ��ȥ����Ϊ�˼��Ұ������㣩����������ȥ�������ǵ�����ӡ��
    aug_y=(Aug_t'*Aug_t)^(-1)*Aug_t'*s;           %  ��С����,ʹ�в���С
    r_n=s-Aug_t*aug_y;                            %  �в�
    pos_array(times)=pos;                         %  ��¼���ͶӰϵ����λ��
end
hat_y(pos_array)=aug_y;                           %  �ع�����������
hat_x=real(Psi'*hat_y.');                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�
 
%%  4.  �ָ��źź�ԭʼ�źŶԱ�
figure(1);
subplot(3,1,3);
hold on;
plot(hat_x,'k.-')                                 %  �ؽ��ź�
plot(x,'r')                                       %  ԭʼ�ź�
legend('Recovery','Original')
norm(hat_x.'-x)/norm(x)                           %  �ع����

