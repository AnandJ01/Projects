-- Relation Scheme Metadata Project
-- Abhishek Jasti
-- Anand Jasti
-- Michael Son
-- Nathan Chau
-- Due Date: June 30, 2022


-- Removes All tables
ALTER TABLE relation_schemes
    DROP CONSTRAINT relation_schemes_fk_2;
ALTER TABLE attributes
    DROP CONSTRAINT attributes_fk_1,
    DROP CONSTRAINT attributes_fk_2,
    DROP CONSTRAINT attributes_fk_3;
ALTER TABLE foreign_keys
    DROP CONSTRAINT foreign_keys_fk_1,
    DROP CONSTRAINT foreign_keys_fk_2;
ALTER TABLE foreign_key_migrations
    DROP CONSTRAINT foreign_key_migrations_fk_1,
    DROP CONSTRAINT foreign_key_migrations_fk_2;
ALTER TABLE constraints
    DROP CONSTRAINT constraints_fk;
ALTER TABLE candidate_keys
    DROP CONSTRAINT candidate_keys_fk_1,
    DROP CONSTRAINT candidate_keys_fk_2;
ALTER TABLE candidate_key_members
    DROP CONSTRAINT candidate_key_members_fk_1,
    DROP CONSTRAINT candidate_key_members_fk_2;
ALTER TABLE primary_keys
    DROP CONSTRAINT primary_keys_fk_1,
    DROP CONSTRAINT primary_keys_fk_2;
ALTER TABLE varchars
    DROP CONSTRAINT varchars_fk;
ALTER TABLE decimals
    DROP CONSTRAINT decimals_fk;
DROP TABLE IF EXISTS models;
DROP TABLE IF EXISTS relation_schemes;
DROP TABLE IF EXISTS attributes;
DROP TABLE IF EXISTS attribute_types;
DROP TABLE IF EXISTS foreign_keys;
DROP TABLE IF EXISTS foreign_key_migrations;
DROP TABLE IF EXISTS constraints;
DROP TABLE IF EXISTS candidate_keys;
DROP TABLE IF EXISTS candidate_key_members;
DROP TABLE IF EXISTS primary_keys;
DROP TABLE IF EXISTS varchars;
DROP TABLE IF EXISTS decimals;
DROP FUNCTION IF EXISTS generate_attribute;
DROP FUNCTION IF EXISTS generate_relation_scheme;
DROP FUNCTION IF EXISTS generate_foreign_keys;
DROP FUNCTION IF EXISTS generate_model;
DROP PROCEDURE IF EXISTS splitting_foreign_keys;
DROP PROCEDURE IF EXISTS subset_candidate_keys;


-- DDL
CREATE TABLE models(
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL,
    CONSTRAINT models_pk PRIMARY KEY (name)
);

CREATE TABLE relation_schemes(
    model_name VARCHAR(50) NOT NULL,
    relational_name VARCHAR(50) NOT NULL,
    CONSTRAINT relation_schemes_pk PRIMARY KEY (model_name, relational_name)
);

CREATE TABLE attributes(
    attribute_name VARCHAR(50) NOT NULL,
    attribute_type_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    relational_name VARCHAR(50) NOT NULL,
    CONSTRAINT attributes_pk PRIMARY KEY (attribute_name, model_name, relational_name)
);

CREATE TABLE attribute_types (
    name VARCHAR(50) NOT NULL,
    CONSTRAINT attribute_types_pk PRIMARY KEY (name)
);

CREATE TABLE foreign_keys
(
    model_name       VARCHAR(50) NOT NULL,
    foreign_key_name VARCHAR(50) NOT NULL,
    relational_name  VARCHAR(50) NOT NULL,
    identifying      BOOLEAN NOT NULL,
    CONSTRAINT foreign_keys_pk PRIMARY KEY (model_name, relational_name, foreign_key_name),
    CONSTRAINT foreign_keys_uk UNIQUE (model_name, foreign_key_name)
);

CREATE TABLE foreign_key_migrations
(
    attribute_name  VARCHAR(50) NOT NULL,
    model_name      VARCHAR(50) NOT NULL,
    relational_name VARCHAR(50) NOT NULL,
    foreign_key_name VARCHAR(50) NOT NULL,
    CONSTRAINT foreign_key_migrations_pk PRIMARY KEY (attribute_name, model_name, relational_name)
);

CREATE TABLE constraints
(
    model_name      VARCHAR(50) NOT NULL,
    constraint_name VARCHAR(50) NOT NULL,
    CONSTRAINT constraints_pk PRIMARY KEY (model_name, constraint_name)
);

CREATE TABLE candidate_keys
(
    model_name         VARCHAR(50) NOT NULL,
    candidate_key_name VARCHAR(50) NOT NULL,
    relational_name    VARCHAR(50) NOT NULL,
    CONSTRAINT candidate_keys_pk PRIMARY KEY (model_name, candidate_key_name)
);

CREATE TABLE candidate_key_members
(
    attribute_name     VARCHAR(50) NOT NULL,
    relational_name    VARCHAR(50) NOT NULL,
    model_name         VARCHAR(50) NOT NULL,
    candidate_key_name VARCHAR(50) NOT NULL,
    position           INT,
    CONSTRAINT candidate_key_members_pk PRIMARY KEY (attribute_name, model_name, relational_name, candidate_key_name)
);

CREATE TABLE primary_keys
(
    model_name       VARCHAR(50) NOT NULL,
    primary_key_name VARCHAR(50) NOT NULL,
    relational_name  VARCHAR(50) NOT NULL,
    CONSTRAINT primary_keys_pk PRIMARY KEY (model_name, relational_name),
    CONSTRAINT primary_keys_uk UNIQUE (model_name,primary_key_name)
);

CREATE TABLE varchars
(
    attribute_name  VARCHAR(50) NOT NULL,
    model_name      VARCHAR(50) NOT NULL,
    relational_name VARCHAR(50) NOT NULL,
    length          INT         NOT NULL,
    CONSTRAINT varchars_pk PRIMARY KEY (attribute_name, model_name, relational_name)
);

