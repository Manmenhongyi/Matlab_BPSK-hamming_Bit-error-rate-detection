clc
close all
clear 
% 信源产生
data = randi([0 1], 1, 10000); % 生成 10000 个随机二进制数据

% 使用 (7,4) 汉明码作为线性分组码
G = [1 0 0 0 1 1 0; 0 1 0 0 1 0 1; 0 0 1 0 0 1 1; 0 0 0 1 1 1 1];%生成矩阵 G 
H = [1 1 1; 1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1];%校验矩阵 H

% 信道编码
encoded_data = encode(data, 7, 4, 'hamming/binary'); % 使用(7,4)汉明码进行编码

%BPSK调制
bpsk_signal = pskmod(encoded_data,2,pi/4,'bin');%BPSK调制函数：输入信号，调制阶数，相位偏移，符号映射方式

SNR = 0:1:10; % 定义信噪比范围
BER = zeros(1, length(SNR)); % 初始化误码率数组

%信道传输/解调/译码过程
for i = 1:length(SNR)%从1循环到SNR数组长度值
    awgn_bpsk_signal = awgn(bpsk_signal, SNR(i), 'measured'); % 使用AWGN模拟传输高斯噪声
    new_encoded_data = pskdemod(awgn_bpsk_signal,2,pi/4,'bin'); % BPSK解调
    new_decoded_data = decode(new_encoded_data, 7, 4, 'hamming/binary'); % 信道译码
    [numErrors, BER(i)] = biterr(data, new_decoded_data); % 计算误码率
end

% 绘制 SNR 与 误码率 之间的关系图
figure;
semilogy(SNR, BER, 'b.-');
xlabel('信噪比 (SNR)');
ylabel('误码率 (BER)');
title('信噪比SNR 与 误码率BER 之间的关系');
grid on;