### QUESTION 1:  Across all reservation partners for January & February, how many completed reservations occurred? ###
SELECT 
(
	SELECT count(*) Total FROM clubready_reservations 
    WHERE reserved_for BETWEEN '2018-01-01' AND '2018-02-28'
)
+
(
	SELECT count(*) Total FROM mindbody_reservations 
    WHERE reserved_at BETWEEN '2018-01-01' AND '2018-02-28'
) TotalCompleteRes;

    
### QUESTION 2:  Which studio has the highest rate of reservation abandonment (did not cancel but did not check-in)? ###
SELECT studio_key Studio, count(*) AbandonedRes FROM clubready_reservations CRRes
	WHERE CRRes.signed_in_at is null AND CRRes.canceled = "f"
    GROUP BY Studio
UNION
SELECT studio_key Studio, count(*) AbandonedRes FROM mindbody_reservations MBRes
	WHERE MBRes.checked_in_at is null AND MBRes.canceled_at is null
	GROUP BY Studio 
ORDER BY AbandonedRes DESC 
LIMIT 1;


### QUESTION 3:  Which fitness area (i.e., tag) has the highest number of completed reservations for February? ###
SELECT class_tag FitArea, count(*) CompleteRes FROM clubready_reservations CRRes
	WHERE CRRes.reserved_for BETWEEN '2018-02-01' AND '2018-02-28'
UNION
SELECT class_tag FitArea, count(*) CompleteRes FROM mindbody_reservations MBRes
	WHERE MBRes.class_time_at BETWEEN '2018-02-01' AND '2018-02-28'
GROUP BY FitArea	
ORDER BY CompleteRes DESC
LIMIT 1;


### QUESTION 4:  How many members completed at least 1 reservation and had no more than 1 cancelled reservation in January? ###
SELECT
(WITH CRRes (CRq4) AS
(
	SELECT sum(CASE canceled WHEN "t" THEN 1 ELSE 0 END) Total 
	FROM clubready_reservations
	WHERE reserved_for BETWEEN '2018-01-01' AND '2018-01-31'
	GROUP BY member_id
    HAVING Total <= 1
)   
SELECT count(CRq4) Total FROM CRRes)
+
(WITH MBRes (MBq4) AS
(
	SELECT sum(CASE WHEN canceled_at != "NULL" THEN 1 ELSE 0 END) Total 
	FROM mindbody_reservations
    WHERE class_time_at BETWEEN '2018-01-01' AND '2018-01-31'
    GROUP BY member_id
    HAVING Total <= 1
)
SELECT count(MBq4) Total FROM MBRes) MemberCount;


### QUESTION 5:  At what time of day do most users book classes? Attend classes? (Morning = 7-11 AM, Afternoon = 12-4 PM, Evening = 5-10 PM) ###
##WHEN BOOKED##


##WHEN ATTENDED##




### QUESTION 6:  How many confirmed completed reservations did the member (ID) with the most reserved classes in February have? ###