CREATE TABLE decimals
(
    `precision`     INT         NOT NULL,
    scale           INT         NOT NULL,
    attribute_name  VARCHAR(50) NOT NULL,
    model_name      VARCHAR(50) NOT NULL,
    relational_name VARCHAR(50) NOT NULL,
    CONSTRAINT decimals_pk PRIMARY KEY (attribute_name, model_name, relational_name)
);

ALTER TABLE relation_schemes
    ADD CONSTRAINT relation_schemes_fk_2 FOREIGN KEY (model_name) REFERENCES models(name);

ALTER TABLE attributes
    ADD CONSTRAINT attributes_fk_1 FOREIGN KEY (model_name,relational_name) REFERENCES relation_schemes(model_name, relational_name),
    ADD CONSTRAINT attributes_fk_2 FOREIGN KEY (attribute_type_name) REFERENCES attribute_types(name),
    ADD CONSTRAINT attributes_fk_3 FOREIGN KEY (attribute_name, model_name, relational_name) REFERENCES foreign_key_migrations(attribute_name, model_name, relational_name);

ALTER TABLE foreign_keys
    ADD CONSTRAINT foreign_keys_fk_1 FOREIGN KEY (model_name, foreign_key_name) REFERENCES constraints(model_name, constraint_name),
    ADD CONSTRAINT foreign_keys_fk_2 FOREIGN KEY (model_name, relational_name) REFERENCES relation_schemes(model_name, relational_name);

ALTER TABLE foreign_key_migrations
    ADD CONSTRAINT foreign_key_migrations_fk_1 FOREIGN KEY (model_name, relational_name, foreign_key_name) REFERENCES foreign_keys(model_name,relational_name, foreign_key_name),
    ADD CONSTRAINT foreign_key_migrations_fk_2 FOREIGN KEY (attribute_name,model_name,relational_name) REFERENCES attributes(attribute_name, model_name, relational_name);

ALTER TABLE constraints
    ADD CONSTRAINT constraints_fk FOREIGN KEY (model_name) REFERENCES models(name);

ALTER TABLE candidate_keys
    ADD CONSTRAINT candidate_keys_fk_1 FOREIGN KEY (model_name, relational_name) REFERENCES relation_schemes(model_name, relational_name),
    ADD CONSTRAINT candidate_keys_fk_2 FOREIGN KEY (model_name, candidate_key_name) REFERENCES constraints(model_name, constraint_name);

ALTER TABLE candidate_key_members
    ADD CONSTRAINT candidate_key_members_fk_1 FOREIGN KEY (attribute_name,model_name,relational_name) REFERENCES attributes(attribute_name,model_name,relational_name),
    ADD CONSTRAINT candidate_key_members_fk_2 FOREIGN KEY (model_name, candidate_key_name) REFERENCES candidate_keys(model_name, candidate_key_name);

ALTER TABLE primary_keys
    ADD CONSTRAINT primary_keys_fk_1 FOREIGN KEY (model_name,primary_key_name) REFERENCES candidate_keys(model_name,candidate_key_name),
    ADD CONSTRAINT primary_keys_fk_2 FOREIGN KEY (model_name, relational_name) REFERENCES relation_schemes(model_name, relational_name);

ALTER TABLE varchars
    ADD CONSTRAINT varchars_fk FOREIGN KEY (attribute_name,model_name,relational_name) REFERENCES attributes(attribute_name, model_name, relational_name);

ALTER TABLE decimals
    ADD CONSTRAINT decimals_fk FOREIGN KEY (attribute_name, model_name, relational_name) REFERENCES attributes(attribute_name, model_name, relational_name);


-- DML
INSERT INTO models(name, description)
VALUE       ('Enrollment_System', 'A model to test our database.');

INSERT INTO relation_schemes(model_name, relational_name)
VALUES      ('Enrollment_System', 'departments'),
            ('Enrollment_System', 'days'),
            ('Enrollment_System', 'courses'),
            ('Enrollment_System', 'instructors'),
            ('Enrollment_System', 'semesters'),
            ('Enrollment_System', 'sections'),
            ('Enrollment_System', 'students'),
            ('Enrollment_System', 'grades'),
            ('Enrollment_System', 'enrollments'),
            ('Enrollment_System', 'transcript_entries');

INSERT INTO attribute_types(name)
VALUES      ('INT'),
            ('DECIMAL'),
            ('FLOAT'),
            ('VARCHAR'),
            ('DATE'),
            ('YEAR'),
            ('TEXT'),
            ('TIME');

SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO attributes(attribute_name, attribute_type_name, model_name, relational_name)
VALUES      ('name', 'VARCHAR', 'Enrollment_System', 'departments'),
            ('weekday_combinations', 'VARCHAR', 'Enrollment_System', 'days'),
            ('name', 'VARCHAR', 'Enrollment_System', 'courses'),
            ('number', 'INT', 'Enrollment_System', 'courses'),
            ('description', 'TEXT', 'Enrollment_System', 'courses'),
            ('units', 'INT', 'Enrollment_System', 'courses'),
            ('title', 'VARCHAR', 'Enrollment_System', 'courses'),
            ('instructor_name', 'VARCHAR', 'Enrollment_System', 'instructors'),
            ('name', 'VARCHAR', 'Enrollment_System', 'semesters'),
            ('department_name', 'VARCHAR', 'Enrollment_System', 'sections'),
            ('course_number', 'INT', 'Enrollment_System', 'sections'),
            ('number', 'INT', 'Enrollment_System', 'sections'),
            ('year', 'YEAR', 'Enrollment_System', 'sections'),
            ('semester', 'VARCHAR', 'Enrollment_System', 'sections'),
            ('instructor', 'VARCHAR', 'Enrollment_System', 'sections'),
            ('start_time', 'TIME', 'Enrollment_System', 'sections'),
            ('days', 'VARCHAR', 'Enrollment_System', 'sections'),
            ('student_id', 'INT', 'Enrollment_System', 'students'),
            ('last_name', 'VARCHAR', 'Enrollment_System', 'students'),
            ('first_name', 'VARCHAR', 'Enrollment_System', 'students'),
            ('grade_letter', 'VARCHAR', 'Enrollment_System', 'grades'),
            ('student_id', 'INT', 'Enrollment_System', 'enrollments'),
            ('department_name', 'VARCHAR', 'Enrollment_System', 'enrollments'),
            ('course_number', 'INT', 'Enrollment_System', 'enrollments'),
            ('section_number', 'INT', 'Enrollment_System', 'enrollments'),
            ('year', 'YEAR', 'Enrollment_System', 'enrollments'),
            ('semester', 'VARCHAR', 'Enrollment_System', 'enrollments'),
            ('grade', 'VARCHAR', 'Enrollment_System', 'enrollments'),
            ('student_id', 'INT', 'Enrollment_System', 'transcript_entries'),
            ('department_name', 'VARCHAR', 'Enrollment_System', 'transcript_entries'),
            ('course_number', 'INT', 'Enrollment_System', 'transcript_entries'),
            ('section_number', 'INT', 'Enrollment_System', 'transcript_entries'),
            ('year', 'YEAR', 'Enrollment_System', 'transcript_entries'),
            ('semester', 'VARCHAR', 'Enrollment_System', 'transcript_entries');
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO constraints(model_name, constraint_name)
VALUES      ('Enrollment_System', 'departments_PK'),
            ('Enrollment_System', 'courses_departments_FK_01'),
            ('Enrollment_System', 'courses_UK_01'),
#             ('Enrollment_System', 'courses_UK_02'),
            ('Enrollment_System', 'courses_PK'),
            ('Enrollment_System', 'days_PK'),
            ('Enrollment_System', 'instructors_PK'),
            ('Enrollment_System', 'semesters_PK'),
            ('Enrollment_System', 'sections_courses_FK_01'),
            ('Enrollment_System', 'sections_semesters_FK_02'),
            ('Enrollment_System', 'sections_instructors_FK_03'),
            ('Enrollment_System', 'sections_days_FK_04'),
            ('Enrollment_System', 'sections_PK'),
            ('Enrollment_System', 'students_PK'),
            ('Enrollment_System', 'grades_PK'),
            ('Enrollment_System', 'enrollments_students_FK_01'),
            ('Enrollment_System', 'enrollments_sections_FK_02'),
            ('Enrollment_System', 'enrollments_grades_FK_03'),
            ('Enrollment_System', 'enrollments_PK'),
            ('Enrollment_System', 'transcript_entries_enrollments_FK_01'),
            ('Enrollment_System', 'transcript_entries_PK');

INSERT INTO foreign_keys(model_name, foreign_key_name, relational_name, identifying)
VALUES      ('Enrollment_System','courses_departments_FK_01','courses', TRUE),
            ('Enrollment_System','sections_courses_FK_01','sections', TRUE),
            ('Enrollment_System','sections_semesters_FK_02','sections', TRUE),
            ('Enrollment_System','sections_instructors_FK_03','sections', FALSE),
            ('Enrollment_System','sections_days_FK_04','sections', FALSE),
            ('Enrollment_System','enrollments_students_FK_01','enrollments', TRUE),
            ('Enrollment_System','enrollments_sections_FK_02','enrollments', TRUE),
            ('Enrollment_System','enrollments_grades_FK_03','enrollments', FALSE),
            ('Enrollment_System','transcript_entries_enrollments_FK_01','transcript_entries', FALSE);

INSERT INTO foreign_key_migrations(attribute_name, model_name, relational_name, foreign_key_name)
VALUES      ('name', 'Enrollment_System', 'courses', 'courses_departments_FK_01'),
            ('department_name', 'Enrollment_System', 'sections', 'sections_courses_FK_01'),
            ('course_number', 'Enrollment_System', 'sections', 'sections_courses_FK_01'),
            ('semester', 'Enrollment_System', 'sections', 'sections_semesters_FK_02'),
            ('instructor', 'Enrollment_System', 'sections', 'sections_instructors_FK_03'),
            ('days', 'Enrollment_System', 'sections', 'sections_days_FK_04'),
            ('student_id', 'Enrollment_System', 'enrollments', 'enrollments_students_FK_01'),
            ('department_name', 'Enrollment_System', 'enrollments', 'enrollments_sections_FK_02'),
            ('course_number', 'Enrollment_System', 'enrollments', 'enrollments_sections_FK_02'),
            ('section_number', 'Enrollment_System', 'enrollments', 'enrollments_sections_FK_02'),
            ('year', 'Enrollment_System', 'enrollments', 'enrollments_sections_FK_02'),
            ('semester', 'Enrollment_System', 'enrollments', 'enrollments_sections_FK_02'),
            ('grade', 'Enrollment_System', 'enrollments', 'enrollments_grades_FK_03'),
            ('student_id', 'Enrollment_System', 'transcript_entries', 'transcript_entries_enrollments_FK_01'),
            ('department_name', 'Enrollment_System', 'transcript_entries', 'transcript_entries_enrollments_FK_01'),
            ('course_number', 'Enrollment_System', 'transcript_entries', 'transcript_entries_enrollments_FK_01'),
            ('section_number', 'Enrollment_System', 'transcript_entries', 'transcript_entries_enrollments_FK_01'),
            ('year', 'Enrollment_System', 'transcript_entries', 'transcript_entries_enrollments_FK_01'),
            ('semester', 'Enrollment_System', 'transcript_entries', 'transcript_entries_enrollments_FK_01');

INSERT INTO candidate_keys(model_name, candidate_key_name, relational_name)
VALUES      ('Enrollment_System', 'departments_PK', 'departments'),
            ('Enrollment_System', 'courses_UK_01', 'courses'),
