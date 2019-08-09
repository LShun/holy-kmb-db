PROMPT
PROMPT "INCIDENT CONTACT VIEW (FOR STATIONS)"
PROMPT

/* START: NOTE RUN THIS PART SEPERATELY */
/* Show the stations for user to pick */
SELECT S.station_no, S.station_name
FROM   STATION S;

/* Accept the station from the user */
ACCEPT v_station_no CHAR PROMPT 'Enter station_no:    '
/* END: NOTE RUN THIS PART SEPERATELY */

/* Removes the previous formattings */
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

/* Set report formatting */
SET PAGESIZE 1000
SET NEWPAGE 1
SET LINESIZE 90

/* Set column formattings */
COLUMN datecol          NEW_VALUE SYSDATE NOPRINT
COLUMN customer_id      HEADING "Cust. ID"                                     
COLUMN customer_name    HEADING "Cust. Name"  FORMAT "A30"
COLUMN customer_phone   HEADING "Cust. Phone"
COLUMN station_no      HEADING "Station No."                                     
COLUMN station_name    HEADING "Station Name" FORMAT "A20"

BREAK ON station_name ON REPORT
COMPUTE NUMBER LABEL 'TOTAL' OF station_name ON REPORT

/* Set title */
TTITLE CENTER 'KMB TRAIN Sdn. Bhd.' SKIP 1 -
CENTER 'Incident Contact View (for Station)' SKIP 1 -
LEFT 'Station No: ' FORMAT 'A5' &v_station_no RIGHT 'Page:' FORMAT 999 sql.pno SKIP 2
REPFOOTER CENTER 'END OF REPORT'

/* Drop the old view */
DROP VIEW contact_incident_station;

/* Create the view */
CREATE VIEW contact_incident_station AS
SELECT  DISTINCT C.customer_id, C.customer_name, C.customer_phone, S.station_name
FROM    CUSTOMER C, PAYMENT P, BOOKING B, ARRIVAL A, STATION S
WHERE   C.customer_id = P.customer_id   AND
        P.payment_no = B.payment_no     AND
        B.booking_no = A.booking_no     AND
        A.station_no = S.station_no     AND
        A.arrival_status = 0 AND
        S.station_no = '&v_station_no'
ORDER BY    S.station_name;

/* Activate the view */
SELECT  *
FROM    contact_incident_station;

/* Reset to default size */
SET PAGESIZE 14
SET NEWPAGE 1
SET LINESIZE 80
