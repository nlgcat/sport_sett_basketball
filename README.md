# SportSett:Basketball

This resource is designed to allow for research into Natural Language Generation.  In particular, with neural data-to-text approaches although it is not limited to these.  This page will be updated with more detail, as soon as I have time and am able to post examples of other work I am doing with this.  For the moment, see our [IntelLanG2020](https://intellang.github.io/papers/) paper [SportSett:Basketball - A robust and maintainabledataset for Natural Language Generation](https://intellang.github.io/papers/5-IntelLanG_2020_paper_5.pdf).

You may also be interested in the simpler version of [SportSett](https://gem-benchmark.com/data_cards/sportsett_basketball) that is in [GEM](https://gem-benchmark.com/).  It is in JSON format rarther than being a database in Postgres, although it is only a subset of the data and is not suitable for complex queries.

## Quick Start
You will need a working [PostgreSQL](https://www.postgresql.org/) installation to setup the database.  Whilst this repository includes Ruby code for using the ORM to access the database, this will not be maintained or supported.  It was used to built the dataset and for creating JSON files for the paper, it is included here in case it is useful.

**Documentation and tutorial for using the dataset will be in SQL only** (along with some python examples for how to connect to the database).

There is no need to clone the repository to use the database, simply download the following files to a directory of your choosing.

The examples below use ```~/dirname```, and assume that you have a user ```postgres``` with password ```postgrespassword```, and that the database name is ```sport_sett_development```.  These can all be set to different values if you wish.

Download the files and place them in the directory you chose.
1. [Main Database SQL Script](https://drive.google.com/file/d/1m1ywZbMIsmOSV-2HUk7jzQ7rNIUeJOLC/view?usp=share_link)
2. [Denormalized Cache Tables](https://drive.google.com/file/d/1CN74cxLrlBQpcStJIF1GQJO0TcTE6y2T/view?usp=share_link)

Then run the below commands:
```
  cd ~/dirname
  
  # Extract the archives to get the SQL scripts that create the database
  tar -xvjpf db_after_statistics_2018_August_2020.sql.tar.bz2
  tar -xvjpf cache_sport_sett.sql.tar.bz2
  
  # Create the database in Postgres
  psql -U postgres -c 'create database sport_sett_development;'
  
  # Run the commands in the SQL script to create and populate the database tables
  psql -U postgres -d sport_sett_development < db_after_statistics_2018.sql
  
  # Run the commands to create the cache table (this has to be done after the above step)
  psql -U postgres -d sport_sett_development < cache_sport_sett.sql
```

Note that the ```db_after_statistics_2018.sql``` file in particular will take some time to run (some database tables contain millions of rows and indexes are created by the script for faster queries in the future).  On an i7 laptop it takes a few minutes to process each .sql file.  It will also take just over 5GB of storeage once in Postgres.

Then, to test the installation is working:
```
  psql -U postgres -d sport_sett_development -c 'SELECT * FROM conferences;'
```

Should output:
```
 id | league_id |        name        |         created_at         |         updated_at         
----+-----------+--------------------+----------------------------+----------------------------
  1 |         1 | Eastern Conference | 2020-04-23 16:19:32.906563 | 2020-04-23 16:19:32.906563
  2 |         1 | Western Conference | 2020-04-23 16:19:32.911953 | 2020-04-23 16:19:32.911953
(2 rows)
```
A full tutorial will be added shortly explaining how to query the database.  One convention is that all tables have an ```id``` (auto number) primary key column and any column that is suffixed with ```_id``` will be a foreign key for that table.  For example, if a table incudes the column ```conference_id``` then it refers to the ```id``` column in the ```conferences``` table.  Notice that the table names are inflected such that they are plural, whilst the keys are singular (this is a Ruby [Sequel](https://sequel.jeremyevans.net/) convention, once you get used to it you will quickly understand which foreign keys are in a table just by looking at the column names).

# Denormalized (cache) Tables
To make things easier for people, I have uploaded a SQL script which will add some denormalized tables created from the core tables (this is what cache_sport_sett.sql is in the above instructions).  This provides things like:

* Per player/team on game/period statistics, with each player/time-period on one row.
* The same, except for some name information about each row.

All such tables have names that are prefixed with cache_

On the statistics tables, each stat has a count, then also a "_double" column, which is one if it is "double digits", zero otherwise.  There are also columns at the end for whether the player had a "double-double" or "triple-double" etc.  These columns are included for teams, and per-period data as well, even though it does not always make sense to use it that way.

These have not been thoroughly tested yet, and I will at some point release the SQL scripts I used to make these tables (most likely in the form of postgres [materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html)).  I know the underlying table structure can seem daunting/obtuse.  It has been designed to allow for multiple sports and leagues whilst maintaining a high level of normalization.  It is like this, because I find it easier to work with, although I acknowledge that not everyone does.  For NLG research I am looking at simpler ways this data can be made available, and these 8 new tables are a first step in that direction.  You should be bale to just run the sql file with the psql command and write these tables atop your existing database.


## Data discrepancy issues
WARNING:  There are some issues with the play-by-play statistics.  Sometimes, they do not line up with what is reported in the box score.  I am working on scripts to automatically resolve these, although early investigation suggests there is only about 1 mistake every other game.  A mistake is commonly just one basket being attributed to the wrong player.  You can use the play-by-play, there is a lot of data there, but there are discrepancies.  Given this is such a large dataset, with original data entry likely by humans, it will not be 100% perfect.  My current plan for this is to take the game data, game period data, and play-by-play, then resolve discrepancies automatically where 2/3 of the sources agree on a correct answer, and the error can be resolved a net-zero effect (same team totals, points etc).

## Updated main database file
The original SQL file contained a but where the team_in_games.winner column was often wrong.  This was a convenience column, the scores appear to all be correct.  The file has now been updated, using the score fields to derive then correct the winner column.  The above instructions link to the correct, updated files.

## Playoff / Preseason Games
There are also some tables which are empty, for example any tables relating to playoff or preseason games.  Whilst some of these games are in the original Rotowire dataset, they are not yet included here.  The database is designed in such a way that they can be added later.  There are several reasons for not including them yet.  Firstly, it takes time to import this stuff.  Secondly, just doing regular season games makes the machine learning problem simpler (and it is still very, very difficult).  Finally, preseason games are played in all kinds of places, even against teams from different leagues.

## This is a work in progress
This is code from an academic research project, trying to get us closer to a sensible data solution in this domain.  It is not finished, it is not a commercial product.  I am happy to answer questions if you are doing research, but please have reasonable expectations.

## UML DIagram
Some attributes are missing for this and it needs a general update and tidy, but it is mostly right.  You can find all attributes by looking at the SQL tables.  Rails Sequel naming conventions have been followed.
![UML Diagram](https://raw.githubusercontent.com/nlgcat/sport_sett_basketball/master/class_diagram.png)
