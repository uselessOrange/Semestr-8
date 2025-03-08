function plotspectrum(ax, t, f, y, coi)
%-INPUT--------------------------------------------------------------------
% ax: Axes handle where the spectrum will be plotted
% t: time (in seconds) of the spectrum and original signal
% f: frequency bins (in Hz) of the spectrum
% y: output time-frequency spectrum (complex matrix)
%-OUTPUT-------------------------------------------------------------------
% none: plots the time-frequency spectrum on the specified axes

[t, coiweightt, ut] = engunits(t, 'unicode', 'time');
xlbl = ['Time (', ut, ')'];
[f, coiweightf, uf] = engunits(f, 'unicode');
ylbl = ['Frequency (', uf, 'Hz)'];
coi = (coi * mean(diff(t))) ./ (coiweightt * coiweightf);
invcoi = 1 ./ coi;
invcoi(invcoi > max(f)) = max(f);

imagesc(ax, t, log2(f), abs(y));
cmap = jet(1000); 
cmap = cmap([round(linspace(1, 375, 250)), 376:875], :); % Adjust colormap
colormap(ax, cmap);
logyticks = round(log2(min(f))):round(log2(max(f)));
ax.YLim = log2([min(f), max(f)]);
ax.YTick = logyticks;
ax.YDir = 'normal';
set(ax, 'YLim', log2([min(f), max(f)]), ...
    'layer', 'top', ...
    'YTick', logyticks(:), ...
    'YTickLabel', num2str(sprintf('%g\n', 2.^logyticks)), ...
    'layer', 'top')
title(ax, 'Magnitude Scalogram');
xlabel(ax, xlbl);
ylabel(ax, ylbl);
hcol = colorbar(ax);
hcol.Label.String = 'Magnitude';
hold(ax, 'on');
% Shade out complement of coi
plot(ax, t, log2(invcoi), 'w--', 'linewidth', 2);
A1 = area(ax, t, log2(invcoi), min([min(ax.YLim) min(invcoi)]));
A1.EdgeColor = 'none';
A1.FaceColor = [0.5 0.5 0.5];
alpha(A1, 0.8);
hold(ax, 'off');
end