#             ('Enrollment_System', 'courses_UK_02', 'courses'),
            ('Enrollment_System', 'courses_PK', 'courses'),
            ('Enrollment_System', 'days_PK', 'days'),
            ('Enrollment_System', 'instructors_PK', 'instructors'),
            ('Enrollment_System', 'semesters_PK', 'semesters'),
            ('Enrollment_System', 'sections_PK', 'sections'),
            ('Enrollment_System', 'students_PK', 'students'),
            ('Enrollment_System', 'grades_PK', 'grades'),
            ('Enrollment_System', 'enrollments_PK', 'enrollments'),
            ('Enrollment_System', 'transcript_entries_PK', 'transcript_entries');

INSERT INTO candidate_key_members(attribute_name, relational_name, model_name, candidate_key_name, position)
VALUES      ('name', 'departments', 'Enrollment_System', 'departments_PK',1),
            ('name', 'courses', 'Enrollment_System', 'courses_UK_01',1),
            ('title', 'courses', 'Enrollment_System', 'courses_UK_01',2),
#             ('number', 'courses', 'Enrollment_System', 'courses_UK_02',1),
#             ('description', 'courses', 'Enrollment_System', 'courses_UK_02',2),
            ('name', 'courses', 'Enrollment_System', 'courses_PK',1),
            ('number', 'courses', 'Enrollment_System', 'courses_PK',2),
            ('weekday_combinations', 'days', 'Enrollment_System', 'days_PK',1),
            ('instructor_name', 'instructors', 'Enrollment_System', 'instructors_PK',1),
            ('name', 'semesters', 'Enrollment_System', 'semesters_PK',1),
            ('department_name', 'sections', 'Enrollment_System', 'sections_PK',1),
            ('course_number', 'sections', 'Enrollment_System', 'sections_PK',2),
            ('number', 'sections', 'Enrollment_System', 'sections_PK',3),
            ('year', 'sections', 'Enrollment_System', 'sections_PK',4),
            ('semester', 'sections', 'Enrollment_System', 'sections_PK',5),
            ('student_id', 'students', 'Enrollment_System', 'students_PK',1),
            ('grade_letter', 'grades', 'Enrollment_System', 'grades_PK',1),
            ('student_id', 'enrollments', 'Enrollment_System', 'enrollments_PK',1),
            ('department_name', 'enrollments', 'Enrollment_System', 'enrollments_PK',2),
            ('course_number', 'enrollments', 'Enrollment_System', 'enrollments_PK',3),
            ('section_number', 'enrollments', 'Enrollment_System', 'enrollments_PK',4),
            ('year', 'enrollments', 'Enrollment_System', 'enrollments_PK',5),
            ('semester', 'enrollments', 'Enrollment_System', 'enrollments_PK',6),
            ('student_id', 'transcript_entries', 'Enrollment_System', 'transcript_entries_PK',1),
            ('department_name', 'transcript_entries', 'Enrollment_System', 'transcript_entries_PK',2),
            ('course_number', 'transcript_entries', 'Enrollment_System', 'transcript_entries_PK',3);

INSERT INTO primary_keys (model_name, primary_key_name, relational_name)
VALUES      ('Enrollment_System', 'departments_PK', 'departments'),
            ('Enrollment_System', 'courses_PK', 'courses'),
            ('Enrollment_System', 'days_PK', 'days'),
            ('Enrollment_System', 'instructors_PK', 'instructors'),
            ('Enrollment_System', 'semesters_PK', 'semesters'),
            ('Enrollment_System', 'sections_PK', 'sections'),
            ('Enrollment_System', 'students_PK', 'students'),
            ('Enrollment_System', 'grades_PK', 'grades'),
            ('Enrollment_System', 'enrollments_PK', 'enrollments'),
            ('Enrollment_System', 'transcript_entries_PK', 'transcript_entries');

INSERT INTO varchars(attribute_name, model_name, relational_name, length)
VALUES      ('name', 'Enrollment_System', 'departments', 50),
            ('weekday_combinations', 'Enrollment_System', 'days', 20),
            ('name', 'Enrollment_System', 'courses', 50),
            ('title', 'Enrollment_System', 'courses', 50),
            ('instructor_name', 'Enrollment_System', 'instructors', 50),
            ('name', 'Enrollment_System', 'semesters', 10),
            ('department_name', 'Enrollment_System', 'sections', 50),
            ('semester', 'Enrollment_System', 'sections', 10),
            ('instructor', 'Enrollment_System', 'sections', 50),
            ('days', 'Enrollment_System', 'sections', 20),
            ('last_name', 'Enrollment_System', 'students', 25),
            ('first_name', 'Enrollment_System', 'students', 25),
            ('grade_letter', 'Enrollment_System', 'grades', 1),
            ('department_name', 'Enrollment_System', 'enrollments', 50),
            ('semester', 'Enrollment_System', 'enrollments', 10),
            ('grade', 'Enrollment_System', 'enrollments', 1),
            ('department_name', 'Enrollment_System', 'transcript_entries', 50),
            ('semester', 'Enrollment_System', 'transcript_entries', 10);

-- No decimals in the test relation scheme diagram


