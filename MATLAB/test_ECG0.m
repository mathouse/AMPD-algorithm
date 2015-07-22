clear all
close all
clc

fileDirectory = '../Datasets/ECG';
fileName = 'r01_edfm';
filePath = fullfile(fileDirectory, fileName);
fileInfo = strcat(filePath, '.info');
fileMat = strcat(filePath, '.mat');

ECGSignal = load(fileMat);
ECGSignal = ECGSignal.val;

fid = fopen(fileInfo, 'rt');

fgetl(fid);
fgetl(fid);
fgetl(fid);

[freqint] = sscanf(fgetl(fid), 'Sampling frequency: %f Hz  Sampling interval: %f sec');

interval = freqint(2);

fgetl(fid);

row = zeros(size(ECGSignal, 1),1);
signal = cell(size(ECGSignal, 1),1);
gain = zeros(size(ECGSignal, 1),1);
base = zeros(size(ECGSignal, 1),1);
units = cell(size(ECGSignal, 1),1);

for i = 1:size(ECGSignal, 1)
    scanned = textscan(fgetl(fid),'%d\t%s\t%f\t%f\t%s');
    
    row(i) = scanned{1};
    signal(i) = scanned{2};
    gain(i) = scanned{3};
    base(i) = scanned{4};
    units(i) = scanned{5};
end

fclose(fid);

ECGSignal(ECGSignal==-32768) = NaN;

ECGSignal = (ECGSignal(1:6000)-base)/gain;
ECGSignal = ECGSignal - mean(ECGSignal);

for i = 1:size(ECGSignal, 1)
    ECGSignal(i, :) = (ECGSignal(i, :) - base(i)) / gain(i);
end

x = (1:size(ECGSignal, 2)) * interval;
plot(x', ECGSignal');

hold on;

% Indx = ampd(ECGSignal);
[ ~ , Indx ] = ampd(ECGSignal, 'ecg');
ECGPeaks = ECGSignal(Indx);
ECGTimes = x(Indx);

plot(ECGTimes, ECGPeaks, 'r*');

labels = cell(size(signal));

for i = 1:length(signal)
    labels{i} = strcat(signal{i}, ' (', units{i}, ')'); 
end

legend(labels);
xlabel('Time (sec)');
grid on