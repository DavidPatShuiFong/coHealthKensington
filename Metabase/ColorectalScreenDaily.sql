SELECT Surname, Firstname, DOB
FROM BPS_Patients

WHERE StatusText = 'Active'
AND DOB BETWEEN DateAdd(Year,-75,GetDate()) AND DateAdd(Year,-50,GetDate())
-- current age 50 to 75 years

AND InternalID IN (SELECT InternalID 
  FROM BPS_Appointments
  INNER JOIN (VALUES('%findacure%')) AS providers(Name)
             ON Provider LIKE providers.Name
             -- appointment with specified providers

  WHERE AppointmentDate = '20181111'
  -- appointment on specified date
  )

AND (InternalID NOT IN (SELECT InternalID
  FROM BPS_Investigations
  INNER JOIN (VALUES ('%Faecal Occult Blood%'),('%FOB%'),('%FOBT%'),
                                       ('%OCCULT BLOOD%'),('%faecal human haemoglobin%'),
                                       ('%OCB NATIONAL SCREENING%'),('%FHB%'),('%FAECAL BLOOD%'),
                                       ('%OCCULT%'),('%Faecal Immunochemical Test%'),('%FAECAL HAEMOGLOBIN%'),
                                       ('%colonoscopy%'),('%colonoscope%')
             ) AS tests(fobtnames)
             ON TestName LIKE tests.fobtnames
  WHERE Collected >= DateAdd(Year,-2,GetDate())
  )  

  AND (InternalID NOT IN (SELECT InternalID
    FROM BPS_CorrespondenceIn
    INNER JOIN (VALUES ('%Faecal Occult Blood%'),('%FOB%'),('%FOBT%'),
                                       ('%OCCULT BLOOD%'),('%faecal human haemoglobin%'),
                                       ('%OCB NATIONAL SCREENING%'),('%FHB%'),('%FAECAL BLOOD%'),
                                       ('%OCCULT%'),('%Faecal Immunochemical Test%'),('%FAECAL HAEMOGLOBIN%'),
                                       ('%colonoscopy%'),('%colonoscope%')
             ) AS tests(fobtnames)
             ON Subject LIKE tests.fobtnames
    WHERE Correspondencedate >= DateAdd(Year,-2,GetDate())
    )
  )

  AND (InternalID NOT IN (SELECT InternalID
    FROM BPS_CorrespondenceIn
    INNER JOIN (VALUES ('%Faecal Occult Blood%'),('%FOB%'),('%FOBT%'),
                                       ('%OCCULT BLOOD%'),('%faecal human haemoglobin%'),
                                       ('%OCB NATIONAL SCREENING%'),('%FHB%'),('%FAECAL BLOOD%'),
                                       ('%OCCULT%'),('%Faecal Immunochemical Test%'),('%FAECAL HAEMOGLOBIN%'),
                                       ('%colonoscopy%'),('%colonoscope%')
             ) AS tests(fobtnames)
             ON Detail LIKE tests.fobtnames
    WHERE Correspondencedate >= DateAdd(Year,-2,GetDate())
    )
  )
  
  AND (InternalID NOT IN (SELECT InternalID
	FROM BPS_ReportValues
	WHERE LoincCode IN ('2335-8','27396-1','14563-1','14564-9','14565-6',
	                    '12503-9','12504-7','27401-9','27925-7','27926-5',
	                    '57905-2','56490-6','56491-4','29771-3')
	AND ReportDate >= DateAdd(Year,-2,GetDate())
	)
  ))
 
ORDER BY surname, firstname