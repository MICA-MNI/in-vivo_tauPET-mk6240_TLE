# *In-vivo* evidence for increased tau deposition in temporal lobe epilepsy

### Table of Contents

1.  [Directory file content](#directory-file-content)
2.  [Tau PET 18F-mk6240 features](#tau-pet--18f-mk6240-features)
3.  [Data analysis](#data-analysis)

### Directory file content

| File                                                                                                                                                                      | Description                                                                   |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| [`Fig-1_Tau-pet_18F-mk6240_SupFig.ipynb`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/Fig-1_Tau-pet_18F-mk6240_SupFig.ipynb)             | PET-preprocessing script                                                      |
| [`Fig-2_network_contextualization.ipynb`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/Fig-2_network_contextualization.ipynb)             | notebook                                                                      |
| [`Fig-3_clinical-cognitive_correlations.ipynb`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/Fig-3_clinical-cognitive_correlations.ipynb) | notebook                                                                      |
| [`Fig-sup_sex-analysis.ipynb`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/Supplementary_sex-analysis.ipynb)                             | notebook                                                                      |
| [`Increased_in-vivo_tau_in_TLE.py`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/Increased_in-vivo_tau_in_TLE.py)                         | A Python script with all the                                                  |
| [`Increased_in-vivo_tau_in_TLE.Rmd`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/Increased_in-vivo_tau_in_TLE.Rmd)                       | An R Markdown document includes statistical analysis and data visualization.  |
| [`utils.py`](https://github.com/MICA-MNI/2025_in-vivo_tauPET-mk6240_TLE/blob/main/scripts/utils.py)                                                                       | A Python utility script, containing all the helper functions for the analysis |

## Tau PET \| 18F-mk6240 features

The PET images are transformed to `NIFTI` from the `ECAT (.v)` files
with `v1.0.20240202 GCC11.2.0`. This transformation keeps the data in
nano Curies.

### Parameters

**Dimensions**: 256 x 256 x 207  
**Voxel size**: 1.21875 x 1.21875 x 1.21875  
**psfmm** : scanner PSF FWHM in mm

> psf FWHM is the full-width/half-max of the the point-spread function
> (PSF) of the scanner as measured in image space (also known as the
> burring function). The blurring function depends on the scanner and
> reconstruction method

### Unit reference

> cc=cm3=mL 1 nCi = 37 Bq  
> Bq: Becquerels  
> nCi: nano Curies

### 3D non motion corrected data

1.  `TX256.v` Linear atenuation map, 4D_MC is corregistered to this
    image. Later this is the image that is use to calculate the affine
    registration between PET and MRi space. \> This is a CT transmission
    scan
2.  `EM_3D.v` 4 frames, 20 minutes of acquisition each one (Bq/cc).
3.  `EM_3D_AVG.v` average of the four frames (Bq/cc).

### 4D motion corrected data

1.  `EM_4D_MC01.v` Filter Back Projection (FBP) image. It is the
    inversion of the radon transformation. 4 frames, 20 minutes of
    acquisition each one (nCi/cc).
2.  `EM_4D_MC01_AVG.v` FBP average of 4 four frames (nCi/cc units).

### Standardized uptake values

In summary this gives the following equation to calculate SUV at time
$t$ post injection:

> ![SUV](https://latex.codecogs.com/svg.image?%7B\color%7BWhite%7D&space;SUV(t)&space;=&space;\frac&space;%7Bc_%7Bimg%7D(t)%7D&space;%7BID&space;/&space;BW%7D%7D)  
> **Cimg**=PET image  
> **ID**=Injected dose  
> **BW**=body weight  
> With the radioactivity measured from an image acquired at (or around)
> the time t, decay corrected to t=0 and expressed as volume
> concentration (e.g. MBq/mL), the injected dose ID at t=0 (e.g. in
> MBq), and the body weight BW (near the time of image acquisition)
> implicitly converted into the body volume assuming an average mass
> density of 1 g/mL.

**SUVR (ratio)**: The injected activity, body weight, and mass density,
which are all components of the SUV calculation, cancel each other out.

> ![](https://latex.codecogs.com/svg.image?%7B\color%7BWhite%7D&space;%7B\mathit%7BSUVR%7D%7D&space;=&space;\frac&space;%7B\mathit%7BSUV_%7Btarget%7D%7D%7D&space;%7B\mathit%7BSUV_%7Breference%7D%7D%7D&space;=&space;\frac&space;%7B\mathit%7Bc_%7Bimg,target%7D%7D%7D&space;%7B\mathit%7Bc_%7Bimg,reference%7D%7D%7D%7D)

# Data analysis

## Database description

| Column name         | Description                                                          |
|---------------------|----------------------------------------------------------------------|
| `id`                | Unique subject identifier <participant_id>\_\<mk6240.session\>.      |
| `participant_id`    | Alphanumerical subject label.                                        |
| `mk6240.session`    | PET session index for 18F-MK6240 acquisition (1 or 2).               |
| `mk6240.Tdiff`      | Time difference (months) between first and second MK6240 PET session |
| `mk6240.mri.Tdiff`  | Time difference (months) between MRI and first MK6240 PET session    |
| `sex`               | Biological sex of the participant (F/M).                             |
| `age`               | Participant’s age at the time of PET scan.                           |
| `age.mri1`          | Participant’s age at the time of the first MRI scan.                 |
| `handedness`        | Hand preference (Right, Left, Ambidextrous).                         |
| `language`          | Primary language spoken by the participant.                          |
| `group`             | Diagnostic group (Healthy, Patient).                                 |
| `mk6240.mean`       | Whole-brain mean SUVR of 18F-MK6240.                                 |
| `epilepsy.class`    | Epilepsy classification (clinical subtype).                          |
| `origin`            | Epilepsy etiology (e.g., mTLE, TLE, unclear).                        |
| `lateralization`    | Laterality of the seizure onset in TLE (R, L).                       |
| `hs`                | Presence of hippocampal sclerosis (assymetry or atrophy)             |
| `dre`               | Drug-resistant epilepsy status (Yes/No).                             |
| `onset`             | Age at epilepsy onset.                                               |
| `duration`          | Duration of epilepsy (years).                                        |
| `IEDs`              | Interictal epileptiform discharge frequency from EMU or LTMO.        |
| `GTCSF`             | generalized tonic-clonic seizures frequency per year.                |
| `asm.number`        | Number of anti-seizure medications taken.                            |
| `sx.number`         | Number of surgeries (if any)                                         |
| `engel`             | Engel post-operative seizure freedom classification.                 |
| `EpiTrack`          | Age-corrected composite score from the EpiTrack cognitive battery.   |
| `Episodic`          | Percent accuracy in delayed recall trials.                           |
| `Semantic`          | Accuracy in the semantic decision task.                              |
| `hip.ipsi`          | Ipsilateral hippocampal volume (z-score).                            |
| `hip.cntr`          | Contralateral hippocampal volume (z-score).                          |
| `suvr.ipsi.?`       | Mean 18F-MK6240 SUVR in ipsilateral subcortical ROIs.                |
| `suvr.cntr.?`       | Mean 18F-MK6240 SUVR in contralateral subcortical ROIs.              |
| `?c.strength`       | Mean node strength of the FC/SC network.                             |
| `?c.clustecoef`     | Average clustering coefficient of the FC/SC network.                 |
| `?c.efficiency`     | Global efficiency of the FC/SC network.                              |
| `?c.pathlengh`      | Characteristic path length of the FC/SC network.                     |
| `?c.neighbors`      | Average number of neighbors (node degree) in the FC/SC network.      |
| `mk6240.sig.ipsi`   | Mean 18F-MK6240 SUVR in ipsilateral significant cortical clusters.   |
| `mk6240.sig.contra` | Mean 18F-MK6240 SUVR in contralateral significant cortical clusters. |

### Setup the environment

### Get the data from the OSF repository

## Participants

# Mean and Std

<table style="NAborder-bottom: 0; color: black; " class="table">
<thead>
<tr>
<th style="text-align:left;">
Demographics
</th>
<th style="text-align:center;">
Patient <br>N = 41
</th>
<th style="text-align:center;">
Healthy <br>N = 35
</th>
<th style="text-align:center;">
Statistic
</th>
<th style="text-align:center;">
p-value
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
age
</td>
<td style="text-align:center;">
36±12
</td>
<td style="text-align:center;">
33±7
</td>
<td style="text-align:center;">
1.47
</td>
<td style="text-align:center;">
0.15
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.mean
</td>
<td style="text-align:center;">
1.14±0.10
</td>
<td style="text-align:center;">
1.06±0.11
</td>
<td style="text-align:center;">
3.29
</td>
<td style="text-align:center;">
0.002
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.sig
</td>
<td style="text-align:center;">
1.27±0.13
</td>
<td style="text-align:center;">
1.12±0.13
</td>
<td style="text-align:center;">
5.05
</td>
<td style="text-align:center;">
\<0.001
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.mean.ipsi
</td>
<td style="text-align:center;">
1.15±0.10
</td>
<td style="text-align:center;">
1.07±0.11
</td>
<td style="text-align:center;">
3.16
</td>
<td style="text-align:center;">
0.002
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.mean.contra
</td>
<td style="text-align:center;">
1.13±0.11
</td>
<td style="text-align:center;">
1.05±0.11
</td>
<td style="text-align:center;">
3.25
</td>
<td style="text-align:center;">
0.002
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.sig.ipsi
</td>
<td style="text-align:center;">
1.29±0.15
</td>
<td style="text-align:center;">
1.14±0.12
</td>
<td style="text-align:center;">
4.76
</td>
<td style="text-align:center;">
\<0.001
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.sig.contra
</td>
<td style="text-align:center;">
1.25±0.15
</td>
<td style="text-align:center;">
1.09±0.13
</td>
<td style="text-align:center;">
4.92
</td>
<td style="text-align:center;">
\<0.001
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.Tdiff
</td>
<td style="text-align:center;">
5±8
</td>
<td style="text-align:center;">
5±11
</td>
<td style="text-align:center;">
0.305
</td>
<td style="text-align:center;">
0.8
</td>
</tr>
<tr>
<td style="text-align:left;">
mk6240.mri.Tdiff
</td>
<td style="text-align:center;">
13±16
</td>
<td style="text-align:center;">
13±15
</td>
<td style="text-align:center;">
-0.017
</td>
<td style="text-align:center;">
\>0.9
</td>
</tr>
<tr>
<td style="text-align:left;">
EpiTrack
</td>
<td style="text-align:center;">
34.1±4.2
</td>
<td style="text-align:center;">
36.8±3.3
</td>
<td style="text-align:center;">
-3.04
</td>
<td style="text-align:center;">
0.003
</td>
</tr>
<tr>
<td style="text-align:left;">
Episodic
</td>
<td style="text-align:center;">
47±22
</td>
<td style="text-align:center;">
71±20
</td>
<td style="text-align:center;">
-4.63
</td>
<td style="text-align:center;">
\<0.001
</td>
</tr>
<tr>
<td style="text-align:left;">
Semantic
</td>
<td style="text-align:center;">
0.82±0.08
</td>
<td style="text-align:center;">
0.83±0.10
</td>
<td style="text-align:center;">
-0.293
</td>
<td style="text-align:center;">
0.8
</td>
</tr>
<tr>
<td style="text-align:left;">
hip.ipsi
</td>
<td style="text-align:center;">
-0.67±1.43
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
-2.38
</td>
<td style="text-align:center;">
0.020
</td>
</tr>
<tr>
<td style="text-align:left;">
hip.cntr
</td>
<td style="text-align:center;">
-0.06±1.05
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
-0.245
</td>
<td style="text-align:center;">
0.8
</td>
</tr>
</tbody>
<tfoot>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>1</sup> Mean±SD
</td>
</tr>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>2</sup> Welch Two Sample t-test
</td>
</tr>
</tfoot>
</table>

## Sex distribution by group and session

<div id="himvsjirdr" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#himvsjirdr table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#himvsjirdr thead, #himvsjirdr tbody, #himvsjirdr tfoot, #himvsjirdr tr, #himvsjirdr td, #himvsjirdr th {
  border-style: none;
}
&#10;#himvsjirdr p {
  margin: 0;
  padding: 0;
}
&#10;#himvsjirdr .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#himvsjirdr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#himvsjirdr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#himvsjirdr .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#himvsjirdr .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#himvsjirdr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#himvsjirdr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#himvsjirdr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#himvsjirdr .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#himvsjirdr .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#himvsjirdr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#himvsjirdr .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#himvsjirdr .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#himvsjirdr .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#himvsjirdr .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#himvsjirdr .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#himvsjirdr .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#himvsjirdr .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#himvsjirdr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#himvsjirdr .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#himvsjirdr .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#himvsjirdr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#himvsjirdr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#himvsjirdr .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#himvsjirdr .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#himvsjirdr .gt_left {
  text-align: left;
}
&#10;#himvsjirdr .gt_center {
  text-align: center;
}
&#10;#himvsjirdr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#himvsjirdr .gt_font_normal {
  font-weight: normal;
}
&#10;#himvsjirdr .gt_font_bold {
  font-weight: bold;
}
&#10;#himvsjirdr .gt_font_italic {
  font-style: italic;
}
&#10;#himvsjirdr .gt_super {
  font-size: 65%;
}
&#10;#himvsjirdr .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#himvsjirdr .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#himvsjirdr .gt_indent_1 {
  text-indent: 5px;
}
&#10;#himvsjirdr .gt_indent_2 {
  text-indent: 10px;
}
&#10;#himvsjirdr .gt_indent_3 {
  text-indent: 15px;
}
&#10;#himvsjirdr .gt_indent_4 {
  text-indent: 20px;
}
&#10;#himvsjirdr .gt_indent_5 {
  text-indent: 25px;
}
&#10;#himvsjirdr .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#himvsjirdr div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;Characteristic&lt;/strong&gt;&lt;/span&gt;"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;Patient&lt;/strong&gt;&lt;/span&gt;">
        <span class="gt_column_spanner"><span class='gt_from_md'><strong>Patient</strong></span></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;Healthy&lt;/strong&gt;&lt;/span&gt;">
        <span class="gt_column_spanner"><span class='gt_from_md'><strong>Healthy</strong></span></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;1&lt;/strong&gt;&lt;br /&gt;&#10;N = 28&lt;/span&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><span class='gt_from_md'><strong>1</strong><br />
