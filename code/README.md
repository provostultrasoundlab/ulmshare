# Code Directory

This directory contains MATLAB scripts to help you load and process the ULMShare dataset.

## Files

### Helper Functions
- **`getProbe.m`** - Returns probe specifications (number of elements, pitch) for supported transducers (L22-14v, L22-14vX, GEL818iD)
- **`load_reshaped_bin.m`** - Loads reshaped binary data files with their headers

### Example Scripts
- **`example_script_one_buffer.m`** - Complete ULM pipeline demonstration using a single data buffer
  - Performs beamforming with delay-and-sum (DAS)
  - Applies clutter filtering via SVD
  - Generates power Doppler images
  - Performs microbubble tracking and localization
  - Produces ULM density maps

- **`example_script.m`** - Full processing pipeline that loops through all data buffers in an acquisition
  - Processes entire acquisition sequences
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
2. Update data paths in the scripts to point to your local ULMShare data location
3. Run `example_script_one_buffer.m` for quick testing with a single buffer
4. Run `example_script.m` for complete acquisition processing

## Configuration

Key parameters you may want to adjust:
- `mouse_number`, `acq_number` - Select specific acquisition
- `fnumber` - F-number for beamforming (default: 1.4)
- `deltaGrid` - Beamforming grid resolution (default: 25 μm)
- `clutterFilterCut` - Clutter filter cutoff percentage (default: 5%)
- `resolution_ULM_grid` - ULM map resolution factor (default: 10)

## Data Paths

The scripts expect data in the following structure:
- Metadata: `ulmShare_path/mouse_X/acquisition_Y/sequence.json`
- Raw data: `ulmShare_path_data/mouse_X/acquisition_Y/dataXXX.bin`
