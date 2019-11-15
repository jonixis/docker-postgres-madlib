# postgres-madlib

This image provides a postgres database (11.5) with the extension [MADlib](https://madlib.apache.org/) installed. The instance contains a table 'admission' with data of the following dataset: [Graduate Admission](https://www.kaggle.com/mohansacharya/graduate-admissions).

Automated builds are available on [dockerhub](https://hub.docker.com/repository/docker/jonixis/postgres-madlib)

## Installation

### Prerequisites

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [pgcli](https://www.pgcli.com/) (optional)

### Connect to database

docker-compose.yml
```yml
version: '3.7'

services:
  postgres:
    image: jonixis/postgres-madlib:latest
    container_name: postgres-madlib
    ports:
      - "5432:5432"
    restart: unless-stopped
    volumes:
      - data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: docker

volumes:
  data:
```

Start the container. Create file 'docker-compose.yml' and run command in same directory (automatically pulls image from dockerhub).
```sh
sudo docker-compose up -d
```

Connect to postgres from the host with e.g. [pgcli](https://www.pgcli.com/).
```sh
pgcli -h localhost -U postgres -d postgres
```
Password: ```docker```
A
## Data

The dataset is automatically loaded on the first startup of the container. The database is persisted in a [docker volume](https://docs.docker.com/storage/volumes/). Therefore, it lives on even if the container is deleted. If you want to reset the database simply remove container, delete volume and start container again:

Stop and remove container.
```sh
sudo docker-compose down
```

Delete docker volume with postgres data.
```sh
sudo docker volume rm docker-postgres-madlib_data
```

Start container.
```sh
sudo docker-compose up -d
```

## Example Query

To run a logistic regression on the admission table, run the following queries.

Convert 'chance_of_admit' to integer (0 or 1).
```sql
ALTER TABLE admission ALTER COLUMN chance_of_admit TYPE integer;
```

Train:
```sql
DROP TABLE IF EXISTS admission_logregr, admission_logregr_summary;
SELECT logregr_train( 'admission',                                                                       -- Source table
                      'admission_logregr',                                                               -- Output table
                      'chance_of_admit',                                                                 -- Dependent variable
                      'ARRAY[1, gre_score, toefl_score, university_rating, sop, lor, cgpa, research]',   -- Feature vector
                      NULL,                                                                              -- Grouping
                      20,                                                                                -- Max iterations
                      'irls'                                                                             -- Optimizer to use
                    );
```

Predict:
```sql
-- Display prediction value along with the original value
SELECT a.serial_no, logregr_predict(coef, ARRAY[1, gre_score, toefl_score, university_rating, sop, lor, cgpa, research]),
       a.chance_of_admit::BOOLEAN
FROM admission a, admission_logregr m
ORDER BY a.serial_no;
```

MADlib Documentation for Logistic Regression: https://madlib.apache.org/docs/latest/group__grp__logreg.html#examples 

-----

Source dataset `admission_table.csv`: https://www.kaggle.com/mohansacharya/graduate-admissions
