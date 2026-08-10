% this example script provides a ULM density map for the mouse mouse_number
% and acquisition acq_number using ALL available data buffers
% it uses MUST for its Beamforming, and TAL for its ULM processing

mouse_number = 1;
acq_number = 1;
useTGC = false;   % apply spatially-dependent time-gain compensation
                  % keep false by default for faster processing
useLag1 = true;   % apply lag-1 autocorrelation signal enhancement
%% path and folders
% MUST toolbox necessary to have in path for BF
% TAL toolbox necessary to have in path for ULM processing
path_TAL = '..\TrackingAndLocalizationULM';
addpath(genpath('..\MUST'))
addpath(genpath(path_TAL))

ulmShare_path = ''; % fill with ULMShare data path
folder_acq = [ulmShare_path 'mouse_' num2str(mouse_number) ...
    filesep 'acquisition_' num2str(acq_number) filesep];
folder_acq_data = [ulmShare_path 'mouse_' num2str(mouse_number) ...
    filesep 'acquisition_' num2str(acq_number) filesep];

save_track_folder = [folder_acq 'track\']; mkdir(save_track_folder);

%% processing parameters
% BF parameters
fnumber = 1.4;
startX = -0.5*1e-2; endX = 0.5*1e-2; % start and end x for BF grid (m)
startZ = 0.05*1e-2; endZ = .85*1e-2; % start and end x for BF grid (m)
deltaGrid = 2.5*1e-5; % resolution of BF grid (m)
% Clutter filter parameter
clutterFilterCut = 5/100; % clutter filter cut of (%)
% Signal-enhancement options (applied after clutter filtering)
attEns = 9;      % TGC: Gaussian filter std, in pixels (Table 3)
sizeEns = 7;     % lag-1: temporal Hanning window length, in frames
% ULM parameters localization
resolution_ULM_grid = 10; % lambda / resolution_ULM_grid gives the ULM map pixel size

%% initialization and loading
% load parameter acquisition
fid=fopen([folder_acq, filesep, 'sequence.json'],'r');
param_acq = fscanf(fid,'%c'); fclose(fid);
param_acq = jsondecode(param_acq);
% load probe info
Probe = getProbe(param_acq);
% Define BF grid
xaxis = startX:deltaGrid:endX-deltaGrid;
zaxis = startZ:deltaGrid:endZ-deltaGrid;
[xgrid,zgrid] = meshgrid(xaxis, zaxis);
% compute transmit delays for BF
nbAngles = str2double(param_acq.nbAngles);
txdel = cell(nbAngles,1);
angles = sscanf(param_acq.angles_deg, '%f,');
for k_angle = 1:nbAngles
    txdel{k_angle} = txdelay(Probe,deg2rad(angles(k_angle)));
end
% parameters necessary for BF
ParamBF = Probe;
ParamBF.fc = str2double(param_acq.frequency_MHz)*1e6; % center frequency
% demodulation frequency of IQ
if  strcmp(param_acq.sampling,'BS100BW')
    ParamBF.fs = ParamBF.fc;
elseif strcmp(param_acq.sampling,'BS50BW')
    ParamBF.fs = ParamBF.fc/2;
else
    error('200 % Bandwith is not currently implemented')
end
ParamBF.fnumber = fnumber;

wavelength = 1540/ParamBF.fc;
% find the default processing parameters
cfg_processing_path = [path_TAL '\config\config.json'] ;
ParamProcessing = dataLoader.LoadSaveParams(cfg_processing_path,[save_track_folder,'/cfg_processing.json']);

frameRate = str2double(param_acq.frameRate_Hz);
% create Interpolator and Velocitor objects
Interpolator = interpolation.Interpolator(ParamProcessing,frameRate);
Velocitor = velocity.Velocitor(ParamProcessing);
% create the ULM density grid
deltaGridULM = wavelength/resolution_ULM_grid;
xaxisULM = startX:deltaGridULM:endX-deltaGrid;
zaxisULM = startZ:deltaGridULM:endZ-deltaGrid;

gridStruct.resBfGrid = deltaGrid;
gridStruct.xMin = startX;
gridStruct.yMin = 0;
gridStruct.zMin = startZ;
% assign empty density map matrix
densMapTracks = zeros(size(zaxisULM,2),size(xaxisULM,2));

% Extract number of data.bin
dataFilesListing = dir([folder_acq_data, filesep, 'data*.bin']);
fileNames = {dataFilesListing.name};
indice_data = cellfun(@(x) str2double(regexp(x, '(?<=data)\d+', 'match', 'once')), fileNames);
[indice_data, sortIdx] = sort(indice_data);
% Reorder trackFilesListing accordingly
dataFilesListing = dataFilesListing(sortIdx);
nData = length(dataFilesListing);
Track_tot = cell(nData,1);
%% actual loop
for numBuffer = 1:nData
    numBuffer
    % load raw data
    currentFile = [dataFilesListing(numBuffer).folder, filesep, ...
        dataFilesListing(numBuffer).name];
    raw = load_reshaped_bin(currentFile);
    raw = double(raw);
    % rf 2 iq
    iq = complex(raw(1:2:end,:,:,:), -raw(2:2:end,:,:,:));
    %% BF with MUST
    % reshape raw data for MUST
    iq = reshape(iq,size(iq,1),size(iq,2),nbAngles,[]);
    % initialize matrix
    iq_bf = zeros(length(zaxis),length(xaxis),size(iq,4),nbAngles);
    h = waitbar(0,'');
    for k_angle = 1:nbAngles
        waitbar(k_angle/nbAngles,h,['DAS: I/Q series #' int2str(k_angle) ' of ' param_acq.nbAngles])
        iq_bf(:,:,:,k_angle) = das(squeeze(iq(:,:,k_angle,:)),xgrid,zgrid,txdel{k_angle},ParamBF);
    end
    close(h)
    % compounding
    iq_bf = sum(iq_bf,4);
    %% clutter filtering
    iq_cf = svdClutterFilter(iq_bf, clutterFilterCut);
    %% signal enhancement: TGC and lag-1 autocorrelation
    if useTGC
        % compute the TGC mask from the clutter-filtered signal
        attenuationMask = imgaussfilt(sqrt(mean(abs(iq_cf).^2,3)), attEns);
        % apply to the original pre-SVD beamformed data, then re-run SVD
        iq_cf = svdClutterFilter(iq_bf ./ (attenuationMask + eps), clutterFilterCut);
    end
    if useLag1
        ht = hanning(sizeEns); ht = reshape(ht./sum(ht), [1 1 sizeEns]);
        lag1_complex = imfilter(iq_cf(:,:,1:end-1).*conj(iq_cf(:,:,2:end)), ht);
        iq_cf = sqrt(abs(lag1_complex));
    end
    %% display power doppler
    % powerDopplerMovie = 20*log10(abs(iq_cf));
    % powerDopplerMovie = powerDopplerMovie - max(powerDopplerMovie(:));
    % figure
    % for k_fr = 1:sizeIQ(end)
    %     imagesc(xaxis*1e3,zaxis*1e3,powerDopplerMovie(:,:,k_fr))
    %     title(['frame ' num2str(k_fr)])
    %     clim([-40 0]); axis image;
    %     xlabel('x axis (mm)')
    %     ylabel('y axis (mm)')
    %     c= colorbar;
    %     c.Ticks= [-40 0];
    %     drawnow
    %     xticks(-4:4:4)
    %     yticks(2:2:8)
    %     % Capture frame
    %     frame = getframe(gcf);
    %     writeVideo(v, frame);
    % end
    %
    % powerDoppler = 20*log10(sum(abs(iq_cf),3));
    % powerDoppler = powerDoppler - max(powerDoppler(:));
    % figure
    % imagesc(xaxis*1e3,zaxis*1e3,powerDoppler)
    % clim([-40 0]); axis image;
    % title('Power Doppler (dB)')
    % xlabel('x axis (mm)')
    % ylabel('y axis (mm)')
    % c= colorbar;
    % c.Ticks= [-40 0];

    %% ULM processing
    sizeIQ      = size(iq_cf);
    numFrame    = sizeIQ(end);
    wavelength  = 1540/ParamBF.fc;
    resultsTracking.(ParamProcessing.trackingMethod{1}) = ...
        SpatioTempTracker(iq_cf,ParamProcessing);
    tracks = Tracks(resultsTracking,ParamProcessing,frameRate,numFrame);
    % save the TAL track object before interpolation for lighter files
    save([save_track_folder 'track' num2str(numBuffer) '.mat'],'tracks')
    tracks = Interpolator.interp_tracks(tracks);
    tracks = Velocitor.velocity_tracks(tracks);
    tracks.pixelToMeters(gridStruct);
    % projection on the density map
    tmp = cell2mat(tracks.tracks_interp.spatio_temp_hessian);
    densMapTracks = densMapTracks + lib.DensityMappingND(tmp,xaxisULM,zaxisULM);

    toc
end

%% display densMap
powerDens = 0.6;

figure
imagesc(xaxisULM*1e3,zaxisULM*1e3,densMapTracks.^powerDens)
axis image
clim([0 40])
xlabel('Lateral position (mm)')
ylabel('Depth (mm)')
yticks(1:2:9)
xticks(-4:2:4)
title('ULM density map')
colormap gray
xlim([-4 4])
ylim([-inf 7.5])

%% local functions
function iq_out = svdClutterFilter(iq_in, clutterFilterCut)
sizeIQ = size(iq_in);
iq_flat = reshape(iq_in,[],sizeIQ(end));
[eig_vect,eig_val]  = svd(double(iq_flat'*iq_flat));
eig_val             = diag(eig_val); %#ok<NASGU>
Ncut = round(sizeIQ(end)*clutterFilterCut);
eig_vect          = eig_vect(:,Ncut:end);
iq_flat           = (iq_flat*eig_vect)*eig_vect';
iq_out            = reshape(iq_flat,sizeIQ);
end