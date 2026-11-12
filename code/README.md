# Code Directory

This directory contains MATLAB scripts to help you load and process the ULMShare dataset.

## Files

### Helper Functions
- **`getProbe.m`** - Returns probe specifications (number of probe elements, pitch, lens correction, transmit waveform peak) for supported transducers (L22-14v and GEL818iD)
- **`load_reshaped_bin.m`** - Loads reshaped binary data files with their headers

### Example Scripts
- **`example_script_one_buffer.m`** - Complete ULM pipeline demonstration using a single data buffer
  - Performs beamforming with delay-and-sum (DAS)
  - Applies clutter filtering via SVD
  - Optionally applies TGC and/or lag-1 autocorrelation signal enhancement (see Configuration below)
  - Generates power Doppler images
  - Performs microbubble tracking and localization
  - Produces ULM density maps

- **`example_script.m`** - Full processing pipeline that loops through all data buffers in an acquisition
  - Processes entire acquisition sequences
  - Same optional TGC / lag-1 signal enhancement as above, applied per buffer
  - Accumulates tracks across all buffers
  - Generates comprehensive ULM density maps

## Dependencies

Both example scripts require the following toolboxes to be in your MATLAB path:
1. **MUST** - For ultrasound beamforming operations, [available here](https://www.biomecardio.com/MUST/)
2. **TrackingAndLocalizationULM (TAL)** - For microbubble tracking and ULM processing, [available here](https://github.com/provostultrasoundlab/TrackingAndLocalizationULM)

Add these toolboxes using:
```matlab
addpath(genpath('..\MUST'))
addpath(genpath('..\TrackingAndLocalizationULM'))
```

## Usage

1. Ensure MUST and TAL toolboxes are available and added to your path. Please note that the TAL toolbox contains GPU functions that need to be compiled prior to use
2. Set `ulmShare_path` near the top of the script to your local ULMShare data location (the folder containing `mouse_X/acquisition_Y/...`)
3. Run `example_script_one_buffer.m` for quick testing with a single buffer. We advise to test on a buffer number around 50, as the first few buffers may not contain microbubbles. 
4. Run `example_script.m` for complete acquisition processing

## Configuration

Key parameters you may want to adjust:
- `mouse_number`, `acq_number` - Select specific acquisition
- `fnumber` - F-number for beamforming (default: 1.4)
- `deltaGrid` - Beamforming grid resolution (default: 25 μm)
- `clutterFilterCut` - Clutter filter cutoff percentage (default: 5%)
- `resolution_ULM_grid` - ULM map resolution factor (default: 10)
- `useTGC` - Apply spatially-dependent time-gain compensation after clutter filtering (default: `false`, since it re-runs SVD and is slower — see Methods Table 3 in the paper)
- `useLag1` - Apply lag-1 autocorrelation signal enhancement (default: `true`)
- `attEns` - TGC Gaussian filter standard deviation, in pixels (default: 9)
- `sizeEns` - Lag-1 temporal Hanning window length, in frames (default: 7)

## Receive start time

Verasonics starts recording at `startDepth_wavelengths` (from `sequence.json`). This is an acquisition setting, not an anatomical depth (e.g. not the skull position). The first IQ sample is therefore at
`t0 = (2*(startDepth - lensCorrection) - TWpeak) / fc` (all terms in wavelengths), which is passed to MUST as `ParamBF.t0`.
No data was recorded above the depth of the first IQ sample (`c*t0/2`), so the example scripts start the beamforming grid there when it is deeper than `startZ`.

`lensCorrection` (Verasonics `Trans.lensCorrection`, one-way lens delay) and `TWpeak` (Verasonics `TW(1).peak`, peak of the transmit waveform) are given by `getProbe.m`. The lens correction and the pitch are fixed per probe: 6.903016 λ and 0.10 mm for the L22-14v and 4.816033 λ and 0.15 mm for the GEL818iD. The transmit waveform is assumed to be a burst of `nCycles` cycles (`npulse` in `sequence.json`) at the transmit frequency `fTx` (`txFrequency_MHz` in `sequence.json`; not stored yet, so the center frequency `fc` is used when it is absent). Its peak is `TWpeak = nCycles/2 * fc/fTx + irDelay`, where `irDelay` is the delay added by the probe impulse response (2.4375 λ for the L22-14v, 1.375009 λ for the GEL818iD, taken from the Verasonics parameters of the acquisitions). In the L22-14v acquisitions of mice 1-38 and 60-61, `npulse` was stored in half-cycles (6 for a 3-cycle waveform); `getProbe.m` reads `npulse = 6` as 3 cycles and issues a warning. This will be correcred in the next DFDR upload. All ULMShare acquisitions use a 3-cycle waveform.

Two element counts are used. `Probe.NelementsProbe`, given by `getProbe.m`, is the number of elements of the probe (128 for the L22-14v, 168 for the GEL818iD). `Probe.Nelements`, the field used by MUST, is the number of active elements, i.e. the number of channels recorded in the data, which the example scripts read from the data file header. It can be smaller than the number of probe elements: for example, most GEL818iD acquisitions recorded 128 of its 168 elements.

## Data Paths

The scripts expect a single `ulmShare_path` pointing to the root of your local ULMShare data,
containing both metadata and raw data for each acquisition:
- Metadata: `ulmShare_path/mouse_X/acquisition_Y/sequence.json`
- Raw data: `ulmShare_path/mouse_X/acquisition_Y/dataXXX.bin`
