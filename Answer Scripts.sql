### Question1:  Across all reservation partners for January & February, how many completed reservations occurred? ###
SELECT 
(SELECT count(*) Total FROM clubready_reservations WHERE reserved_for BETWEEN '2018-01-01' AND '2018-02-28')
+
(SELECT count(*) Total FROM mindbody_reservations WHERE reserved_at BETWEEN '2018-01-01' AND '2018-02-28');
    
### Question2:  Which studio has the highest rate of reservation abandonment (did not cancel but did not check-in)? ###
SELECT studio_key Studio, count(*) Total FROM clubready_reservations CRRes
	WHERE CRRes.signed_in_at is null AND CRRes.canceled = "f"
    GROUP BY Studio
UNION
	SELECT studio_key Studio, count(*) Total FROM mindbody_reservations MBRes
	WHERE MBRes.checked_in_at is null AND MBRes.canceled_at is null
	GROUP BY Studio 
ORDER BY Total DESC 
LIMIT 1;

### Question 3:  Which fitness area (i.e., tag) has the highest number of completed reservations for February? ###
SELECT class_tag FitArea, count(*) CompleteRes FROM clubready_reservations CRRes
	WHERE CRRes.reserved_for BETWEEN '2018-02-01' AND '2018-02-28'
UNION
	SELECT class_tag FitArea, count(*) CompleteRes FROM mindbody_reservations MBRes
	WHERE MBRes.class_time_at BETWEEN '2018-02-01' AND '2018-02-28'
GROUP BY FitArea	
ORDER BY CompleteRes DESC
LIMIT 1;