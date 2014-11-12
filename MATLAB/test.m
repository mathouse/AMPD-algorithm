clear all
close all
clc

Data = load('../Datasets/SSN/monthssn.dat');

ssnSignal = Data(:,4);
ssnTime = Data(:,1);
ssnTime = num2str(ssnTime);
ssnTime = datenum(ssnTime,'yyyymm');

ssnInd = ampd(-ssnSignal);
ssnMax = ssnSignal(ssnInd);
ssnTim = ssnTime(ssnInd);

fig = figure(1);

set(fig, ...
    'Color', [1 1 1], ...
    'Position', [50 50 800 400])
axs = axes();

xLim = [min(ssnTime), max(ssnTime)];
yLim = [0 100*ceil(max(ssnSignal)/100)];

xTicks = linspace(min(ssnTime), max(ssnTime),6);
yTicks = 0:50:(100*ceil(max(ssnSignal)/100)+50);

xTicksLabel = datestr(xTicks, 'yyyy-mmm');
yTicksLabel = sprintf('%.2f|', yTicks);

set(axs, ...
    'NextPlot', 'Add', ...
    'Box', 'On')

set(axs, ...
    'XLim', xLim, ...
    'XTick', xTicks, ...
    'XGrid', 'On', ...
    'XTickLabel', xTicksLabel, ...
    'YLim', yLim, ...
    'YTick', yTicks, ...
    'YGrid', 'On', ...
    'YTickLabel', yTicksLabel)

set(get(axs,'XLabel'), ...
    'String', 'Date',...
    'FontSize', 12)

set(get(axs,'YLabel'), ...
    'String', 'Monthly SSN',...
    'FontSize', 12)

set(get(axs,'Title'), ...
    'String', 'Monthly SSN since 1749 to now',...
    'FontSize', 16)

plot(axs, ssnTime, ssnSignal, 'b-')
plot(axs, ssnTim, ssnMax, 'r*')