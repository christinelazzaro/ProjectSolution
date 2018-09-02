### QUESTION 1:  Across all reservation partners for January & February, how many completed reservations occurred? ###
SELECT 
(	SELECT count(*) FROM clubready_reservations 
	WHERE reserved_for >= '2018-01-01' AND reserved_for <'2018-03-01')
+
(	SELECT count(*) FROM mindbody_reservations 
    WHERE class_time_at >= '2018-01-01' AND class_time_at <'2018-03-01') TotalCompleteRes;

    
### QUESTION 2:  Which studio has the highest rate of reservation abandonment (did not cancel but did not check-in)? ###
SELECT studio_key Studio, count(*) AbandonedRes FROM clubready_reservations
	WHERE signed_in_at is null AND canceled = "f"
    GROUP BY Studio
UNION
SELECT studio_key Studio, count(*) AbandonedRes FROM mindbody_reservations
	WHERE checked_in_at is null AND canceled_at is null
	GROUP BY Studio 
ORDER BY AbandonedRes DESC 
LIMIT 1;


### QUESTION 3:  Which fitness area (i.e., tag) has the highest number of completed reservations for February? ###
SELECT class_tag FitArea, count(*) CompleteRes 
	FROM clubready_reservations CRRes
	WHERE CRRes.reserved_for >= '2018-02-01' AND CRRes.reserved_for <'2018-03-01'
UNION
SELECT class_tag FitArea, count(*) CompleteRes
	FROM mindbody_reservations MBRes
	WHERE MBRes.class_time_at >= '2018-02-01' AND MBRes.class_time_at < '2018-03-01'
GROUP BY FitArea	
ORDER BY CompleteRes DESC
LIMIT 1;


### QUESTION 4:  How many members completed at least 1 reservation and had no more than 1 cancelled reservation in January? ###
## NOTE:  I made the assumption that the Member_id was not a foreign key and instead was a memeber number unique to each vendor table
SELECT
(WITH CRRes (CRq4) AS
(	SELECT sum(CASE canceled WHEN "t" THEN 1 ELSE 0 END) Total 
	FROM clubready_reservations
	WHERE reserved_for >= '2018-01-01' AND reserved_for < '2018-02-01'
	GROUP BY member_id
    HAVING Total <= 1
) 
SELECT count(CRq4) Total FROM CRRes)
+
(WITH MBRes (MBq4) AS
(	SELECT sum(CASE WHEN canceled_at != "NULL" THEN 1 ELSE 0 END) Total 
	FROM mindbody_reservations
    WHERE class_time_at >= '2018-01-01' AND class_time_at < '2018-02-01'
    GROUP BY member_id	
    HAVING Total <= 1
)
SELECT count(MBq4) Total FROM MBRes) Num_of_Members;


### QUESTION 5:  At what time of day do most users book classes? Attend classes? (Morning = 7-11 AM, Afternoon = 12-4 PM, Evening = 5-10 PM) ###
##WHEN BOOKED##
SELECT
	CASE WHEN 
    HOUR(reserved_at) >='7' AND HOUR(reserved_at) < '12' THEN 'Morning'
    WHEN HOUR(reserved_at) >='12' AND HOUR(reserved_at) < '17' THEN 'Afternoon'
    WHEN HOUR(reserved_at) >='17' AND HOUR(reserved_at) < '23' THEN 'Evening'
    ELSE 'Other'
    END Time_of_Day,
COUNT(reserved_at) NumBookings
FROM mindbody_reservations
	GROUP BY(Time_of_Day)
    ORDER BY(NumBookings) DESC
    LIMIT 1;

##WHEN ATTENDED##
SELECT
	CASE WHEN 
    HOUR(reserved_for) >='7' AND HOUR(reserved_for) < '12' THEN 'Morning'
    WHEN HOUR(reserved_for) >='12' AND HOUR(reserved_for) < '17' THEN 'Afternoon'
    WHEN HOUR(reserved_for) >='17' AND HOUR(reserved_for) < '23' THEN 'Evening'
    ELSE 'Other'
    END Time_of_Day,
COUNT(reserved_for) NumBookings
FROM clubready_reservations
GROUP BY(Time_of_Day)
UNION SELECT
	CASE WHEN 
    HOUR(class_time_at) >='7' AND HOUR(class_time_at) < '12' THEN 'Morning'
    WHEN HOUR(class_time_at) >='12' AND HOUR(class_time_at) < '17' THEN 'Afternoon'
    WHEN HOUR(class_time_at) >='17' AND HOUR(class_time_at) < '23' THEN 'Evening'
    ELSE 'Other'
    END Time_of_Day,
COUNT(class_time_at) NumBookings
FROM mindbody_reservations
GROUP BY(Time_of_Day)
ORDER BY(NumBookings) DESC
LIMIT 2;


### QUESTION 6:  How many confirmed completed reservations did the member (ID) with the most reserved classes in February have? ###
SELECT CONCAT('CRRes',member_id) Member, COUNT(*) RsvClasses, COUNT(signed_in_at) ConfCompRes 
	FROM clubready_reservations CRREs
	WHERE reserved_for >= '2018-02-01' AND reserved_for < '2018-03-01'
    GROUP BY member_id
UNION
SELECT CONCAT('MBRes',member_id) Member, COUNT(*) RsvClasses, COUNT(checked_in_at) ConfCompRes 
	FROM mindbody_reservations MBREs
	WHERE class_time_at >= '2018-02-01' AND class_time_at < '2018-03-01'
    GROUP BY member_id
ORDER BY RsvClasses DESC
LIMIT 3;


### QUESTION 7:  Write a query that unions the `mindbody_reservations` table and `clubready_reservations` table as cleanly as possible. ###
SELECT CONCAT(id, reserved_for) id
	,CONCAT('CRRes_', member_id) Member
	,studio_key Studio
    ,class_tag FitArea
    ,reserved_for Reservation
    ,canceled RsvCanceled
    ,signed_in_at SignedIn
FROM clubready_reservations
UNION
SELECT CONCAT(id, class_time_at) id
	,CONCAT('MBRes_', member_id) Member
	,studio_key Studio
    ,class_tag FitArea
    ,class_time_at Reservation
    ,CASE 
		WHEN canceled_at != 'NULL' THEN "t"
		ELSE "f"
	 END RsvCanceled
    ,checked_in_at SignedIn
FROM mindbody_reservations;