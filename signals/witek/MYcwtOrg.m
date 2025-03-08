function [timeFreqSpectrum, freqBins] = MYcwtOrg(signal, samplingFreq, waveletType)
% Input:
% signal: input signal (real vector)
% samplingFreq: sampling frequency in Hz

% Output:
% timeFreqSpectrum: time-frequency spectrum (complex matrix)
% freqBins: frequency bins (in Hz) of the spectrum

gammaParam = 3; % Morse gamma parameter
betaParam = 20; % Morse beta parameter
order = 0; % Order of Morse wavelet
smallestScale = []; % Smallest scale
numOctaves = []; % Number of octaves
voicesPerOctave = 10; % Number of voices per octave

signal = signal(:); % Ensure column vector
signal = signal(end:-1:1); % Reverse order
signal = detrend(signal, 0); % Remove linear trend
originalLength = numel(signal); % Number of elements

% Padding the signal
paddingLength = floor(originalLength / 2);
signal = [conj(signal(paddingLength:-1:1)); signal; conj(signal(end:-1:end-paddingLength+1))];
totalLength = numel(signal);

[scales, ~, numOctaves] = CalculateScales(waveletType, originalLength, smallestScale, numOctaves, voicesPerOctave, gammaParam, betaParam);

% Frequency vector for Fourier transform of the wavelet
omega = (2 * pi / totalLength) * (1:fix(totalLength / 2));
omega = [0, omega, -omega(fix((totalLength - 1) / 2):-1:1)].';
angularFreq = omega;

% Wavelet transform
if strcmp(waveletType, 'morse')
    centerFreq = log(2)^(1 / gammaParam); % Center frequency in radians/sec
    waveletTransform = morse(scales, angularFreq, centerFreq, gammaParam, betaParam, order);
    freqBins = centerFreq ./ (2 * pi * scales);
    waveletSigma = CalculateMorseSigma(gammaParam, betaParam);
    coiFactor = 2 * pi / (waveletSigma * centerFreq);
elseif strcmp(waveletType, 'morlet')
    centerFreq = 6;
    waveletTransform = morlet(scales, angularFreq, centerFreq);
    freqBins = centerFreq ./ (2 * pi * scales);
    waveletSigma = 1 / sqrt(2);
    coiFactor = 2 * pi / (waveletSigma * centerFreq);
end

% FFT of the input
signalFFT = fft(signal);
timeFreqSpectrum = ifft((signalFFT * ones(1, size(waveletTransform, 2))) .* waveletTransform);
timeFreqSpectrum = timeFreqSpectrum(1+paddingLength:originalLength+paddingLength, :).';
freqBins = samplingFreq * freqBins.';

% Cone of Influence (COI)
if mod(originalLength, 2) == 1 % Odd length
    coiIndices = 1:ceil(originalLength / 2); 
    coiIndices = [coiIndices, fliplr(coiIndices(1:end-1))];
else 
    coiIndices = 1:originalLength / 2;
    coiIndices = [coiIndices, fliplr(coiIndices)];
end
coi = (coiFactor * coiIndices).';

% Plot spectrum if no output arguments
if nargout < 1
    time = linspace(0, (size(timeFreqSpectrum, 2) - 1) / samplingFreq, size(timeFreqSpectrum, 2));
    PlotSpectrumOrg(time, freqBins, timeFreqSpectrum, coi);
end
end

function [scales, smallestScale, numOctaves] = CalculateScales(waveletType, signalLength, smallestScale, numOctaves, voicesPerOctave, gammaParam, betaParam)
    if strcmp(waveletType, 'morse')
        if isempty(smallestScale)
            a = 1;
            testOmegas = linspace(0, 12 * pi, 1001);
            omega = testOmegas(find(log(testOmegas .^ betaParam) + (-testOmegas .^ gammaParam) - log(a / 2) + (betaParam / gammaParam) * (1 + (log(gammaParam) - log(betaParam))) > 0, 1, 'last'));
            smallestScale = min(2, omega / pi);
        end
        waveletSigma = CalculateMorseSigma(gammaParam, betaParam);
    elseif strcmp(waveletType, 'morlet')
        if isempty(smallestScale)
            a = 0.1; omega0 = 6;
            omega = sqrt(-2 * log(a)) + omega0;
            smallestScale = min(2, omega / pi);
        end
        waveletSigma = sqrt(2) / 2;
    end
    
    maxScale = floor(signalLength / (2 * waveletSigma * smallestScale));
    if maxScale <= 1
        maxScale = floor(signalLength / 2);
    end
    maxScale = floor(voicesPerOctave * log2(maxScale));
    
    if ~isempty(numOctaves)
        maxScale = min(voicesPerOctave * numOctaves, maxScale);
    else
        numOctaves = maxScale / voicesPerOctave;
    end
    
    octaves = (1 / voicesPerOctave) * (0:maxScale);
    scales = smallestScale * 2 .^ octaves;
end

function [waveletSigma] = CalculateMorseSigma(gammaParam, betaParam)
c1 = (2 / gammaParam) * log(2 * betaParam / gammaParam) + 2 * log(betaParam) + gammaln((2 * (betaParam - 1) + 1) / gammaParam) - gammaln((2 * betaParam + 1) / gammaParam);
c2 = ((2 - 2 * gammaParam) / gammaParam) * log(2) + (2 / gammaParam) * log(betaParam / gammaParam) + 2 * log(gammaParam) + gammaln((2 * (betaParam - 1 + gammaParam) + 1) / gammaParam) - gammaln((2 * betaParam + 1) / gammaParam);
c3 = ((2 - gammaParam) / gammaParam) * log(2) + (1 + 2 / gammaParam) * log(betaParam) + (1 - 2 / gammaParam) * log(gammaParam) + log(2) + gammaln((2 * (betaParam - 1 + gammaParam / 2) + 1) / gammaParam) - gammaln((2 * betaParam + 1) / gammaParam);
waveletSigma = real(sqrt(exp(c1) + exp(c2) - exp(c3)));
end