-- Functions to generate DDL
# DROP FUNCTION generate_attribute;
DELIMITER //
CREATE FUNCTION generate_attribute (in_model_name VARCHAR(64), in_relational_name VARCHAR(64),
				in_attribute_name VARCHAR(64), in_data_type VARCHAR(20)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
/*
    This is sort of a stub to just show how you would geneate the DDL code for one attribute.
    @param	in_model_name			The name of the model that you want to generate the DDL for.
    @param	in_relation_scheme_name	The relaton scheme within that model that owns the attribute.
    @param	in_attribute_name		The name of the attribute to generate DDL for.
    @param  in_data_type            The type of the attribute
    @return							The one line of DDL for this particular attribute.
    */
    DECLARE length_string INTEGER DEFAULT 0;    -- length of VARCHARS
    DECLARE precision_int INTEGER DEFAULT 0;    --
    DECLARE scale_int INTEGER DEFAULT 0;        --
	DECLARE	results text default '';			-- The output string.
    IF NOT EXISTS (
		SELECT	'X'
        FROM	attributes
        WHERE	model_name = in_model_name AND
				relational_name = in_relational_name AND
				attribute_type_name = in_data_type AND
                attribute_name = in_attribute_name) THEN
		SET results = concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relational_name, ' data type: ', in_data_type,
							' attribute: ', in_attribute_name, ' not found!');
	ELSE
	    IF (in_data_type = 'VARCHAR') THEN
	        SET length_string = (SELECT length
	                             FROM varchars
	                             WHERE model_name = in_model_name AND relational_name = in_relational_name AND attribute_name=in_attribute_name);
            SET results = CONCAT('    ',in_attribute_name, '   ', in_data_type,'(',length_string, ') NOT NULL');
        ELSEIF (in_data_type = 'DECIMAL') THEN
            SET precision_int = (SELECT `precision`
                                 FROM decimals
                                 WHERE model_name = in_model_name AND relational_name = in_relational_name AND attribute_name = in_attribute_name);
            SET scale_int = (SELECT scale
                             FROM decimals
                             WHERE model_name = in_model_name AND relational_name = in_relational_name AND attribute_name = in_attribute_name);
	        SET results = CONCAT('    ',in_attribute_name, '   ', in_data_type, '(', precision_int, ', ', scale_int, ') NOT NULL');
        ELSE
	        SET results = CONCAT('    ',in_attribute_name, '   ', in_data_type, ' NOT NULL');
        END IF;
	END IF;
	RETURN results;
END //
DELIMITER ;

# SELECT generate_attribute('Enrollment_System','departments','name','VARCHAR' );