N = 28</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;2&lt;/strong&gt;&lt;br /&gt;&#10;N = 13&lt;/span&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><span class='gt_from_md'><strong>2</strong><br />
N = 13</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;1&lt;/strong&gt;&lt;br /&gt;&#10;N = 28&lt;/span&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><span class='gt_from_md'><strong>1</strong><br />
N = 28</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;span class='gt_from_md'&gt;&lt;strong&gt;2&lt;/strong&gt;&lt;br /&gt;&#10;N = 7&lt;/span&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><span class='gt_from_md'><strong>2</strong><br />
N = 7</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">sex</td>
<td headers="stat_1_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2_1" class="gt_row gt_center"><br /></td>
<td headers="stat_1_2" class="gt_row gt_center"><br /></td>
<td headers="stat_2_2" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    F</td>
<td headers="stat_1_1" class="gt_row gt_center">14</td>
<td headers="stat_2_1" class="gt_row gt_center">4</td>
<td headers="stat_1_2" class="gt_row gt_center">14</td>
<td headers="stat_2_2" class="gt_row gt_center">2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    M</td>
<td headers="stat_1_1" class="gt_row gt_center">14</td>
<td headers="stat_2_1" class="gt_row gt_center">9</td>
<td headers="stat_1_2" class="gt_row gt_center">14</td>
<td headers="stat_2_2" class="gt_row gt_center">5</td></tr>
    <tr><td headers="label" class="gt_row gt_left">handedness</td>
