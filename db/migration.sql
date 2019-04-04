-- Migration schema and tables

BEGIN;


CREATE SCHEMA migration_sys;


CREATE TABLE migration_sys.current (
    _id SERIAL NOT NULL,

    num INT NOT NULL,

    PRIMARY KEY (_id)
);

INSERT INTO
    migration_sys.current (
        num
    )
VALUES (
    0
);

CREATE TABLE migration_sys.history (
    _id SERIAL NOT NULL,

    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    num INT NOT NULL,

    PRIMARY KEY (_id)
);


END;


-- Migration functions

BEGIN;


CREATE OR REPLACE FUNCTION migrate(integer)
RETURNS void AS $$
    UPDATE
        migration_sys.current
    SET
        num = (SELECT num FROM migration_sys.current) + $1;

    INSERT INTO
        migration_sys.history (
            updated_at,
            num
        )
    SELECT
        CURRENT_TIMESTAMP,
        num
    FROM
        migration_sys.current;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION migrate_up()
RETURNS void AS $$
    SELECT migrate(1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION migrate_down()
RETURNS void AS $$
    SELECT migrate(-1);
$$ LANGUAGE SQL;


END;