# DROP FUNCTION generate_relation_scheme;
DELIMITER //
CREATE FUNCTION `generate_relation_scheme`(in_model_name VARCHAR(64), in_relation_name VARCHAR(64)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
	/*
    This generates the prototype DDL for a single relation scheme.
    @param	in_model_name			The name of the model that you want to generate the DDL for.
    @param	in_relation_scheme_name	The relaton scheme within that model that owns the attribute.
    @return							The DDL for this one relation scheme.
    */
	DECLARE results text default '';
	DECLARE candidateKeyName VARCHAR(64);
    DECLARE next_attribute VARCHAR(64);
	DECLARE next_primary_key VARCHAR(64);
	DECLARE next_candidate_key_name VARCHAR(64);
	DECLARE next_candidate_key VARCHAR(64);
    -- Flag to tell us whether this is the first column in the output
    DECLARE first BOOLEAN default true;
    DECLARE done int default 0;						-- Flag to get us out of the cursor
    DECLARE	relation_cur CURSOR FOR
		SELECT	attribute_name
        FROM	attributes
        WHERE	model_name = in_model_name AND
				relational_name = in_relation_name
		ORDER BY attribute_name;

	DECLARE primary_key_cur CURSOR FOR
	    SELECT attribute_name
	    FROM   candidate_key_members, primary_keys
	    WHERE candidate_key_members.model_name = in_model_name AND candidate_key_members.relational_name = in_relation_name
	      AND candidate_key_members.model_name = primary_keys.model_name AND candidate_key_members.relational_name = primary_keys.relational_name
	      AND candidate_key_members.candidate_key_name = primary_keys.primary_key_name
	    ORDER BY position;

	DECLARE candidate_key_cur CURSOR FOR
	    SELECT attribute_name
	    FROM   candidate_key_members
	    WHERE candidate_key_name  = candidateKeyName
	    ORDER BY position;

	DECLARE candidate_key_name_cur CURSOR FOR
	    SELECT candidate_key_name
	    FROM   candidate_keys, primary_keys
	    WHERE candidate_keys.model_name = in_model_name AND candidate_keys.relational_name = in_relation_name
	      AND candidate_keys.model_name = primary_keys.model_name AND candidate_keys.relational_name = primary_keys.relational_name
	      AND candidate_keys.candidate_key_name <> primary_keys.primary_key_name
	    ORDER BY candidate_key_name;

	-- This handler will flip the done flag after we read the last row from the cursor.
	DECLARE continue handler for not found set done = 1;
    IF NOT EXISTS (
		SELECT	'X'
        FROM	relation_schemes
        WHERE	model_name = in_model_name AND
				relational_name = in_relation_name) THEN
		SET results = concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relation_name,
								' does not exist!');
	ELSE
		SET results = concat ('CREATE TABLE	', in_relation_name, '(');
        OPEN relation_cur;
        REPEAT
			FETCH relation_cur into next_attribute;
            IF ! done THEN
				IF first THEN
					SET first = false;				-- Not the first attribute anymore.
                    -- This is the only way that I've been able to insert a CR/LF
                    SET results = CONCAT(results, '
', generate_attribute (in_model_name, in_relation_name, next_attribute, (SELECT attribute_type_name FROM attributes WHERE attribute_name=next_attribute AND model_name = in_model_name AND relational_name = in_relation_name)));
				ELSE
					SET results = CONCAT(results, ',
', generate_attribute (in_model_name, in_relation_name, next_attribute, (SELECT attribute_type_name FROM attributes WHERE attribute_name=next_attribute AND model_name = in_model_name AND relational_name = in_relation_name)));
				END IF;
            END IF;
		UNTIL done
        END REPEAT;
        CLOSE relation_cur;

# 		For primary keys
		SET candidateKeyName = (SELECT primary_key_name
		                        FROM primary_keys
		                        WHERE model_name = in_model_name AND relational_name = in_relation_name);
		SET results = CONCAT(results, ',
    CONSTRAINT       ', candidateKeyName,'       PRIMARY KEY (' );
		SET done = 0;
		SET first = true;
		OPEN primary_key_cur;
		REPEAT
            FETCH primary_key_cur into next_primary_key;
		    IF ! done THEN
		        IF first THEN
		            SET first = false;
                    SET results = CONCAT(results, next_primary_key);
                ELSE
		            SET results = CONCAT(results, ', ',next_primary_key);
                END IF;
            END IF;
        UNTIL done
        END REPEAT;
		CLOSE primary_key_cur;
        SET results = CONCAT(results, ')');

# 		For candidate keys
        SET done = 0;
		OPEN candidate_key_name_cur;
		REPEAT
            FETCH candidate_key_name_cur into next_candidate_key_name;
            IF ! done THEN
                SET candidateKeyName = next_candidate_key_name;
                SET results = CONCAT(results, ',
    CONSTRAINT      ', candidateKeyName, '      UNIQUE (');
                SET first = TRUE;
                OPEN candidate_key_cur;
                REPEAT
                    FETCH candidate_key_cur into next_candidate_key;
                    IF ! done THEN
                        IF first THEN
		                    SET first = false;
                            SET results = CONCAT(results, next_candidate_key);
                        ELSE
		                    SET results = CONCAT(results, ', ',next_candidate_key);
                        END IF;
                    END IF;
                UNTIL done
                END REPEAT;
                CLOSE candidate_key_cur;
                SET results = CONCAT(results, ')');
                SET done = 0;
            END IF;
        UNTIL done
        END REPEAT;
		CLOSE candidate_key_name_cur;
        SET results = CONCAT(results, '
);');
    END IF;
	RETURN results;
END //
DELIMITER ;

# SELECT generate_relation_scheme('Enrollment_System', 'sections');

# DROP FUNCTION generate_foreign_keys;
DELIMITER //
CREATE FUNCTION `generate_foreign_keys`(in_model_name VARCHAR(64), in_relation_name VARCHAR(64)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
	/*
    This generates the foreign keys for a single relation scheme.
    @param	in_model_name			The name of the model that you want to generate the DDL for.
    @param	in_relation_scheme_name	The relation scheme within that model that owns the attribute.
    @return							The foreign keys for this one relation scheme
    */
	DECLARE results text default '';
	DECLARE foreignKeyName VARCHAR(64);
	DECLARE next_foreign_key_name VARCHAR(64);
	DECLARE next_foreign_key VARCHAR(64);
	DECLARE second_table_name VARCHAR(64);
	DECLARE next_foreign_key_FROM_primary_key VARCHAR(64);
    -- Flag to tell us whether this is the first column in the output
    DECLARE first BOOLEAN default true;
    DECLARE done int default 0;						-- Flag to get us out of the cursor

    DECLARE foreign_key_cur CURSOR FOR
	    SELECT DISTINCT foreign_key_migrations.attribute_name
	    FROM foreign_key_migrations, candidate_key_members
	    WHERE foreign_key_name = foreignKeyName AND (candidate_key_members.attribute_name LIKE CONCAT('%', foreign_key_migrations.attribute_name,'%') OR candidate_key_members.attribute_name > foreign_key_migrations.attribute_name)
	    ORDER BY position;

	DECLARE foreign_key_name_cur CURSOR FOR
	    SELECT foreign_key_name
	    FROM foreign_keys
	    WHERE model_name = in_model_name AND relational_name = in_relation_name
	    ORDER BY foreign_key_name;

	DECLARE foreign_key_FROM_primary_key CURSOR FOR
	    SELECT attribute_name
	    FROM   candidate_key_members, primary_keys
	    WHERE candidate_key_members.model_name = in_model_name AND candidate_key_members.relational_name = second_table_name
	      AND candidate_key_members.model_name = primary_keys.model_name AND candidate_key_members.relational_name = primary_keys.relational_name
	      AND candidate_key_members.candidate_key_name = primary_keys.primary_key_name
	    ORDER BY position;

	-- This handler will flip the done flag after we read the last row from the cursor.
	DECLARE continue handler for not found set done = 1;
    IF NOT EXISTS (
		SELECT	'X'
        FROM	relation_schemes
        WHERE	model_name = in_model_name AND
				relational_name = in_relation_name) THEN
		SET results = concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relation_name,
								' does not exist!');
	ELSE
	    SET first = TRUE;
		OPEN foreign_key_name_cur;
		REPEAT
            FETCH foreign_key_name_cur into next_foreign_key_name;
            IF ! done THEN
                IF first THEN
                    SET first = FALSE;
                    SET foreignKeyName = next_foreign_key_name;
                    SET results = CONCAT(results, '
    ADD CONSTRAINT ', foreignKeyName, ' FOREIGN KEY (');
                ELSE
                    SET foreignKeyName = next_foreign_key_name;
                    SET results = CONCAT(results, ',
    ADD CONSTRAINT ', foreignKeyName, ' FOREIGN KEY (');
                END IF;
                SET first = TRUE;
                OPEN foreign_key_cur;
                REPEAT
                    FETCH foreign_key_cur into next_foreign_key;
                    IF ! done THEN
                        IF first THEN
                            SET first = FALSE;
                            SET results = CONCAT(results, next_foreign_key);
                        ELSE
                            SET results = CONCAT(results, ', ', next_foreign_key);
                        END IF;
                    END IF;
                UNTIL done
                END REPEAT;
                CLOSE foreign_key_cur;
                SET second_table_name = (SELECT relational_name
                                         FROM relation_schemes
                                         WHERE model_name = in_model_name AND relational_name <> in_relation_name AND foreignKeyName LIKE CONCAT('%', relational_name,'%'));
                SET results = CONCAT(results, ') REFERENCES ', second_table_name, '(');
                SET done = 0;
                SET first = true;
                OPEN foreign_key_FROM_primary_key;
                REPEAT
                    FETCH foreign_key_FROM_primary_key into next_foreign_key_FROM_primary_key;
                    IF ! done THEN
                        IF first THEN
                            SET first = false;
                            SET results = CONCAT(results, next_foreign_key_FROM_primary_key);
                        ELSE
                            SET results = CONCAT(results, ', ',next_foreign_key_FROM_primary_key);
                        END IF;
                    END IF;
                UNTIL done
                END REPEAT;
                CLOSE foreign_key_FROM_primary_key;
                SET results = CONCAT(results, ')');
                SET done = 0;
            END IF;
        UNTIL done
        END REPEAT;
		CLOSE foreign_key_name_cur;
    END IF;
	RETURN results;
END //
DELIMITER ;

# SELECT generate_foreign_keys('Enrollment_System', 'sections');

# DROP FUNCTION generate_model;
DELIMITER //
CREATE FUNCTION `generate_model`(in_model_name VARCHAR(64)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
	/*
    This generates the prototype DDL for an entire model.
    @param	in_model_name			The name of the model that you want to generate the DDL for.
    @return							The DDL for every relation scheme in this model.
    */
	DECLARE results TEXT default '';
	DECLARE next_relation_scheme VARCHAR(64);
    DECLARE first BOOLEAN default true;
    DECLARE done int default 0;
    DECLARE model_cur CURSOR FOR
		SELECT	relational_name
        FROM	relation_schemes
        WHERE	model_name = in_model_name
        ORDER BY relational_name;
	-- This handler will flip the done flag after we read the last row from the cursor.
	DECLARE continue handler for not found set done = 1;
	IF NOT EXISTS (
		SELECT	'X'
        FROM	models
        WHERE	name = in_model_name) THEN
        SET results = CONCAT('Error, model: ', in_model_name, ' does not exist!');
	ELSE
		OPEN model_cur;
        REPEAT
			FETCH model_cur into next_relation_scheme;
            -- SET results = CONCAT(results, next_relation_scheme, ' ');
            IF ! done THEN
				IF first THEN
					SET first = false;
                    SET results = CONCAT (results, '
', generate_relation_scheme (in_model_name, next_relation_scheme));
				ELSE
					SET results = CONCAT (results, '

', generate_relation_scheme (in_model_name, next_relation_scheme));
				END IF;
			END IF;
        UNTIL done
        END REPEAT;
        CLOSE model_cur;

# 		For foreign keys
		SET done = 0;
	    OPEN model_cur;
        REPEAT
			FETCH model_cur into next_relation_scheme;
            -- SET results = CONCAT(results, next_relation_scheme, ' ');
            IF ! done THEN
                IF EXISTS(SELECT foreign_key_name FROM foreign_keys WHERE model_name = in_model_name AND relational_name = next_relation_scheme) THEN
                    SET results = CONCAT (results, '

ALTER TABLE ', next_relation_scheme, generate_foreign_keys (in_model_name, next_relation_scheme), ';');
                END IF;
			END IF;
        UNTIL done
        END REPEAT;
        CLOSE model_cur;
    END IF;
	RETURN results;
END //
DELIMITER ;

# SELECT generate_model('Enrollment_System');

-- Procedures
# DROP PROCEDURE splitting_foreign_keys;
DELIMITER //
CREATE PROCEDURE `splitting_foreign_keys` (in_model_name VARCHAR(64), in_relation_name VARCHAR(64))
    READS SQL DATA
BEGIN
	/*
    This procedure outputs to the console whether any of the foreign key constraints going into
    the given relation scheme are splitting the key.
    @param	in_model_name			The name of the model.
    @param	in_relation_scheme_name	The relation scheme within that model.
    */
	DECLARE next_foreign_key_name VARCHAR(64);
	DECLARE next_foreign_key VARCHAR(64);
    DECLARE done int default 0;

	DECLARE foreign_key_name_cur CURSOR FOR
	SELECT DISTINCT foreign_key_name
        FROM foreign_key_migrations
        WHERE model_name = in_model_name AND relational_name = in_relation_name
          AND attribute_name IN (SELECT attribute_name
                                 FROM candidate_key_members
                                 WHERE model_name = in_model_name AND relational_name = in_relation_name AND candidate_key_name LIKE '%PK%');

	DECLARE foreign_key_cur CURSOR FOR
    SELECT attribute_name
    FROM foreign_key_migrations
    WHERE model_name = in_model_name AND relational_name = in_relation_name AND foreign_key_name = next_foreign_key_name;

	DECLARE continue handler for not found set done = 1;
    IF NOT EXISTS (
		SELECT	'X'
        FROM	relation_schemes
        WHERE	model_name = in_model_name AND
				relational_name = in_relation_name) THEN
		    SELECT concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relation_name,
								' does not exist!');
	ELSE
        OPEN foreign_key_name_cur;
        label1: REPEAT
            FETCH foreign_key_name_cur INTO next_foreign_key_name;
            IF ! done THEN
                OPEN foreign_key_cur;
                REPEAT
                    FETCH foreign_key_cur INTO next_foreign_key;
                    IF ! done THEN
                        IF next_foreign_key NOT IN (SELECT attribute_name
                                                FROM candidate_key_members
                                                WHERE model_name = in_model_name AND relational_name = in_relation_name AND candidate_key_name LIKE '%PK%') THEN
                            SELECT CONCAT('The primary Key for ', in_relation_name, ' splits ', next_foreign_key_name, '.') AS "OUTPUT";
                            LEAVE label1;
                        END IF;
                    END IF;
                UNTIL done
                END REPEAT;
                CLOSE foreign_key_cur;
                SET done = 0;
                SELECT CONCAT('The primary Key for ', in_relation_name, ' Dose Not split ', next_foreign_key_name, '.') AS "OUTPUT";
            END IF;
        UNTIL done
        END REPEAT label1;
        CLOSE foreign_key_name_cur;
    END IF;
END //
DELIMITER ;

# CALL splitting_foreign_keys('Enrollment_System', 'transcript_entries');

# DROP PROCEDURE subset_candidate_keys;
DELIMITER //
CREATE PROCEDURE `subset_candidate_keys` (in_model_name VARCHAR(64), in_relation_name VARCHAR(64))
    READS SQL DATA
BEGIN
	/*
    This procedure outputs to the console whether a candidate key is a subset of
    any other candidate key
    @param	in_model_name			The name of the model.
    @param	in_relation_scheme_name	The relation scheme within that model.
    */
	DECLARE next_candidate_key_name VARCHAR(64);
	DECLARE next_candidate_key VARCHAR(64);
    DECLARE done int default 0;

	DECLARE candidate_key_name_cur CURSOR FOR
	SELECT candidate_key_name
	FROM candidate_keys
	WHERE model_name = in_model_name AND relational_name = in_relation_name;


	DECLARE candidate_key_cur CURSOR FOR
    SELECT attribute_name
    FROM candidate_key_members
    WHERE model_name = in_model_name AND relational_name = in_relation_name AND candidate_key_name = next_candidate_key_name;

	DECLARE continue handler for not found set done = 1;
    IF NOT EXISTS (
		SELECT	'X'
        FROM	relation_schemes
        WHERE	model_name = in_model_name AND
				relational_name = in_relation_name) THEN
		    SELECT concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relation_name,
								' does not exist!');
	ELSE
	    IF(SELECT COUNT(candidate_key_name)
	       FROM candidate_keys
	       WHERE model_name = in_model_name AND relational_name = in_relation_name) > 1 THEN
	        OPEN candidate_key_name_cur;
	        label2: REPEAT
	            FETCH candidate_key_name_cur INTO next_candidate_key_name;
                IF ! done THEN
                    # Couldn't Finish !!!
                    SET done = 0;
                END IF;
            UNTIL done
            END REPEAT label2;
	        CLOSE candidate_key_name_cur;
	    ELSE
	        SELECT CONCAT('There are no candidate keys that are a subset of any other candidate keys in ', in_relation_name, ' relation scheme.');
        END IF;
	END IF;
END //
DELIMITER ;

# CALL subset_candidate_keys('Enrollment_System', 'students');


-- --------------------------------------------------------Test DDL output----------------------------------------------------------------------------

DROP TABLE transcript_entries;
DROP TABLE enrollments;
DROP TABLE grades;
DROP TABLE students;
DROP TABLE sections;
DROP TABLE courses;
DROP TABLE semesters;
DROP TABLE instructors;
DROP TABLE days;
DROP TABLE departments;


CREATE TABLE	courses(
    description   TEXT NOT NULL,
    name   VARCHAR(50) NOT NULL,
    number   INT NOT NULL,
    title   VARCHAR(50) NOT NULL,
    units   INT NOT NULL,
    CONSTRAINT       courses_PK       PRIMARY KEY (name, number),
    CONSTRAINT      courses_UK_01      UNIQUE (name, title)
);

CREATE TABLE	days(
    weekday_combinations   VARCHAR(20) NOT NULL,
    CONSTRAINT       days_PK       PRIMARY KEY (weekday_combinations)
);

CREATE TABLE	departments(
    name   VARCHAR(50) NOT NULL,
    CONSTRAINT       departments_PK       PRIMARY KEY (name)
);

CREATE TABLE	enrollments(
    course_number   INT NOT NULL,
    department_name   VARCHAR(50) NOT NULL,
    grade   VARCHAR(1) NOT NULL,
    section_number   INT NOT NULL,
    semester   VARCHAR(10) NOT NULL,
    student_id   INT NOT NULL,
    year   YEAR NOT NULL,
    CONSTRAINT       enrollments_PK       PRIMARY KEY (student_id, department_name, course_number, section_number, year, semester)
);

CREATE TABLE	grades(
    grade_letter   VARCHAR(1) NOT NULL,
    CONSTRAINT       grades_PK       PRIMARY KEY (grade_letter)
);

CREATE TABLE	instructors(
    instructor_name   VARCHAR(50) NOT NULL,
    CONSTRAINT       instructors_PK       PRIMARY KEY (instructor_name)
);

CREATE TABLE	sections(
    course_number   INT NOT NULL,
    days   VARCHAR(20) NOT NULL,
    department_name   VARCHAR(50) NOT NULL,
    instructor   VARCHAR(50) NOT NULL,
    number   INT NOT NULL,
    semester   VARCHAR(10) NOT NULL,
    start_time   TIME NOT NULL,
    year   YEAR NOT NULL,
    CONSTRAINT       sections_PK       PRIMARY KEY (department_name, course_number, number, year, semester)
);

CREATE TABLE	semesters(
    name   VARCHAR(10) NOT NULL,
    CONSTRAINT       semesters_PK       PRIMARY KEY (name)
);

CREATE TABLE	students(
    first_name   VARCHAR(25) NOT NULL,
    last_name   VARCHAR(25) NOT NULL,
    student_id   INT NOT NULL,
    CONSTRAINT       students_PK       PRIMARY KEY (student_id)
);

CREATE TABLE	transcript_entries(
    course_number   INT NOT NULL,
    department_name   VARCHAR(50) NOT NULL,
    section_number   INT NOT NULL,
    semester   VARCHAR(10) NOT NULL,
    student_id   INT NOT NULL,
    year   YEAR NOT NULL,
    CONSTRAINT       transcript_entries_PK       PRIMARY KEY (student_id, department_name, course_number)
);

ALTER TABLE courses
    ADD CONSTRAINT courses_departments_FK_01 FOREIGN KEY (name) REFERENCES departments(name);

ALTER TABLE enrollments
    ADD CONSTRAINT enrollments_grades_FK_03 FOREIGN KEY (grade) REFERENCES grades(grade_letter),
    ADD CONSTRAINT enrollments_sections_FK_02 FOREIGN KEY (department_name, course_number, section_number, year, semester) REFERENCES sections(department_name, course_number, number, year, semester),
    ADD CONSTRAINT enrollments_students_FK_01 FOREIGN KEY (student_id) REFERENCES students(student_id);

ALTER TABLE sections
    ADD CONSTRAINT sections_courses_FK_01 FOREIGN KEY (department_name, course_number) REFERENCES courses(name, number),
    ADD CONSTRAINT sections_days_FK_04 FOREIGN KEY (days) REFERENCES days(weekday_combinations),
    ADD CONSTRAINT sections_instructors_FK_03 FOREIGN KEY (instructor) REFERENCES instructors(instructor_name),
    ADD CONSTRAINT sections_semesters_FK_02 FOREIGN KEY (semester) REFERENCES semesters(name);

ALTER TABLE transcript_entries
    ADD CONSTRAINT transcript_entries_enrollments_FK_01 FOREIGN KEY (student_id, department_name, course_number, section_number, year, semester) REFERENCES enrollments(student_id, department_name, course_number, section_number, year, semester);