<td headers="stat_1_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2_1" class="gt_row gt_center"><br /></td>
<td headers="stat_1_2" class="gt_row gt_center"><br /></td>
<td headers="stat_2_2" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    L</td>
<td headers="stat_1_1" class="gt_row gt_center">2</td>
<td headers="stat_2_1" class="gt_row gt_center">2</td>
<td headers="stat_1_2" class="gt_row gt_center">2</td>
<td headers="stat_2_2" class="gt_row gt_center">1</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    R</td>
<td headers="stat_1_1" class="gt_row gt_center">26</td>
<td headers="stat_2_1" class="gt_row gt_center">11</td>
<td headers="stat_1_2" class="gt_row gt_center">26</td>
<td headers="stat_2_2" class="gt_row gt_center">6</td></tr>
    <tr><td headers="label" class="gt_row gt_left">age</td>
<td headers="stat_1_1" class="gt_row gt_center">37±12</td>
<td headers="stat_2_1" class="gt_row gt_center">36±11</td>
<td headers="stat_1_2" class="gt_row gt_center">33±8</td>
<td headers="stat_2_2" class="gt_row gt_center">35±3</td></tr>
    <tr><td headers="label" class="gt_row gt_left">mk6240.Tdiff</td>
<td headers="stat_1_1" class="gt_row gt_center">0±0</td>
<td headers="stat_2_1" class="gt_row gt_center">17±4</td>
<td headers="stat_1_2" class="gt_row gt_center">0±0</td>
<td headers="stat_2_2" class="gt_row gt_center">23±12</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="5"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height: 0;"><sup>1</sup></span> <span class='gt_from_md'>n; Mean±SD</span></td>
    </tr>
  </tfoot>
</table>
</div>

## Clinical characteristics of patients

<table style="NAborder-bottom: 0; color: black; " class="table">
<thead>
<tr>
<th style="text-align:left;">
Patients
</th>
<th style="text-align:center;">
1 <br>N = 28
</th>
<th style="text-align:center;">
2 <br>N = 13
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
duration
</td>
<td style="text-align:center;">
15.3±11.5
</td>
<td style="text-align:center;">
12.2±8.7
</td>
</tr>
<tr>
<td style="text-align:left;">
onset
</td>
<td style="text-align:center;">
21±14
</td>
<td style="text-align:center;">
24±17
</td>
</tr>
<tr>
<td style="text-align:left;">
origin
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
mTLE
</td>
<td style="text-align:center;">
12 (43%)
</td>
<td style="text-align:center;">
7 (54%)
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
TLE
</td>
<td style="text-align:center;">
15 (54%)
</td>
<td style="text-align:center;">
6 (46%)
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
unclear
</td>
<td style="text-align:center;">
1 (3.6%)
</td>
<td style="text-align:center;">
0 (0%)
</td>
</tr>
<tr>
<td style="text-align:left;">
lateralization
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
BL
</td>
<td style="text-align:center;">
2 (7.1%)
</td>
<td style="text-align:center;">
0 (0%)
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
L
</td>
<td style="text-align:center;">
13 (46%)
</td>
<td style="text-align:center;">
7 (54%)
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
R
</td>
<td style="text-align:center;">
12 (43%)
</td>
<td style="text-align:center;">
5 (38%)
</td>
</tr>
<tr>
<td style="text-align:left;padding-left: 2em;" indentlevel="1">
unclear
</td>
<td style="text-align:center;">
1 (3.6%)
</td>
<td style="text-align:center;">
1 (7.7%)
</td>
</tr>
<tr>
<td style="text-align:left;">
hs
</td>
<td style="text-align:center;">
8 (29%)
</td>
<td style="text-align:center;">
3 (23%)
</td>
</tr>
</tbody>
<tfoot>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>1</sup> Mean±SD; n (%)
</td>
</tr>
</tfoot>
</table>

### Group differences in graph metrics

<table style="NAborder-bottom: 0; color: black; " class="table">
<thead>
<tr>
<th style="text-align:left;">
Functional connectivity metrics
</th>
<th style="text-align:center;">
Patient <br>N = 41
</th>
<th style="text-align:center;">
Healthy <br>N = 35
</th>
<th style="text-align:center;">
Statistic
</th>
<th style="text-align:center;">
p-value
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
fc.strength
</td>
<td style="text-align:center;">
250±79
</td>
<td style="text-align:center;">
243±49
</td>
<td style="text-align:center;">
0.478
</td>
<td style="text-align:center;">
0.6
</td>
</tr>
<tr>
<td style="text-align:left;">
fc.clustecoef
</td>
<td style="text-align:center;">
0.09±0.04
</td>
<td style="text-align:center;">
0.08±0.02
</td>
<td style="text-align:center;">
0.496
</td>
<td style="text-align:center;">
0.6
</td>
</tr>
<tr>
<td style="text-align:left;">
fc.efficiency
</td>
<td style="text-align:center;">
0.095±0.019
</td>
<td style="text-align:center;">
0.093±0.013
</td>
<td style="text-align:center;">
0.629
</td>
<td style="text-align:center;">
0.5
</td>
</tr>
<tr>
<td style="text-align:left;">
fc.pathlengh
</td>
<td style="text-align:center;">
12.13±2.03
</td>
<td style="text-align:center;">
12.31±1.82
</td>
<td style="text-align:center;">
-0.381
</td>
<td style="text-align:center;">
0.7
</td>
</tr>
<tr>
<td style="text-align:left;">
fc.neighbors
</td>
<td style="text-align:center;">
0.034±0.011
</td>
<td style="text-align:center;">
0.030±0.007
</td>
<td style="text-align:center;">
1.96
</td>
<td style="text-align:center;">
0.055
</td>
</tr>
<tr>
<td style="text-align:left;">
sc.strength
</td>
<td style="text-align:center;">
1.42±0.51
</td>
<td style="text-align:center;">
1.52±0.44
</td>
<td style="text-align:center;">
-0.875
</td>
<td style="text-align:center;">
0.4
</td>
</tr>
<tr>
<td style="text-align:left;">
sc.clustecoef
</td>
<td style="text-align:center;">
0.77±0.30
</td>
<td style="text-align:center;">
0.89±0.29
</td>
<td style="text-align:center;">
-1.63
</td>
<td style="text-align:center;">
0.11
</td>
</tr>
<tr>
<td style="text-align:left;">
sc.efficiency
</td>
<td style="text-align:center;">
0.60±0.19
</td>
<td style="text-align:center;">
0.63±0.17
</td>
<td style="text-align:center;">
-0.720
</td>
<td style="text-align:center;">
0.5
</td>
</tr>
<tr>
<td style="text-align:left;">
sc.pathlengh
</td>
<td style="text-align:center;">
0.28±0.24
</td>
<td style="text-align:center;">
0.29±0.22
</td>
<td style="text-align:center;">
-0.192
</td>
<td style="text-align:center;">
0.8
</td>
</tr>
<tr>
<td style="text-align:left;">
sc.neighbors
</td>
<td style="text-align:center;">
0.20±0.07
</td>
<td style="text-align:center;">
0.19±0.06
</td>
<td style="text-align:center;">
0.262
</td>
<td style="text-align:center;">
0.8
</td>
</tr>
</tbody>
<tfoot>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>1</sup> Mean±SD
</td>
</tr>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>2</sup> Welch Two Sample t-test
</td>
</tr>
</tfoot>
</table>

