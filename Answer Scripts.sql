### Question1:  Across all reservation partners for January & February, how many completed reservations occurred? ###
SELECT 
(SELECT count(*) Total FROM clubready_reservations WHERE reserved_for BETWEEN '2018-01-01' AND '2018-02-28')
+
(SELECT count(*) Total FROM mindbody_reservations WHERE reserved_at BETWEEN '2018-01-01' AND '2018-02-28');
    
