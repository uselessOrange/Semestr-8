function [S, F, T] = MYstft(x, fs, window, NoOverlap, NFFT)
    % Compute Short-Time Fourier Transform (STFT) of input signal x
    %
    %   [S, F, T] = MYstft(x, fs, window, NoOverlap, NFFT)
    %
    % Inputs:
    %   x: Input signal (1D row vector)
    %   fs: Sampling frequency of the input signal (in Hz)
    %   window: Analysis window used for STFT (1D column vector, e.g. Hamming window)
    %   NoOverlap: Percentage of overlap between consecutive windows (0 to 100)
    %   NFFT: Length of the FFT used for computing the STFT (integer, preferably power of 2)
    %
    % Outputs:
    %   S: Short-Time Fourier Transform (STFT) matrix, where each column represents
    %      the FFT of a windowed segment of the input signal (2D array of size NFFT-by-N)
    %   F: Frequency vector corresponding to the STFT matrix S (1D array of size NFFT)
    %   T: Time vector corresponding to the STFT matrix S (1D array of size N)
 
    % Length of the input signal
    L = length(x);
    
    % Length of the window
    wl = length(window);  
    
    % Compute hop size based on the overlap percentage
    hop = round(wl * (1 - NoOverlap/100));
    
    % Total number of time frames
    N = floor((L - wl) / hop) + 1;
    
    % Preallocate STFT matrix
    S = zeros(NFFT, N);
    
    % Main computing loop for STFT
    for i = 0:N-1
        % Starting index of current frame
        start_idx = 1 + i * hop;
        % Extract current frame from the input signal
        x_frame = x(start_idx : start_idx + wl - 1).'; % Transpose to column vector
        % Apply window to the frame
        x_windowed = x_frame .* window;
        % Compute FFT of the windowed frame
        fft_result = fft(x_windowed, NFFT);
        % Assign FFT result to the STFT matrix (X)
        S(:, i+1) = fft_result;
    end
    
    % Compute frequency vector
    F = (0:NFFT-1).' * fs / NFFT;
    
    % Compute time vector
    T = (0:N-1).' * hop / fs;
end
