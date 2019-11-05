DROP MATERIALIZED VIEW IF EXISTS firstlabs CASCADE;
CREATE materialized VIEW firstlabs AS

with
lab1 as (SELECT * from lab 
where labresultoffset <= 1440 ),
temp as
(select *, (row_number() over(partition by lab1.patientUnitStayID, lab1.labname order by lab1.labResultOffset )) as rn from lab1
),
first as
(select * from temp
where rn =1
order by patientunitstayid)
SELECT
  pvt.uniquepid, pvt.patienthealthsystemstayid, pvt.patientunitstayid
	 ,max(CASE WHEN labname = 'RDW' THEN labresult ELSE null END) as RDW
	,max(CASE WHEN labname = 'MCV' THEN labresult ELSE null END) as MCV
	,max(CASE WHEN labname = 'MCH' THEN labresult ELSE null END) as MCH
	,max(CASE WHEN labname = 'MCHC' THEN labresult ELSE null END) as MCHC
	,max(CASE WHEN labname = 'anion gap' THEN labresult ELSE null END) as ANIONGAP
  , max(CASE WHEN labname = 'albumin' THEN labresult ELSE null END) as ALBUMIN
  , max(CASE WHEN labname = '-bands' THEN labresult ELSE null END) as BANDS
  , max(CASE WHEN labname = 'bicarbonate' THEN labresult ELSE null END) as BICARBONATE
  , max(CASE WHEN labname = 'HCO3' THEN labresult ELSE null END) as HCO3 
   , max(CASE WHEN labname = 'total bilirubin' THEN labresult ELSE null END) as BILIRUBIN
  , max(CASE WHEN labname = 'creatinine' THEN labresult ELSE null END) as CREATININE
  , max(CASE WHEN labname = 'chloride' THEN labresult ELSE null END) as CHLORIDE
  , max(CASE WHEN labname = 'glucose' THEN labresult ELSE null END) as GLUCOSE
  , max(CASE WHEN labname = 'Hct' THEN labresult ELSE null END) as HEMATOCRIT
  , max(CASE WHEN labname = 'Hgb' THEN labresult ELSE null END) as HEMOGLOBIN
  , max(CASE WHEN labname = 'lactate' THEN labresult ELSE null END) as LACTATE
 , max(CASE WHEN labname = 'platelets x 1000' THEN labresult ELSE null END) as PLATELET
  , max(CASE WHEN labname = 'potassium' THEN labresult ELSE null END) as POTASSIUM
  , max(CASE WHEN labname = 'PTT' THEN labresult ELSE null END) as PTT
  , max(CASE WHEN labname = 'PT - INR' THEN labresult ELSE null END) as INR
  , max(CASE WHEN labname = 'PT' THEN labresult ELSE null END) as PT
  , max(CASE WHEN labname = 'sodium' THEN labresult ELSE null END) as SODIUM
  , max(CASE WHEN labname = 'BUN' THEN labresult ELSE null END) as BUN
  , max(CASE WHEN labname = 'WBC x 1000' THEN labresult ELSE null END) as WBC
  FROM
( SELECT p.uniquepid, p.patienthealthsystemstayid, p.patientunitstayid, le.labname
  , CASE
		 WHEN labname = 'RDW' and le.labresult > 100 THEN null
     WHEN labname = 'albumin' and le.labresult >    10 THEN null -- g/dL 'ALBUMIN'
     WHEN labname = 'anion gap' and le.labresult > 10000 THEN null -- mEq/L 'ANION GAP'
     WHEN labname = '-bands' and le.labresult <     0 THEN null -- immature band forms, %
     WHEN labname = '-bands' and le.labresult >   100 THEN null -- immature band forms, %
     WHEN labname = 'bicarbonate' and le.labresult > 10000 THEN null -- mEq/L 'BICARBONATE'
     WHEN labname = 'HCO3' and le.labresult > 10000 THEN null -- mEq/L 'BICARBONATE'
     WHEN labname = 'bilirubin' and le.labresult >   150 THEN null -- mg/dL 'BILIRUBIN'
     WHEN labname = 'chloride' and le.labresult > 10000 THEN null -- mEq/L 'CHLORIDE'
     WHEN labname = 'creatinine' and le.labresult >   150 THEN null -- mg/dL 'CREATININE'
     WHEN labname = 'glucose' and le.labresult > 10000 THEN null -- mg/dL 'GLUCOSE'
     WHEN labname = 'Hct' and le.labresult >   100 THEN null -- % 'HEMATOCRIT'
     WHEN labname = 'Hgb' and le.labresult >    50 THEN null -- g/dL 'HEMOGLOBIN'
     WHEN labname = 'lactate' and le.labresult >    50 THEN null -- mmol/L 'LACTATE'
     WHEN labname = 'platelets x 1000' and le.labresult > 10000 THEN null -- K/uL 'PLATELET'
     WHEN labname = 'potassium' and le.labresult >    30 THEN null -- mEq/L 'POTASSIUM'
     WHEN labname = 'PTT' and le.labresult >   150 THEN null -- sec 'PTT'
     WHEN labname = 'PT - INR' and le.labresult >    50 THEN null -- 'INR'
     WHEN labname = 'PT' and le.labresult >   150 THEN null -- sec 'PT'
     WHEN labname = 'sodium' and le.labresult >   200 THEN null -- mEq/L == mmol/L 'SODIUM'
     WHEN labname = 'BUN' and le.labresult >   300 THEN null -- 'BUN'
     WHEN labname = 'WBC x 1000' and le.labresult >  1000 THEN null -- 'WBC'
   ELSE le.labresult
   END AS labresult
  FROM patient p
  LEFT JOIN first le
    ON p.patientunitstayid = le.patientunitstayid
    AND le.labname in
    ( 'RDW',
      'MCV',
	    'MCH',
			'MCHC',
    	'anion gap',
    	'albumin',
    	'-bands',
    	'bicarbonate',
    	'HCO3',
    	'total bilirubin',
    	'creatinine',
    	'chloride',
    	'glucose',
    	'Hct',
    	'Hgb',
    	'lactate',
    	'platelets x 1000',
    	'potassium',
    	'PTT',
    	'PT - INR',
    	'PT',
    	'sodium',
    	'BUN',
    	'WBC x 1000'
    )
    AND labresult IS NOT null AND labresult > 0 
		) pvt
GROUP BY pvt.uniquepid, pvt.patienthealthsystemstayid, pvt.patientunitstayid