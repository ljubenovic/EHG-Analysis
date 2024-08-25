function beat = Pan_Tompkin_QRS(data, fs, alpha, N, fraction, plotting)

if nargin < 6
    plotting = true;
end

%  LP filter
B1 = zeros(13,1);
B1(1) = 1; B1(7) = -2; B1(13) = 1;
A1 = [1 -2 1];
x = filter(B1, A1, data);

%  Normalize the signal
n = floor(log(0.02) / log(alpha)+1);
x = x / max(x(n:end));

% HP filter
B2 = zeros(1,33);
B2(1) = -1/32; B2(17) = 1; B2(18) = -1; B2(33) = 1/32;
A2 = [1 -1];
x1 = filter(B2, A2, x);

% Frequency response of LP filter
[H1,Omega] = freqz(B1,A1);
% Frequency response of HP filter
[H2,Omega] = freqz(B2,A2);
% Frequency response of BP filter
H_bp = H1.*H2;

Fr = 0.5 * fs* Omega / pi;

if plotting
    figure(position = [50,100,1000,200])
        plot(Fr,abs(H_bp))
        title('BP filtar - amplitudska karakteristika')
        xlabel('frekvencija [Hz]'); ylabel('|H(e^(j\Omega))| [a.u.]')
        grid on; grid minor
end

% Differentiation
y = zeros(1,100);
for n = 5:length(x1)
    y(n) = (2*x1(n) + x1(n-1) - x1(n-3) - 2*x1(n-4))/8;
end

% Squaring the result
y = y.^2;

%  Integration (MA filtering)
order = N;
aM = [1 zeros(1,order-1)];
bM = ones(1,order)/order;

yi = filtfilt(bM,aM,y);

% Simple threshold method
blanking = 40;
threshold = fraction * max(yi);
[~, beat] = findpeaks(yi,'MinPeakHeight',threshold,'MinPeakDistance',blanking);

% Undoing the delays in the filters
delay = 5 + 16 + 2; % lp + hp + diff
beat_original = beat - delay;

% Plotting the results
time_x = (0:length(x)-1)/fs;

if plotting
    figure(position = [50,100,1000,800])
    orient landscape
        subplot(4,1,1)
        plot(time_x,x)
        grid on; grid minor   
        xlabel('t [s]'); ylabel('amplituda [a.u.]');
        title('Signal nakon LP filtriranja');
        xlim([0 10])
    
        subplot(4,1,2)
        plot(time_x,x1)
        grid on; grid minor   
        xlabel('t [s]'); ylabel('amplituda [a.u.]');
        title('Signal nakon HP filtriranja');
        xlim([0 10])
    
        subplot(4,1,3)
        plot(time_x,y)
        grid on; grid minor 
        xlabel('t [s]'); ylabel('amplituda [a.u.]');
        title('Signal nakon diferenciranja i kvadriranja');
        xlim([0 10])
    
        subplot(4,1,4)
        hold all
        plot(time_x,yi,'-')
        plot(time_x,threshold*ones(1,length(yi)),'--','LineWidth',1.2)
        grid on; grid minor 
        xlabel('t [s]'); ylabel('amplituda [a.u.]');
        title('Signal nakon integracije');
        legend('feature signal','prag za detekciju R pikova','Location','northeast')
        xlim([0 10])
    
    figure(position = [50,100,1000,400])
    orient landscape
        subplot(2,1,1)
        hold all
        plot(time_x,yi,'-')
        plot(beat/fs,yi(beat),'s','LineWidth',1.2)
        grid on; grid minor;
        xlabel('t [s]'); ylabel('amplituda [a.u.]');
        title('Detektovani R pikovi na feature signalu')
        xlim([0 10])
    
        subplot(2,1,2)
        hold all
        plot(time_x,data,'-')
        plot(beat_original/fs,data(beat_original),'s','LineWidth',1.2)
        grid on; grid minor
        title('Detektovani R pikovi na izdvojenoj komponenti koja odgovara EKG signalu')
        xlabel('t [s]'); ylabel('amplituda [a.u.]');
        xlim([0 10])
end
