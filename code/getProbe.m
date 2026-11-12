function Probe = getProbe(param_acq)
% get the probe and transmit constants needed for beamforming
% for the probe whose name is contained in param_acq.transducer
% supports "L22-14v" and "GEL818iD"
%
% Probe.NelementsProbe     number of elements of the probe (whole array).
%                          The number of active elements used in an
%                          acquisition (Probe.Nelements, the field used by
%                          MUST) can be smaller: the example scripts set it
%                          to the number of channels recorded in the data
% Probe.pitch              element pitch (center-to-center), in m
% Probe.lensCorrection_wl  one-way lens delay (Verasonics Trans.lensCorrection),
%                          in wavelengths
% Probe.nCycles            number of cycles of the transmit waveform
% Probe.twPeak_wl          peak of the transmit waveform (Verasonics TW(1).peak),
%                          in wavelengths
%
% The transmit waveform is assumed to be a burst of nCycles cycles at the
% transmit frequency. Its peak is then the middle of the burst (nCycles/2
% periods of the transmit frequency, converted to wavelengths at the center
% frequency), delayed by the impulse response of the probe (irDelay_wl).
% irDelay_wl was obtained from the TW(1).peak values in the Verasonics 
%
% Read from sequence.json:
%   frequency_MHz    center frequency (Verasonics Trans.frequency)
%   txFrequency_MHz  transmit frequency. Not stored yet: if absent, the
%                    transmit is assumed to be at the center frequency
%   npulse           number of cycles of the transmit waveform
% Hot fix: in the L22-14v acquisitions of mice 1-38 and 60-61, npulse was
% stored in half-cycles (6 for a 3-cycle waveform), so npulse = 6 is read as
% 3 cycles, with a warning. All ULMShare acquisitions use a 3-cycle waveform.
probe_name = param_acq.transducer;

if strcmp(probe_name,"L22-14v") || strcmp(probe_name,"L22-14vX")
    % L22-14vX has the same Trans and TW values as L22-14v
    Probe.NelementsProbe = 128;
    Probe.pitch = 0.10*1e-3;
    Probe.lensCorrection_wl = 6.903016;
    irDelay_wl = 2.4375; % from verasonics
elseif strcmp(probe_name,"GEL818iD")
    Probe.NelementsProbe = 168;
    Probe.pitch = 0.15*1e-3;
    Probe.lensCorrection_wl = 4.816033;
    irDelay_wl = 1.375009; %  from verasonics
else
    error('unknown probe')
end

fc_MHz = str2double(param_acq.frequency_MHz);
if isfield(param_acq, 'txFrequency_MHz')
    fTx_MHz = str2double(param_acq.txFrequency_MHz);
else
    fTx_MHz = fc_MHz; % transmit at the center frequency
end

Probe.nCycles = str2double(param_acq.npulse);
if Probe.nCycles == 6
    % hot fix: npulse stored in half-cycles in some acquisitions
    warning('getProbe:npulseHalfCycles', ['npulse = 6 in sequence.json ' ...
        'is read as 3 cycles (stored in half-cycles in some ULMShare ' ...
        'acquisitions, which all use a 3-cycle waveform)'])
    Probe.nCycles = 3;
end
Probe.twPeak_wl = Probe.nCycles/2*fc_MHz/fTx_MHz + irDelay_wl;

end
