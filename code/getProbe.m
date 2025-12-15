function Probe = getProbe(param_acq)
% get the number of elements and pitch of the probe
% whose name is contained in param_acq.transducer
% supports "L22-14v" and "GEL818iD"
probe_name = param_acq.transducer;

if strcmp(probe_name,"L22-14v") || strcmp(probe_name,"L22-14vX")
    Probe.Nelements = 128;
    Probe.pitch = 0.08*1e-3; % element width in m;
elseif strcmp(probe_name,"GEL818iD")
    Probe.Nelements = 168;
    Probe.pitch = 0.15*1e-3; % element width in m;
else
    error('unknown probe')
end

end

