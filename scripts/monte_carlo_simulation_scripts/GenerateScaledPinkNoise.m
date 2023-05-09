function scaled_pink = generateScaledPinkNoise(BiasInstabilityTerm, num_samples)
    pn = dsp.ColoredNoise('pink',num_samples,3);
    unscaled_pink = pn();
    scaled_pink = BiasInstabilityTerm.*unscaled_pink;     
end 