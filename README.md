# ULMShare: A Large-Scale In Vivo Ultrasound Localization Microscopy Dataset for Microvascular Imaging

## Overview
**ULMShare** is an open-access dataset designed to accelerate algorithm development, validation, and benchmarking in Ultrasound Localization Microscopy (ULM).
The data spans three years of experimental procedures, including multiple injection protocols, anesthesia types, and imaging planes (Striatum, Hippocampus, Midbrain, Pons, Cerebellum). 
It contains 99 acquisitions on 61 different mice.
This is the joint repository for the data decriptor: DOI [TBD] 

## Repository Purpose
This GitHub repository complements the raw data archive by providing:
1.  **Helper Code:** Lightweight MATLAB scripts for ULM reconstruction.
2.  **Example Outputs:** Illustrative ULM density maps and detected microbubble trajectories (tracks.json) to facilitate quick exploration without downloading and processing the full raw dataset.
3.  **Dataset Summary:** Aggregated metadata and reports to faciliate navigation and selection of specific acqusitions.

## Data Availability
The full **30 TB dataset**, including all raw ultrasonic channel data (RF), is publicly available through the **Federated Research Data Repository (FRDR)**.

* **Raw Data:** [https://www.frdr-dfdr.ca/repo/collection/tulmshare](https://www.frdr-dfdr.ca/repo/collection/tulmshare)
* **Code & Examples:** [This GitHub Repository](https://github.com/provostultrasoundlab/ulmshare)


## Citation
If you use ULMShare in your research, please cite the primary data descriptor:  
- DOI : [TBD] 

If you use the provided MATLAB scripts for ULM reconstruction in your research, please cite:  
- DOI : 10.1016/j.ultras.2020.106309 - 10.1109/IUS52206.2021.9593605 - 10.1109/TMI.2024.3456676

Additionally, specific subsets of this data supported previous studies. Please cite the corresponding DOI if using, even partially, the following acquisitions:
* DOI: 10.1016/j.ultrasmedbio.2024.05.023 (7 acquisitions) 
	Includes: Mouse 35 (Acq 1), Mouse 36 (Acq 1, 2), Mouse 37 (Acq 1, 2), Mouse 38 (Acq 1, 2).
* DOI: 10.1109/TBME.2025.3564473 (6 acquisitions)
	Includes: Mouse 57 (Acq 1, 2), Mouse 58 (Acq 1), Mouse 59 (Acq 1, 2, 3).
* DOIs: 10.1109/TBME.2025.3564473 & 10.1109/TMI.2023.3316995 (3 acquisitions)
	Includes: Mouse 55 (Acq 1, 2), Mouse 56 (Acq 1).

## Contact
For questions or support, email jean.provost@polymtl.ca and include “ULMShare” in the subject line of your email.