## Figure1.B \| Group Differences in MK-6240 SUVR

Violin plots display the mean SUVR values for significant regions in
each hemisphere by group, with significant differences assessed using a
two-tailed Wilcoxon rank-sum test.

![](figures/figure1b.ipsi-1.png)<!-- -->

## Figure1.C (supplementary) \| Group Differences in MK-6240 SUVR by sex.

## Figure.3A \| Tau MK-6240 SUVR and clinical relationships

Scatter plot display of the relationship of mean MK-6240 SUVR with
behavioral and clinical measures. Duration and age are measured in
*years*, while all the behavioral measurements where z-scores based in
the control group.

![](figures/figure3a-1.png)<!-- -->

## Correlation with IEDs and GTCS frequency

![](figures/figure3b-1.png)<!-- -->

## Figure.3B \| Tau MK-6240 SUVR and behavioural relationships

![](figures/figure3c-1.png)<!-- -->

## Figure.3C \| Tau MK-6240 SUVR and hippocampal volume

![](figures/figure3d-1.png)<!-- -->

## Supplementary Figure.4 \| Differential trajectories of *18F-MK6240*

Trajectories of $[F^18]MK-6240$ uptake by group between the PET scan
session 1 and 2 in the significant areas. The lines correspond to the
longitudinal subjects.

$$mk6240_{significant} \sim mk6240_{\Delta t} * group + (1 | participant_{id} )$$

![](figures/Supfigure4-1.png)<!-- -->

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: mk6240.sig ~ mk6240.Tdiff.yrs * group + (1 | participant_id)
    ##    Data: mk.df
    ## 
    ## REML criterion at convergence: -91.5
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -1.30332 -0.51253  0.01258  0.40999  1.57781 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  participant_id (Intercept) 0.013448 0.11597 
    ##  Residual                   0.003799 0.06163 
    ## Number of obs: 76, groups:  participant_id, 56
    ## 
    ## Fixed effects:
    ##                                Estimate Std. Error        df t value Pr(>|t|)
    ## (Intercept)                    1.112615   0.024741 58.236185  44.970  < 2e-16
    ## mk6240.Tdiff.yrs              -0.004382   0.014754 22.784809  -0.297    0.769
    ## groupPatient                   0.154756   0.035014 58.390867   4.420 4.35e-05
    ## mk6240.Tdiff.yrs:groupPatient  0.010438   0.022114 22.030772   0.472    0.642
    ##                                  
    ## (Intercept)                   ***
    ## mk6240.Tdiff.yrs                 
    ## groupPatient                  ***
    ## mk6240.Tdiff.yrs:groupPatient    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) mk6240.T. grpPtn
    ## mk6240.Tdf. -0.155                 
    ## groupPatint -0.707  0.109          
    ## mk6240.T.:P  0.103 -0.667    -0.192

    ##  group   mk6240.Tdiff.yrs.trend     SE   df lower.CL upper.CL
    ##  Healthy               -0.00438 0.0149 22.0  -0.0354   0.0266
    ##  Patient                0.00606 0.0166 20.7  -0.0285   0.0407
    ## 
    ## Degrees-of-freedom method: kenward-roger 
    ## Confidence level used: 0.95

No significant interaction (`mk6240.Tdiff.yrs:groupHealthy`, p = 0.769)
was found, suggesting that the rate of change in `mk6240.sig` over time
is not significantly different between the Healthy and Patient groups.

- **Healthy Group**: The estimated slope is `-0.00438` per year (95% CI:
  -0.0354 to 0.0266). This suggests a slight decrease in `mk6240.sig`
  over time, but the change is small and not statistically significant.

- **Patient Group**: The estimated slope is `0.00606` per year (95% CI:
  -0.0285 to 0.0407), indicating a slight increase in `mk6240.sig` over
  time, though this change is also not statistically significant.

There is no strong evidence that `mk6240.sig` changes over time in
either the Healthy or Patient groups, nor that the rate of change
differs significantly between them. However, the significant main effect
of group (p \< 0.001) suggests that `mk6240.sig` is, on average, lower
in the Healthy group compared to Patients.

# Linear mixed effects model of MK-6240 and clinical features

### Full model

$$\text{mk6240}_{\text{sig}} \sim \text{sex} * \text{group} + \text{age} + \text{DRE} + \text{ASM}_{\text{number}} + \text{origin} + \text{duration} + \text{hippocampus}_{\text{ipsi}} + (1 \,|\, \text{participant}_{\text{id}} )$$

