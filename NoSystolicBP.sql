SELECT *
FROM BPS_Patients

WHERE StatusText = 'Active'
AND DOB < DateAdd(Year,-45,'20181201')
-- age 45+ years at specified date (in this case, 1st December 2018)

AND InternalID IN (SELECT InternalID 
  FROM Visits v
  INNER JOIN (VALUES('%bhagwat%'),('%fong%'),('%ekanayake%'))
             AS ProviderName(Name)
            ON v.DrName LIKE ProviderName.Name
            -- appointment with specified providers
  WHERE VisitDate BETWEEN DateAdd(Year,-2,'20181201') AND '20181201'
  -- visits during specified two year time period
  AND RecordStatus = 1
 
  GROUP BY internalid
  HAVING count(internalid) >= 5 
  -- minimum 5 visits during specified time period
  )
   
-- no systolic BP observations for this internalid
AND InternalID NOT IN (SELECT InternalID 
  FROM Observations
  WHERE DataCode=3
)

ORDER BY surname, firstname
