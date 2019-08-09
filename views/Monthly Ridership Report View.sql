PROMPT
PROMPT MONTHLY RIDERSHIP REPORT VIEW (BY ROUTE)
PROMPT
/* START: NOTE RUN THIS PART SEPERATELY */
/* Accept the maximum runs for trains */
ACCEPT v_month NUMBER FORMAT '99' PROMPT 'Enter month to obtain report (1-12): '
/* START: NOTE RUN THIS PART SEPERATELY */
ACCEPT v_year NUMBER FORMAT '9999' PROMPT 'Enter month to obtain report (YYYY, eg: 2019): '


/* Removes the previous formattings */
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

/* Set report formatting */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
SET PAGESIZE 1000
SET NEWPAGE 1
SET LINESIZE 85

/* Set column formattings */                                   
COLUMN route_no                  HEADING "Route No." 
COLUMN route_name                HEADING "Route Name."

BREAK ON route_no SKIP PAGE ON route_no SKIP 1 ON route_name SKIP 1
COMPUTE SUM LABEL 'Total Sales:' OF "SALES" ON route_name

/* Set title */
TTITLE CENTER 'KMB TRAIN Sdn. Bhd.' SKIP 1 -
CENTER 'Monthly Ridership Report View (By Route)' SKIP 1 -
LEFT 'Month/Year: ' FORMAT 999 &v_month '/' FORMAT 9999 &v_year RIGHT 'Page:' FORMAT 999 sql.pno SKIP 2
REPFOOTER CENTER 'END OF REPORT'

/* Create the view */
CREATE OR REPLACE VIEW station_monthly_ridership AS
SELECT  TRUNC(B.booking_date) AS BookDate, r.route_no, r.route_name, COUNT(*) AS "SALES"
FROM    CUSTOMER C, PAYMENT P, BOOKING B, DEPARTURE D, ROUTE R, STATION S
WHERE   C.customer_id = P.customer_id AND
        P.payment_no = B.payment_no AND
        B.booking_no = D.booking_no AND
        B.booking_date >= TO_DATE('1/&v_month/&v_year') AND 
        B.booking_date < LAST_DAY(TO_DATE('1/&v_month/&v_year')) AND
        D.station_no = S.station_no AND
        S.route_no = R.route_no AND
        D.departure_status = 1
GROUP BY TRUNC(B.booking_date), r.route_no, r.route_name
ORDER BY r.route_no, TRUNC(B.booking_date);

/* Activate the view */
SELECT *
FROM station_monthly_ridership;

/* Reset to default size */
SET PAGESIZE 14
SET NEWPAGE 1
SET LINESIZE 80
TTITLE CENTER REPORT /* Change to something acceptable in general */