### Full model

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: mk6240.sig ~ sex * group + age + dre + asm.number + origin +  
    ##     duration + hip.ipsi + sx.number + (1 | participant_id)
    ##    Data: mk.df
    ## 
    ## REML criterion at convergence: -60.4
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -1.27479 -0.44944 -0.01333  0.44685  1.49173 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  participant_id (Intercept) 0.012945 0.11378 
    ##  Residual                   0.003526 0.05938 
    ## Number of obs: 76, groups:  participant_id, 56
    ## 
    ## Fixed effects:
    ##                     Estimate Std. Error         df t value Pr(>|t|)    
    ## (Intercept)        1.1376106  0.0662276 46.5471196  17.177   <2e-16 ***
    ## sexM               0.1084086  0.0486369 45.0999299   2.229   0.0308 *  
    ## groupPatient       0.2083535  0.1354528 47.6219030   1.538   0.1306    
    ## age               -0.0024555  0.0018433 46.2281388  -1.332   0.1894    
    ## dreno              0.0254907  0.0751188 42.4719395   0.339   0.7360    
    ## asm.number        -0.0382203  0.0201366 44.4408981  -1.898   0.0642 .  
    ## originmTLE         0.0434539  0.1464635 46.6871263   0.297   0.7680    
    ## originTLE          0.0914823  0.1389360 47.3324093   0.658   0.5134    
    ## duration          -0.0002317  0.0024269 43.8557136  -0.095   0.9244    
    ## hip.ipsi          -0.0093854  0.0146005 43.0566202  -0.643   0.5238    
    ## sx.number          0.0257061  0.0668480 41.3840768   0.385   0.7025    
    ## sexM:groupPatient -0.1488841  0.0732232 44.0010140  -2.033   0.0481 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) sexM   grpPtn age    dreno  asm.nm orgnmTLE orignTLE duratn
    ## sexM        -0.219                                                            
    ## groupPatint -0.173  0.177                                                     
    ## age         -0.858 -0.166  0.048                                              
    ## dreno       -0.111 -0.026 -0.031  0.131                                       
    ## asm.number  -0.102 -0.029 -0.123  0.122  0.410                                
    ## originmTLE   0.114  0.021 -0.832 -0.132 -0.028  0.112                         
    ## originTLE    0.097  0.017 -0.858 -0.113  0.021 -0.027  0.908                  
    ## duration     0.190  0.033 -0.079 -0.220 -0.267 -0.277 -0.201   -0.182         
    ## hip.ipsi    -0.219  0.043  0.120  0.223 -0.020 -0.073 -0.041   -0.043   -0.086
    ## sx.number   -0.133 -0.014  0.043  0.150 -0.104 -0.270 -0.281   -0.073    0.145
    ## sxM:grpPtnt  0.099 -0.671 -0.115  0.164 -0.231 -0.141 -0.203   -0.178    0.221
    ##             hip.ps sx.nmb
    ## sexM                     
    ## groupPatint              
    ## age                      
    ## dreno                    
    ## asm.number               
    ## originmTLE               
    ## originTLE                
    ## duration                 
    ## hip.ipsi                 
    ## sx.number    0.165       
    ## sxM:grpPtnt  0.008  0.098
    ## fit warnings:
    ## fixed-effect model matrix is rank deficient so dropping 2 columns / coefficients

## Tuned model

$$\text{mk6240}_{\text{sig}} \sim \text{sex} * \text{group} + \text{age} + \text{ASM}_{\text{number}} + (1 \,|\, \text{participant}_{\text{id}} )$$

![](figures/lme-cli-tuned-1.png)<!-- -->

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: mk6240.sig ~ sex * group + age + asm.number + (1 | participant_id)
    ##    Data: mk.df
    ## 
    ## REML criterion at convergence: -89.3
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -1.30547 -0.47524 -0.02096  0.46864  1.58552 
    ## 
    ## Random effects:
    ##  Groups         Name        Variance Std.Dev.
    ##  participant_id (Intercept) 0.011443 0.10697 
    ##  Residual                   0.003551 0.05959 
    ## Number of obs: 76, groups:  participant_id, 56
    ## 
    ## Fixed effects:
    ##                    Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)        1.132107   0.059453 52.615095  19.042  < 2e-16 ***
    ## sexM               0.110408   0.046211 51.028554   2.389   0.0206 *  
    ## groupPatient       0.282843   0.051746 50.316905   5.466 1.44e-06 ***
    ## age               -0.002315   0.001630 52.356907  -1.420   0.1615    
    ## asm.number        -0.036142   0.015615 48.542674  -2.315   0.0249 *  
    ## sexM:groupPatient -0.141374   0.065595 49.463316  -2.155   0.0360 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) sexM   grpPtn age    asm.nm
    ## sexM        -0.239                            
    ## groupPatint -0.089  0.491                     
    ## age         -0.838 -0.171 -0.302              
    ## asm.number  -0.079 -0.016 -0.389  0.095       
    ## sxM:grpPtnt  0.083 -0.722 -0.678  0.222  0.015

# Subcortical MK-6240 SUVR analysis

<table style="NAborder-bottom: 0; color: black; " class="table">
<thead>
<tr>
<th style="text-align:left;">
Subcortical SUVR
</th>
<th style="text-align:center;">
Patient <br>N = 41
</th>
<th style="text-align:center;">
Healthy <br>N = 35
</th>
<th style="text-align:center;">
Statistic
</th>
<th style="text-align:center;">
p-value
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
ipsi.thalamus
</td>
<td style="text-align:center;">
0.15±0.98
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.673
</td>
<td style="text-align:center;">
0.5
</td>
</tr>
<tr>
<td style="text-align:left;">
ipsi.caudate
</td>
<td style="text-align:center;">
0.20±1.06
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.845
</td>
<td style="text-align:center;">
0.4
</td>
</tr>
<tr>
<td style="text-align:left;">
ipsi.putamen
</td>
<td style="text-align:center;">
0.33±1.14
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
1.34
</td>
<td style="text-align:center;">
0.2
</td>
</tr>
<tr>
<td style="text-align:left;">
ipsi.pallidus
</td>
<td style="text-align:center;">
0.22±1.12
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.895
</td>
<td style="text-align:center;">
0.4
</td>
</tr>
<tr>
<td style="text-align:left;">
ipsi.amygdala
</td>
<td style="text-align:center;">
0.26±1.31
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.972
</td>
<td style="text-align:center;">
0.3
</td>
</tr>
<tr>
<td style="text-align:left;">
ipsi.hippocampus
</td>
<td style="text-align:center;">
0.10±1.14
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.412
</td>
<td style="text-align:center;">
0.7
</td>
</tr>
<tr>
<td style="text-align:left;">
ipsi.accumbens
</td>
<td style="text-align:center;">
0.09±0.91
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.411
</td>
<td style="text-align:center;">
0.7
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.thalamus
</td>
<td style="text-align:center;">
0.28±0.92
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
1.27
</td>
<td style="text-align:center;">
0.2
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.caudate
</td>
<td style="text-align:center;">
0.19±0.94
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.870
</td>
<td style="text-align:center;">
0.4
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.putamen
</td>
<td style="text-align:center;">
0.34±0.96
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
1.50
</td>
<td style="text-align:center;">
0.14
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.pallidus
</td>
<td style="text-align:center;">
0.17±1.09
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.718
</td>
<td style="text-align:center;">
0.5
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.amygdala
</td>
<td style="text-align:center;">
0.30±1.03
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
1.28
</td>
<td style="text-align:center;">
0.2
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.hippocampus
</td>
<td style="text-align:center;">
-0.09±1.09
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
-0.370
</td>
<td style="text-align:center;">
0.7
</td>
</tr>
<tr>
<td style="text-align:left;">
cntr.accumbens
</td>
<td style="text-align:center;">
0.07±0.94
</td>
<td style="text-align:center;">
0.00±1.00
</td>
<td style="text-align:center;">
0.292
</td>
<td style="text-align:center;">
0.8
</td>
</tr>
</tbody>
<tfoot>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>1</sup> Mean±SD
</td>
</tr>
<tr>
<td style="padding: 0; " colspan="100%">
<sup>2</sup> Welch Two Sample t-test
</td>
</tr>
</tfoot>
</table>

## Subcortical data MEM

    ## Number of significant areas after p-value correction: 0

![](figures/sub.mem-1.png)<!-- -->

    ## Number of significant areas after p-value correction: 0

![](figures/sub-cli-1.png)<!-- -->

# Clinical database of patients

# Supplementary analysis:

![](figures/subgroup-tle-CohensD-1.png)<!-- -->

