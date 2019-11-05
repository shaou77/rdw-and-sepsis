DROP MATERIALIZED VIEW
IF
	EXISTS firstvitals CASCADE;
CREATE MATERIALIZED VIEW firstvitals AS WITH hr AS (
	WITH th AS ( SELECT patientunitstayid, chartoffset, heartrate FROM "pivoted_vital" WHERE heartrate IS NOT NULL AND chartoffset >= - 60 ),
	minth AS ( SELECT patientunitstayid, MIN ( chartoffset ) min1 FROM th GROUP BY patientunitstayid ) SELECT
	th.patientunitstayid,
	th.chartoffset,
	th.heartrate 
	FROM
		th,
		minth 
	WHERE
		th.patientunitstayid = minth.patientunitstayid 
		AND th.chartoffset = minth.min1 
	),
	R AS (
		WITH tr AS ( SELECT patientunitstayid, chartoffset, respiratoryrate FROM "pivoted_vital" WHERE respiratoryrate IS NOT NULL AND chartoffset >= - 60 ),
		mintr AS ( SELECT patientunitstayid, MIN ( chartoffset ) min2 FROM tr GROUP BY patientunitstayid ) SELECT
		tr.patientunitstayid,
		tr.chartoffset,
		tr.respiratoryrate 
	FROM
		tr,
		mintr 
	WHERE
		tr.patientunitstayid = mintr.patientunitstayid 
		AND tr.chartoffset = mintr.min2 
	),
	spo2 AS (
		WITH tsp AS ( SELECT patientunitstayid, chartoffset, spo2 FROM "pivoted_vital" WHERE spo2 IS NOT NULL AND chartoffset >= - 60 ),
		mintsp AS ( SELECT patientunitstayid, MIN ( chartoffset ) min3 FROM tsp GROUP BY patientunitstayid ) SELECT
		tsp.patientunitstayid,
		tsp.chartoffset,
		tsp.spo2 
	FROM
		tsp,
		mintsp 
	WHERE
		tsp.patientunitstayid = mintsp.patientunitstayid 
		AND tsp.chartoffset = mintsp.min3 
	),
	bp AS (
		WITH tbp AS ( SELECT patientunitstayid, chartoffset, nibp_systolic, nibp_diastolic FROM "pivoted_vital" WHERE nibp_diastolic IS NOT NULL AND chartoffset >= - 60 ),
		mintbp AS ( SELECT patientunitstayid, MIN ( chartoffset ) min4 FROM tbp GROUP BY patientunitstayid ) SELECT
		tbp.patientunitstayid,
		tbp.chartoffset,
		tbp.nibp_systolic,
		tbp.nibp_diastolic 
	FROM
		tbp,
		mintbp 
	WHERE
		tbp.patientunitstayid = mintbp.patientunitstayid 
		AND tbp.chartoffset = mintbp.min4 
	),
	T AS (
		WITH tt AS ( SELECT patientunitstayid, chartoffset, temperature FROM "pivoted_vital" WHERE temperature IS NOT NULL AND chartoffset >= - 60 ),
		mint AS ( SELECT patientunitstayid, MIN ( chartoffset ) min5 FROM tt GROUP BY patientunitstayid ) SELECT
		tt.patientunitstayid,
		tt.chartoffset,
		tt.temperature 
	FROM
		tt,
		mint 
	WHERE
		tt.patientunitstayid = mint.patientunitstayid 
		AND tt.chartoffset = mint.min5 
	) SELECT
	hr.patientunitstayid,
	hr.heartrate,
	r.respiratoryrate,
	spo2.spo2,
	bp.nibp_systolic,
	bp.nibp_diastolic,
	T.temperature 
FROM
	hr
	FULL OUTER JOIN r ON hr.patientunitstayid = r.patientunitstayid
	FULL OUTER JOIN spo2 ON hr.patientunitstayid = spo2.patientunitstayid
	FULL OUTER JOIN bp ON hr.patientunitstayid = bp.patientunitstayid
	FULL OUTER JOIN T ON hr.patientunitstayid = T.patientunitstayid