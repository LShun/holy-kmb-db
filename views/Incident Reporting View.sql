PROMPT
PROMPT "INCIDENT CONTACT VIEW (FOR STATIONS)"
PROMPT

TTITLE OFF

/* START: NOTE RUN THIS PART SEPERATELY */
/* Show the stations for user to pick */
SELECT S.station_no, S.station_name
FROM   STATION S;

/* Accept the station from the user */
ACCEPT v_station_no CHAR PROMPT 'Enter station_no:    '
/* END: NOTE RUN THIS PART SEPERATELY */

TTITLE ON

/* Removes the previous formattings */
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

/* Set report formatting */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
SET PAGESIZE 1000
SET NEWPAGE 1
SET LINESIZE 90

/* Set column formattings */
COLUMN booking_date	HEADING "Book Date"
COLUMN customer_id      HEADING "C. ID"                                     
COLUMN customer_name    HEADING "Cust. Name"  FORMAT "A30"
COLUMN customer_phone   HEADING "Cust. Phone"
COLUMN station_no      	HEADING "Station No."                                     
COLUMN station_name    	HEADING "Station Name" FORMAT "A20"

BREAK ON station_name ON REPORT
COMPUTE NUMBER LABEL 'TOTAL' OF station_name ON REPORT

/* Set title */
TTITLE CENTER 'KMB TRAIN Sdn. Bhd.' SKIP 1 -
CENTER 'Incident Contact View (for Station)' SKIP 1 -
LEFT 'Station No: ' FORMAT 'A5' &v_station_no RIGHT 'Page:' FORMAT 999 sql.pno SKIP 2
REPFOOTER CENTER 'END OF REPORT'

/* Create the view */
CREATE OR REPLACE VIEW contact_incident_station AS
SELECT  DISTINCT B.booking_date, C.customer_id, C.customer_name, C.customer_phone, S.station_name
FROM    CUSTOMER C, PAYMENT P, BOOKING B, ARRIVAL A, STATION S
WHERE   C.customer_id = P.customer_id   AND
        P.payment_no = B.payment_no     AND
        B.booking_no = A.booking_no     AND
        A.station_no = S.station_no     AND
        A.arrival_status = 0 		AND
        S.station_no = '&v_station_no'	
ORDER BY    S.station_name, B.booking_date;

/* Activate the view */
SELECT  *
FROM    contact_incident_station;

/* Reset to defaults */
SET PAGESIZE 14
SET NEWPAGE 1
SET LINESIZE 80
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';