# Supplementary Figure.5 \| MK-6240, behavioral and graph metrics interactons

### MK-6240, behavioral and graph metrics correlogram

![](figures/all_corr-1.png)<!-- -->

# MK-6240, behavioral and graph metrics SEM

## SEM model for Epitrack

    ## lavaan 0.6-20 ended normally after 1 iteration
    ## 
    ##   Estimator                                         ML
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                         5
    ## 
    ##                                                   Used       Total
    ##   Number of observations                            55          56
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                 0.000
    ##   Degrees of freedom                                 0
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                                17.487
    ##   Degrees of freedom                                 3
    ##   P-value                                        0.001
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    1.000
    ##   Tucker-Lewis Index (TLI)                       1.000
    ## 
    ## Loglikelihood and Information Criteria:
    ## 
    ##   Loglikelihood user model (H0)                 -9.132
    ##   Loglikelihood unrestricted model (H1)         -9.132
    ##                                                       
    ##   Akaike (AIC)                                  28.263
    ##   Bayesian (BIC)                                38.300
    ##   Sample-size adjusted Bayesian (SABIC)         22.588
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.000
    ##   90 Percent confidence interval - lower         0.000
    ##   90 Percent confidence interval - upper         0.000
    ##   P-value H_0: RMSEA <= 0.050                       NA
    ##   P-value H_0: RMSEA >= 0.080                       NA
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.000
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                            Bootstrap
    ##   Number of requested bootstrap draws             1000
    ##   Number of successful bootstrap draws             998
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   sc.neighbors ~                                                        
    ##     mk6240.    (a)    0.150    0.056    2.672    0.008    0.150    0.331
    ##   EpiTrack ~                                                            
    ##     sc.nghb    (b)    6.185    2.408    2.568    0.010    6.185    0.330
    ##     mk6240. (c_pr)   -3.408    1.225   -2.782    0.005   -3.408   -0.402
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sc.neighbors      0.004    0.001    6.278    0.000    0.004    0.890
    ##    .EpiTrack          1.242    0.270    4.599    0.000    1.242    0.817
    ## 
    ## Defined Parameters:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     indirect          0.926    0.499    1.854    0.064    0.926    0.109
    ##     total            -2.482    1.203   -2.062    0.039   -2.482   -0.293

