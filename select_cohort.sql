with temp as 
(SELECT c.patientunitstayid, a.admitdxname 
FROM admissiondx a INNER JOIN public.mp_cohort c
ON a.patientunitstayid = c.patientunitstayid 
WHERE a.admitdxname like 'Sepsis%' and a.admitdxenteredoffset < 240 and c.exclusion_non_adult = 0 AND c.exclusion_secondary_icu_stay =0 and exclusion_by_apache =0
order by patientunitstayid)
SELECT t.patientunitstayid, t.admitdxname, b.age, b.unittype, b.gender,i.ethnicity, b.hosp_mortality, b.icu_mortality, b.icu_los_hours,s.sofa, i.apache_iv, i.admissionheight, i.admissionweight,l.rdw, l.mch, l.mchc, l.aniongap, 
l.albumin, l.bands, l.bicarbonate, l.hco3, l.bilirubin, l.creatinine, l.chloride,
l.glucose, l.hematocrit, l.hemoglobin, l.lactate, l.platelet, l.potassium, l.ptt, l.inr, l.pt, 
l.sodium, l.bun, l.wbc, cast(v.heartrate as INT) as hr, cast(v.respiratoryrate as INT) as r,
cast(v.spo2 as INT) as spo2, cast(v.nibp_systolic as INT) as sbp, cast(v.nibp_diastolic as INT) as dbp, cast(v.temperature as FLOAT) as t
FROM temp t INNER JOIN basic b
on t.patientunitstayid = b.patientunitstayid
INNER JOIN sofa s
on t.patientunitstayid = s.patientunitstayid
INNER JOIN icustay_detail i
on t.patientunitstayid = i.patientunitstayid
INNER JOIN firstlabs l
ON b.patientunitstayid = l.patientunitstayid
left JOIN firstvitals v
ON b.patientunitstayid = v.patientunitstayid
where b.icu_los_hours >= 4 AND b.icu_mortality IS NOT NULL and b.age != '> 89' and s.sofa >1 and b.gender IS NOT NULL AND l.rdw is not null
AND b.hosp_mortality IS NOT NULL 
order by t.patientunitstayid 