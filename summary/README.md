# Summary Directory

This directory contains a dataset-wide overview, aggregated from the per-acquisition
`mouse.json` / `acquisition.json` metadata files and post-processing metrics.

## Files

- **`metadata_summary.csv`** — one row per acquisition (99 rows), with the mouse-level
  and acquisition-level metadata joined together, plus processing metrics and quality
  grade. Field descriptions below.
- **`report.md`** — one section per acquisition, with its metrics and a link to its
  density map image.
- **`images/`** — density map thumbnails referenced by `report.md`.

Blank values mean the field was not recorded for that acquisition.

## `metadata_summary.csv` field descriptions

| Field | Description |
|---|---|
| `mouse_idx` | Unique mouse identifier (e.g. `mouse_1`). |
| `acquisition_idx` | Acquisition identifier within a mouse (e.g. `acquisition_1`). |
| `doi_citations` | DOI(s) of prior publications that used this specific acquisition; cite these alongside the dataset DOI if reusing this acquisition's data. Semicolon-separated if more than one. |
| `location` | Facility where the mouse was housed and imaged (`McGill`, `ICM`, or `UDM`). |
| `protocole_id` | Animal ethics protocol ID under which the acquisition was approved. |
| `probes` | Ultrasound transducer used (`L22-14` = L22-14v, or `L8-18iD`). |
| `sex` | `F` (female) or `M` (male). |
| `animal_strain` | Mouse strain — `C57BL/6J` or `C57BL/6N`. |
| `age_days` | Age at acquisition, in days. |
| `weight` | Body weight at acquisition, in grams. |
| `slice_position` | Imaging plane, where recorded — either a qualitative anatomical region (e.g. `striatum`, `hippocampus`) or a numeric Bregma coordinate in mm (e.g. `-2.2`). |
| `temperature` | Body temperature range during acquisition, in °C, where recorded. |
| `procedure_type` | High-level acquisition category, e.g. `Functional` (stimulation paradigm) or `Trig` (cardiac-gated). |
| `procedure_info` | Free-text description of the specific procedure (e.g. stimulation modality and trigger method). |
| `anesthesia` | Anesthesia protocol used. |
| `syringe_gauge` | Gauge of the syringe used for microbubble injection, where recorded. |
| `flush` | Whether the injection line was flushed with saline after microbubble injection (`Yes`/`No`). |
| `injection_type` | Route and method of microbubble injection. |
| `mb_dilution` | Microbubble dilution ratio, or `Pure injection` if undiluted. |
| `volume_mb_injected` | Volume (or per-body-weight dose) of microbubbles injected. |
| `FRC_um` | Fourier Ring Correlation half-bit resolution, in µm (see Technical Validation in the paper). |
| `saturation_percent` | Vascular saturation — percent of the field of view visited by localized microbubbles. |
| `mean_track_length_frames` | Mean detected microbubble track length, in frames. |
| `quality_grade` | Visual quality grade (`A`/`B`/`C`) assigned by expert review. |