<div class="grViz html-widget html-fill-item" id="htmlwidget-ea4ad505e4d889c9628d" style="width:960px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-ea4ad505e4d889c9628d">{"x":{"diagram":" digraph plot { \n graph [ overlap = true, fontsize = 10 ] \n node [ shape = box ] \n node [shape = box] \n mk6240sig; scneighbors; EpiTrack \n node [shape = oval] \n  \n \n edge [ color = black ] \n mk6240sig->scneighbors [label = \"0.33\"] scneighbors->EpiTrack [label = \"0.33\"] mk6240sig->EpiTrack [label = \"-0.4\"]  \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

## SEM model for Episodic Memory

    ## lavaan 0.6-20 ended normally after 1 iteration
    ## 
    ##   Estimator                                         ML
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                         5
    ## 
    ##                                                   Used       Total
    ##   Number of observations                            48          56
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                 0.000
    ##   Degrees of freedom                                 0
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                                12.186
    ##   Degrees of freedom                                 3
    ##   P-value                                        0.007
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    1.000
    ##   Tucker-Lewis Index (TLI)                       1.000
    ## 
    ## Loglikelihood and Information Criteria:
    ## 
    ##   Loglikelihood user model (H0)                -10.598
    ##   Loglikelihood unrestricted model (H1)        -10.598
    ##                                                       
    ##   Akaike (AIC)                                  31.195
    ##   Bayesian (BIC)                                40.551
    ##   Sample-size adjusted Bayesian (SABIC)         24.865
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.000
    ##   90 Percent confidence interval - lower         0.000
    ##   90 Percent confidence interval - upper         0.000
    ##   P-value H_0: RMSEA <= 0.050                       NA
    ##   P-value H_0: RMSEA >= 0.080                       NA
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.000
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                            Bootstrap
    ##   Number of requested bootstrap draws             1000
    ##   Number of successful bootstrap draws             998
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   sc.neighbors ~                                                        
    ##     mk6240.    (a)    0.167    0.052    3.212    0.001    0.167    0.367
    ##   Episodic ~                                                            
    ##     sc.nghb    (b)   -0.132    3.016   -0.044    0.965   -0.132   -0.007
    ##     mk6240. (c_pr)   -2.658    1.206   -2.204    0.028   -2.658   -0.318
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sc.neighbors      0.004    0.001    6.211    0.000    0.004    0.865
    ##    .Episodic          1.366    0.211    6.466    0.000    1.366    0.897
    ## 
    ## Defined Parameters:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     indirect         -0.022    0.530   -0.041    0.967   -0.022   -0.003
    ##     total            -2.680    1.079   -2.483    0.013   -2.680   -0.321

<div class="grViz html-widget html-fill-item" id="htmlwidget-d5d7456f7d046e6c35b7" style="width:960px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-d5d7456f7d046e6c35b7">{"x":{"diagram":" digraph plot { \n graph [ overlap = true, fontsize = 10 ] \n node [ shape = box ] \n node [shape = box] \n mk6240sig; scneighbors; Episodic \n node [shape = oval] \n  \n \n edge [ color = black ] \n mk6240sig->scneighbors [label = \"0.37\"] scneighbors->Episodic [label = \"\"] mk6240sig->Episodic [label = \"-0.32\"]  \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

## SEM model for Semantic Memory

    ## lavaan 0.6-20 ended normally after 1 iteration
    ## 
    ##   Estimator                                         ML
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                         5
    ## 
    ##                                                   Used       Total
    ##   Number of observations                            47          56
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                 0.000
    ##   Degrees of freedom                                 0
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                                 9.791
    ##   Degrees of freedom                                 3
    ##   P-value                                        0.020
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    1.000
    ##   Tucker-Lewis Index (TLI)                       1.000
    ## 
    ## Loglikelihood and Information Criteria:
    ## 
    ##   Loglikelihood user model (H0)                  3.042
    ##   Loglikelihood unrestricted model (H1)          3.042
    ##                                                       
    ##   Akaike (AIC)                                   3.916
    ##   Bayesian (BIC)                                13.167
    ##   Sample-size adjusted Bayesian (SABIC)         -2.515
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.000
    ##   90 Percent confidence interval - lower         0.000
    ##   90 Percent confidence interval - upper         0.000
    ##   P-value H_0: RMSEA <= 0.050                       NA
    ##   P-value H_0: RMSEA >= 0.080                       NA
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.000
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                            Bootstrap
    ##   Number of requested bootstrap draws             1000
    ##   Number of successful bootstrap draws             997
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   sc.neighbors ~                                                        
    ##     mk6240.    (a)    0.180    0.054    3.314    0.001    0.180    0.394
    ##   Semantic ~                                                            
    ##     sc.nghb    (b)    2.549    2.262    1.127    0.260    2.549    0.193
    ##     mk6240. (c_pr)    0.059    1.232    0.048    0.962    0.059    0.010
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sc.neighbors      0.004    0.001    6.462    0.000    0.004    0.845
    ##    .Semantic          0.771    0.307    2.510    0.012    0.771    0.961
    ## 
    ## Defined Parameters:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     indirect          0.458    0.425    1.077    0.281    0.458    0.076
    ##     total             0.517    1.005    0.514    0.607    0.517    0.086

<div class="grViz html-widget html-fill-item" id="htmlwidget-7519a872985736de035f" style="width:960px;height:576px;"></div>
<script type="application/json" data-for="htmlwidget-7519a872985736de035f">{"x":{"diagram":" digraph plot { \n graph [ overlap = true, fontsize = 10 ] \n node [ shape = box ] \n node [shape = box] \n mk6240sig; scneighbors; Semantic \n node [shape = oval] \n  \n \n edge [ color = black ] \n mk6240sig->scneighbors [label = \"0.39\"] scneighbors->Semantic [label = \"\"] mk6240sig->Semantic [label = \"\"]  \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

### Full SEM model with multiple mediators and outcomes

> Note: for rendering purposes the number of booststraps was set to
> 1000, but the final version was run with 10000 for a stable estimates
> of the indirect effects.

    ## lavaan 0.6-20 ended normally after 40 iterations
    ## 
    ##   Estimator                                         ML
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                        20
    ## 
    ##                                                   Used       Total
    ##   Number of observations                            44          56
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                 0.000
    ##   Degrees of freedom                                 0
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                               148.425
    ##   Degrees of freedom                                15
    ##   P-value                                        0.000
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    1.000
    ##   Tucker-Lewis Index (TLI)                       1.000
    ## 
    ## Loglikelihood and Information Criteria:
    ## 
    ##   Loglikelihood user model (H0)                -59.515
    ##   Loglikelihood unrestricted model (H1)        -59.515
    ##                                                       
    ##   Akaike (AIC)                                 159.030
    ##   Bayesian (BIC)                               194.714
    ##   Sample-size adjusted Bayesian (SABIC)        132.042
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.000
    ##   90 Percent confidence interval - lower         0.000
    ##   90 Percent confidence interval - upper         0.000
    ##   P-value H_0: RMSEA <= 0.050                       NA
    ##   P-value H_0: RMSEA >= 0.080                       NA
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.000
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                            Bootstrap
    ##   Number of requested bootstrap draws             1000
    ##   Number of successful bootstrap draws             991
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   sc.neighbors ~                                                        
    ##     mk6240.s  (a1)    0.170    0.056    3.043    0.002    0.170    0.378
    ##   sc.efficiency ~                                                       
    ##     mk6240.s  (a2)    0.053    0.167    0.317    0.752    0.053    0.045
    ##   EpiTrack ~                                                            
    ##     sc.nghbr (b11)    9.942    8.800    1.130    0.259    9.942    0.534
    ##     sc.ffcnc (b12)   -1.919    3.284   -0.584    0.559   -1.919   -0.267
    ##     mk6240.s  (c1)   -4.078    1.570   -2.597    0.009   -4.078   -0.486
    ##   Episodic ~                                                            
    ##     sc.nghbr (b21)   10.619   10.288    1.032    0.302   10.619    0.586
    ##     sc.ffcnc (b22)   -3.974    3.667   -1.084    0.279   -3.974   -0.567
    ##     mk6240.s  (c2)   -4.509    1.505   -2.996    0.003   -4.509   -0.552
    ##   Semantic ~                                                            
    ##     sc.nghbr (b31)    7.570    5.922    1.278    0.201    7.570    0.567
    ##     sc.ffcnc (b32)   -1.957    1.855   -1.055    0.291   -1.957   -0.379
    ##     mk6240.s  (c3)   -0.835    1.390   -0.601    0.548   -0.835   -0.139
    ## 
    ## Covariances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##  .sc.neighbors ~~                                                       
    ##    .sc.efficiency     0.011    0.002    6.064    0.000    0.011    0.954
    ##  .EpiTrack ~~                                                           
    ##    .Episodic          0.496    0.189    2.627    0.009    0.496    0.373
    ##    .Semantic          0.523    0.166    3.141    0.002    0.523    0.501
    ##  .Episodic ~~                                                           
    ##    .Semantic          0.192    0.128    1.496    0.135    0.192    0.189
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sc.neighbors      0.004    0.001    6.220    0.000    0.004    0.857
    ##    .sc.efficiency     0.031    0.005    6.061    0.000    0.031    0.998
    ##    .EpiTrack          1.369    0.350    3.915    0.000    1.369    0.848
    ##    .Episodic          1.293    0.208    6.214    0.000    1.293    0.844
    ##    .Semantic          0.797    0.324    2.458    0.014    0.797    0.957
    ## 
    ## Defined Parameters:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     ind_Eptrck_ngh    1.694    1.656    1.023    0.306    1.694    0.202
    ##     ind_Eptrck_ffc   -0.101    0.686   -0.148    0.883   -0.101   -0.012
    ##     ind_Eptrck_ttl    1.592    1.286    1.238    0.216    1.592    0.190
    ##     ind_Epsdc_nghb    1.809    1.952    0.927    0.354    1.809    0.221
    ##     ind_Epsdc_ffcn   -0.210    0.965   -0.217    0.828   -0.210   -0.026
    ##     ind_Episdc_ttl    1.600    1.558    1.026    0.305    1.600    0.196
    ##     ind_Smntc_nghb    1.290    1.069    1.206    0.228    1.290    0.214
    ##     ind_Smntc_ffcn   -0.103    0.454   -0.228    0.820   -0.103   -0.017
    ##     ind_Semntc_ttl    1.186    0.900    1.318    0.188    1.186    0.197
    ##     total_Epitrack   -2.486    1.341   -1.854    0.064   -2.486   -0.296
    ##     total_Episodic   -2.910    1.046   -2.782    0.005   -2.910   -0.356
    ##     total_Semantic    0.351    1.029    0.341    0.733    0.351    0.058

<div class="grViz html-widget html-fill-item" id="htmlwidget-e2386d90480017c4f766" style="width:960px;height:288px;"></div>
<script type="application/json" data-for="htmlwidget-e2386d90480017c4f766">{"x":{"diagram":" digraph plot { \n graph [ overlap = true, fontsize = 10 ] \n node [ shape = box ] \n node [shape = box] \n mk6240sig; scneighbors; scefficiency; EpiTrack; Episodic; Semantic \n node [shape = oval] \n  \n \n edge [ color = black ] \n mk6240sig->scneighbors [label = \"0.38\"] mk6240sig->scefficiency [label = \"\"] scneighbors->EpiTrack [label = \"\"] scefficiency->EpiTrack [label = \"\"] mk6240sig->EpiTrack [label = \"-0.49\"] scneighbors->Episodic [label = \"\"] scefficiency->Episodic [label = \"\"] mk6240sig->Episodic [label = \"-0.55\"] scneighbors->Semantic [label = \"\"] scefficiency->Semantic [label = \"\"] mk6240sig->Semantic [label = \"\"]  \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

### Full SEM model with multiple mediators and outcomes and ipsilateralhippocampal volume

    ## lavaan 0.6-20 ended normally after 43 iterations
    ## 
    ##   Estimator                                         ML
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                        27
    ## 
    ##                                                   Used       Total
    ##   Number of observations                            44          56
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                                 0.000
    ##   Degrees of freedom                                 0
    ## 
    ## Model Test Baseline Model:
    ## 
    ##   Test statistic                               156.826
    ##   Degrees of freedom                                21
    ##   P-value                                        0.000
    ## 
    ## User Model versus Baseline Model:
    ## 
    ##   Comparative Fit Index (CFI)                    1.000
    ##   Tucker-Lewis Index (TLI)                       1.000
    ## 
    ## Loglikelihood and Information Criteria:
    ## 
    ##   Loglikelihood user model (H0)               -121.676
    ##   Loglikelihood unrestricted model (H1)       -121.676
    ##                                                       
    ##   Akaike (AIC)                                 297.352
    ##   Bayesian (BIC)                               345.525
    ##   Sample-size adjusted Bayesian (SABIC)        260.918
    ## 
    ## Root Mean Square Error of Approximation:
    ## 
    ##   RMSEA                                          0.000
    ##   90 Percent confidence interval - lower         0.000
    ##   90 Percent confidence interval - upper         0.000
    ##   P-value H_0: RMSEA <= 0.050                       NA
    ##   P-value H_0: RMSEA >= 0.080                       NA
    ## 
    ## Standardized Root Mean Square Residual:
    ## 
    ##   SRMR                                           0.000
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                            Bootstrap
    ##   Number of requested bootstrap draws             1000
    ##   Number of successful bootstrap draws             992
    ## 
    ## Regressions:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   sc.neighbors ~                                                        
    ##     mk6240.s  (a1)    0.170    0.056    3.042    0.002    0.170    0.378
    ##   sc.efficiency ~                                                       
    ##     mk6240.s  (a2)    0.053    0.167    0.317    0.752    0.053    0.045
    ##   hip.ipsi ~                                                            
    ##     mk6240.s  (a3)   -2.266    1.160   -1.954    0.051   -2.266   -0.314
    ##   EpiTrack ~                                                            
    ##     sc.nghbr (b11)    8.915    9.928    0.898    0.369    8.915    0.479
    ##     sc.ffcnc (b12)   -1.482    3.817   -0.388    0.698   -1.482   -0.206
    ##     hip.ipsi (b13)    0.088    0.212    0.414    0.679    0.088    0.076
    ##     mk6240.s  (c1)   -3.727    1.765   -2.112    0.035   -3.727   -0.444
    ##   Episodic ~                                                            
    ##     sc.nghbr (b21)    9.510   10.716    0.887    0.375    9.510    0.525
    ##     sc.ffcnc (b22)   -3.502    3.949   -0.887    0.375   -3.502   -0.500
    ##     hip.ipsi (b23)    0.095    0.195    0.487    0.626    0.095    0.084
    ##     mk6240.s  (c2)   -4.130    1.792   -2.304    0.021   -4.130   -0.506
    ##   Semantic ~                                                            
    ##     sc.nghbr (b31)    6.897    6.232    1.107    0.268    6.897    0.516
    ##     sc.ffcnc (b32)   -1.671    2.057   -0.812    0.417   -1.671   -0.324
    ##     hip.ipsi (b33)    0.058    0.113    0.511    0.609    0.058    0.069
    ##     mk6240.s  (c3)   -0.605    1.306   -0.463    0.643   -0.605   -0.100
    ## 
    ## Covariances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##  .sc.neighbors ~~                                                       
    ##    .sc.efficiency     0.011    0.002    6.077    0.000    0.011    0.954
    ##    .hip.ipsi         -0.006    0.009   -0.717    0.474   -0.006   -0.095
    ##  .sc.efficiency ~~                                                      
    ##    .hip.ipsi         -0.031    0.023   -1.332    0.183   -0.031   -0.167
    ##  .EpiTrack ~~                                                           
    ##    .Episodic          0.488    0.183    2.667    0.008    0.488    0.369
    ##    .Semantic          0.518    0.169    3.070    0.002    0.518    0.498
    ##  .Episodic ~~                                                           
    ##    .Semantic          0.186    0.132    1.412    0.158    0.186    0.185
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .sc.neighbors      0.004    0.001    6.226    0.000    0.004    0.857
    ##    .sc.efficiency     0.031    0.005    6.078    0.000    0.031    0.998
    ##    .hip.ipsi          1.078    0.277    3.884    0.000    1.078    0.901
    ##    .EpiTrack          1.362    0.322    4.235    0.000    1.362    0.843
    ##    .Episodic          1.284    0.204    6.310    0.000    1.284    0.838
    ##    .Semantic          0.793    0.324    2.447    0.014    0.793    0.953
    ## 
    ## Defined Parameters:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##     ind_Eptrck_ngh    1.519    1.874    0.810    0.418    1.519    0.181
    ##     ind_Eptrck_ffc   -0.078    0.789   -0.099    0.921   -0.078   -0.009
    ##     ind_Eptrck_hp_   -0.199    0.538   -0.370    0.712   -0.199   -0.024
    ##     ind_Eptrck_ttl    1.242    1.694    0.733    0.464    1.242    0.148
    ##     ind_Epsdc_nghb    1.620    2.057    0.788    0.431    1.620    0.198
    ##     ind_Epsdc_ffcn   -0.185    1.005   -0.184    0.854   -0.185   -0.023
    ##     ind_Epsdc_hp_p   -0.215    0.518   -0.415    0.678   -0.215   -0.026
    ##     ind_Episdc_ttl    1.220    1.779    0.686    0.493    1.220    0.149
    ##     ind_Smntc_nghb    1.175    1.125    1.045    0.296    1.175    0.195
    ##     ind_Smntc_ffcn   -0.088    0.461   -0.191    0.848   -0.088   -0.015
    ##     ind_Smntc_hp_p   -0.130    0.258   -0.505    0.614   -0.130   -0.022
    ##     ind_Semntc_ttl    0.957    0.986    0.970    0.332    0.957    0.159
    ##     total_Epitrack   -2.486    1.345   -1.848    0.065   -2.486   -0.296
    ##     total_Episodic   -2.910    1.048   -2.777    0.005   -2.910   -0.356
    ##     total_Semantic    0.351    1.029    0.341    0.733    0.351    0.058

<div class="grViz html-widget html-fill-item" id="htmlwidget-eae8574c146370dabeb8" style="width:960px;height:288px;"></div>
<script type="application/json" data-for="htmlwidget-eae8574c146370dabeb8">{"x":{"diagram":" digraph plot { \n graph [ overlap = true, fontsize = 10 ] \n node [ shape = box ] \n node [shape = box] \n mk6240sig; scneighbors; scefficiency; hipipsi; EpiTrack; Episodic; Semantic \n node [shape = oval] \n  \n \n edge [ color = black ] \n mk6240sig->scneighbors [label = \"0.38\"] mk6240sig->scefficiency [label = \"\"] mk6240sig->hipipsi [label = \"\"] scneighbors->EpiTrack [label = \"\"] scefficiency->EpiTrack [label = \"\"] hipipsi->EpiTrack [label = \"\"] mk6240sig->EpiTrack [label = \"-0.44\"] scneighbors->Episodic [label = \"\"] scefficiency->Episodic [label = \"\"] hipipsi->Episodic [label = \"\"] mk6240sig->Episodic [label = \"-0.51\"] scneighbors->Semantic [label = \"\"] scefficiency->Semantic [label = \"\"] hipipsi->Semantic [label = \"\"] mk6240sig->Semantic [label = \"\"]  \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
