PROMPT
PROMPT "MAINTENANCE REQUIREMENT VIEW"
PROMPT

/* START: NOTE RUN THIS PART SEPERATELY */
/* Accept the maximum runs for trains */
ACCEPT v_runs NUMBER FORMAT '999' PROMPT 'Enter maximum runs for trains before requiring maintenance:    '
/* END: NOTE RUN THIS PART SEPERATELY */

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
COLUMN train_no                     HEADING "Train No"                                     
COLUMN train_model                  HEADING "Model"
COLUMN last_maintenance_date        HEADING "Last|Maintenance"                        FORMAT A12 WORD_WRAPPED
COLUMN weeks_no_maintenance         HEADING "Weeks|operated|since last|maintenance"
COLUMN weekly_runs                  HEADING "Runs|per week"
COLUMN total_runs_no_maintenance    HEADING "Total runs|without maintenance|(Weeks *|Runs Per Week)"

BREAK ON train_model SKIP PAGE ON total_runs_no_maintenance SKIP 1
COMPUTE NUMBER LABEL 'Total Trains: ' OF total_runs_no_maintenance ON train_model

/* Set title */
TTITLE CENTER 'KMB TRAIN Sdn. Bhd.' SKIP 1 -
CENTER 'Maintenance Requirement View' SKIP 1 -
LEFT 'Trains Exceed ' FORMAT 999 &v_runs ' Runs w/o Maintenance' RIGHT 'Page:' FORMAT 999 sql.pno SKIP 2
REPFOOTER CENTER 'END OF REPORT'

/* Create a view */
CREATE OR REPLACE VIEW train_maintenance_check AS
SELECT
    train_no,
    train_model,
    last_maintenance_date,
    weeks_no_maintenance,
    weekly_runs,
    total_runs_no_maintenance
FROM
    (
        SELECT
            t.train_no,
            t.train_model,
            t.last_maintenance_date,
            ( trunc(SYSDATE, 'd') - trunc(TO_DATE(ts.train_schedule_start_time), 'd') ) / 7 AS weeks_no_maintenance,
            COUNT(ts.schedule_no) * 7 AS weekly_runs,
            ( trunc(SYSDATE, 'd') - trunc(TO_DATE(ts.train_schedule_start_time), 'd') ) / 7 * COUNT(ts.schedule_no) * 7 AS total_runs_no_maintenance
        FROM
            train            t,
            train_schedule   ts
        WHERE
            t.train_no = ts.train_no
        GROUP BY
            t.train_no,
            t.train_model,
            ( trunc(SYSDATE, 'd') - trunc(TO_DATE(ts.train_schedule_start_time), 'd') ) / 7,
            t.last_maintenance_date,
            SYSDATE,
            'd',
            trunc(TO_DATE(ts.train_schedule_start_time), 'd'),
            TO_DATE(ts.train_schedule_start_time),
            ts.train_schedule_start_time,
            'd'
    )
WHERE
    total_runs_no_maintenance > &v_runs
ORDER BY
    total_runs_no_maintenance DESC,
    train_model;

/* Activate the view */
SELECT  *
FROM    train_maintenance_check;

/* Reset to defaults*/
SET PAGESIZE 14
SET NEWPAGE 1
SET LINESIZE 80
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';