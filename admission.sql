DROP TABLE IF EXISTS admission;

START TRANSACTION;

CREATE TABLE "admission" (
	"serial_no" INTEGER NOT NULL,
	"gre_score" NUMERIC NOT NULL,
	"toefl_score" NUMERIC NOT NULL,
	"university_rating" NUMERIC NOT NULL,
	"sop" NUMERIC NOT NULL,
	"lor" NUMERIC NOT NULL,
	"cgpa" NUMERIC NOT NULL,
	"research" NUMERIC NOT NULL,
	"chance_of_admit" NUMERIC NOT NULL
);

COMMIT;

COPY admission FROM '/tmp/admission_table.csv' DELIMITER ',' CSV HEADER;

-- Load PL/Python extension
CREATE EXTENSION plpythonu;
