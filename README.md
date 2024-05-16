# rdw-and-sepsis
Association Between Red Cell Distribution Width and Hospital Mortality in Patients with Sepsis
DOI: 10.1177/03000605211004221

They were my code for the extraction data in eICU-CRD database and statistical analysis in R. It was also my first project so the code maybe a little disorder. I learned a lot in this writing, and I will improve it next time.
Thanks for Alistair Johnson(@mit-lcp).
Follow these steps.

### 1. Request access to the eICU Collaborative Research Database(https://eicu-crd.mit.edu/gettingstarted/access/), download the database to your computer and install it.(Follow the instruction of https://github.com/MIT-LCP/eicu-code/tree/master/build-db/postgres)

### 2. run the sql code in the eicu github respiratory:(https://github.com/mit-lcp/eicu-code)
\i ../eicu-code/concepts/pivoted/pivoted-bg.sql

\i ../eicu-code/concepts/pivoted/pivoted-infusion.sql

\i ../eicu-code/concepts/pivoted/pivoted-lab.sql

\i ../eicu-code/concepts/pivoted/pivoted-med.sql

\i ../eicu-code/concepts/pivoted/pivoted-o2.sql

\i ../eicu-code/concepts/pivoted/pivoted-score.sql

\i ../eicu-code/concepts/pivoted/pivoted-treatment-vasopressor.sql

\i ../eicu-code/concepts/pivoted/pivoted-uo.sql

\i ../eicu-code/concepts/pivoted/pivoted-vital-other.sql

\i ../eicu-code/concepts/pivoted/pivoted-vital.sql

\i ../eicu-code/concepts/neuroblock.sql

### 3.run the cohort sql code(https://github.com/alistairewj/mechanical-power/blob/master/eicu/cohort.sql)

### 4.run the first_firstlabs.sql to get the first lab results in the patients' ICU admissions.

### 5.run the first_firstvitals.sql to get the first vital signs recorded after the ICU admissions.

### 6.run the select_cohort.sql to get the cohort fufilled the criteria.

### 7.then you get the cohort data file, I name it by 'sepsis.csv'

### 8.statistic analyze it with R.R in R software(I used 3.6.1)

### Finish 
