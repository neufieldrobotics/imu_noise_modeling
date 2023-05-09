
% Pink noise model : finding out 

y = pinknoise(2^16,1000);   % Generate 1000 channels of pink noise
Y = fft(y);          % Compute the FFT of each channel of pink noise
      FS = 44100;          % Display assuming 44.1 kHz sample rate
      f = linspace(0,FS/2,size(y,1)/2);           % Frequency axis
      semilogx(f,db(mean(abs(Y(1:end/2,:)),2)))   % Plot the response
      axis([1 FS/2 0 45]), grid on                % Set axis and grid
      title('Pink Noise Spectral Density (Averaged)')
      xlabel('Frequency (Hz)')
      ylabel('Power (dB)')
