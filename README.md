# ULMShare: A Large-Scale In Vivo Ultrasound Localization Microscopy Dataset for Microvascular Imaging

## Overview
**ULMShare** is an open-access dataset designed to accelerate algorithm development, validation, and benchmarking in Ultrasound Localization Microscopy (ULM).
The data spans three years of experimental procedures, including multiple injection protocols, anesthesia types, and imaging planes (Striatum, Hippocampus, Midbrain, Pons, Cerebellum). 
It contains 99 acquisitions on 61 different mice.
This is the joint repository for the data descriptor, currently in peer review: [preprint on arXiv](https://arxiv.org/abs/2606.07851). The dataset DOI is [10.20383/103.01550](https://doi.org/10.20383/103.01550); the peer-reviewed data descriptor citation will be added here once published.

## Repository Purpose
This GitHub repository complements the raw data archive by providing:
1.  **Helper Code:** Lightweight MATLAB scripts for ULM reconstruction.
2.  **Example Outputs:** Illustrative ULM density maps and detected microbubble trajectories (tracks.json) to facilitate quick exploration without downloading and processing the full raw dataset.
3.  **Dataset Summary:** Aggregated metadata and reports to faciliate navigation and selection of specific acqusitions.

## Repository Structure
```
ulmshare/
├── code/                   # MATLAB helper scripts and example ULM pipeline (see code/README.md)
│   ├── example_script_one_buffer.m
│   ├── example_script.m
│   └── ...
├── examples_ulm/           # Illustrative outputs per acquisition
│   └── Mouse_XX/acquisition_YY/
│       ├── density_map.jpg
│       ├── tracks.json.xz
│       └── metrics.json
└── summary/                # Dataset-wide overview
    ├── metadata_summary.csv
    ├── images/
    └── report.md
```
The raw 30 TB acquisition data itself (channel data + JSON metadata) is **not** in this repository — it is hosted on FRDR (see below). This repo only holds code and lightweight illustrative outputs.

## Getting Started
New to this repo? Start here:
1. Read `code/README.md` for how to run the example MATLAB pipeline on a downloaded acquisition.
2. Browse `summary/report.md` and `summary/metadata_summary.csv` to find a specific mouse/acquisition without downloading any raw data.
3. Look under `examples_ulm/` for that acquisition's precomputed density map and tracks — no processing required.

## Data Availability
The full **30 TB dataset**, including all raw ultrasonic channel data (RF), is publicly available through the **Federated Research Data Repository (FRDR)**.

* **Raw Data:** [https://doi.org/10.20383/103.01550](https://doi.org/10.20383/103.01550)
* **Code & Examples:** [This GitHub Repository](https://github.com/provostultrasoundlab/ulmshare)


## Note about large example files (Git LFS)

Some example output files (notably the compressed `tracks.json.xz` files under `examples_ulm/`) are stored using Git Large File Storage (Git LFS) to keep the repository lightweight. After cloning the repository, install Git LFS and fetch these objects with:

```
git lfs install
git lfs pull
```

If you see text pointers in place of large files (starting with `version https://git-lfs.github.com/spec/v1`), run `git lfs pull` to download the real content.


## Citation
If you use ULMShare in your research, please cite the primary data descriptor. The paper is
currently in peer review; cite the preprint until the peer-reviewed version is published:
- Preprint: https://arxiv.org/abs/2606.07851
- Dataset DOI: https://doi.org/10.20383/103.01550

If you use the provided MATLAB scripts for ULM reconstruction in your research, please cite:  
- DOI : 10.1016/j.ultras.2020.106309 - 10.1109/IUS52206.2021.9593605 - 10.1109/TMI.2024.3456676

Additionally, specific subsets of this data supported previous studies. Please cite the corresponding DOI if using, even partially, the following acquisitions:
* DOI: 10.1016/j.ultrasmedbio.2024.05.023 (7 acquisitions) 
	Includes: Mouse 35 (Acq 1), Mouse 36 (Acq 1, 2), Mouse 37 (Acq 1, 2), Mouse 38 (Acq 1, 2).
* DOI: 10.1109/TBME.2025.3564473 (7 acquisitions)
	Includes: Mouse 56 (Acq 2), Mouse 57 (Acq 1, 2), Mouse 58 (Acq 1), Mouse 59 (Acq 1, 2, 3).
* DOIs: 10.1109/TBME.2025.3564473 & 10.1109/TMI.2023.3316995 (4 acquisitions)
	Includes: Mouse 55 (Acq 1, 2), Mouse 56 (Acq 1, 3).

## Contact
For questions or support, email jean.provost@polymtl.ca and include “ULMShare” in the subject line of your email.


