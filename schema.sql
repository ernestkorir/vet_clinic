/* Database schema to keep the structure of entire database. */

CREATE TABLE animals( 
    id integer NOT NULL,
    name varchar(100)
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weight_kg numeric,
    CONSTRAINT animals_pkey PRIMARY KEY (id)
)

ALTER TABLE animals
ADD COLUMN species VARCHAR(50);
;

--Craete owners table
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  age INTEGER
);

--Create species table
CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

--Modify animals table
DROP COLUMN species,
ADD COLUMN species_id INTEGER REFERENCES species(id),
ADD COLUMN owner_id INTEGER REFERENCES owners(id),
ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;