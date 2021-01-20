# SportSett:Basketball

This resource is designed to allow for research into Natural Language Generation.  In particular, with neural data-to-text approaches although it is not limited to these.  This page will be updated with more detail, as soon as I have time and am able to post examples of other work I am doing with this.  For the moment, see our [IntelLanG2020](https://intellang.github.io/papers/) paper [SportSett:Basketball - A robust and maintainabledataset for Natural Language Generation](https://intellang.github.io/papers/5-IntelLanG_2020_paper_5.pdf).  

## Quick Start
You will need a working [PostgreSQL](https://www.postgresql.org/) installation, as well as a working Ruby environment if you want to use the ORM.  I suggest using [RVM](https://rvm.io/), you will also need [Bundler](https://bundler.io/).  The ORM are written in [Ruby Sequel](https://github.com/jeremyevans/sequel) rather than ActiveRecord.  Whilst this is all in a Rails app, there is no front-end implemented, it is just a convenient way for me to create scripts using rake tasks.  Note that this resource is not meant to be efficient.  If you require high data throughput for some reason, you can use the raw SQL.  The Ruby code is meant to provide a simple way to write scripts to export data, this might take an hour or two to run but it is simple to code and the training of models takes way longer than that anyway, so I find it to be acceptable.

You will need to set the password etc in config/database.yml
```
development:
	adapter: postgresql
	database: sport_sett_development
	user: postgres # Also accept 'username' as key, if both are present 'username' is used
	password: postgrespassword
	host: 127.0.0.1 # Optional
	port: 5432 # Optional

```
ATTENTION!
The original SQL file contained a but where the team_in_games.winner column was often wrong.  This was a convenience column, the scores appear to all be correct.  The file has now been updated, using the score fields to derive then correct the winner column.

Then navigate to root directory of repo, download database archive file, and ensure you have the correct ruby environment set (if using something like RVM).  Large files can be found in [Google Drive](https://drive.google.com/drive/folders/11MG7uVDi5tB8By9WT_OqqqZ1NbiEaS3Y?usp=sharing).
```
bundle install
tar -xvjpf db_after_statistics_2018.sql.tar.bz2
psql -U postgres -d sport_sett_development < db_after_statistics_2018.sql
```

You can now generate output files in the format required for the [system of Rebuffel et al.](https://github.com/KaijuML/data-to-text-hierarchical).  This takes about 1 hour to run.  The result of the below command has been uploaded to [Google Drive](https://drive.google.com/drive/folders/11MG7uVDi5tB8By9WT_OqqqZ1NbiEaS3Y?usp=sharing) if you just want the OpenNMT training data without changing anything.

```
rake rebuffel:export
```
This will place several files in the **./exported_files** directory.  In order to create the partitions from these files as per our paper you need to combine the yearly files.  The yearly files contain data for just one season.
```
cd ./exported_files
cat D1_2015_data.txt D1_2015_data.txt D1_2015_data.txt > D1_training_data.txt
cat D1_2015_text.txt D1_2015_text.txt D1_2015_text.txt > D1_training_text.txt
cp D1_2017_data.txt D1_valid_data.txt
cp D1_2017_text.txt D1_valid_text.txt
cp D1_2018_data.txt D1_test_data.txt
cp D1_2018_text.txt D1_test_text.txt
```
You can of course combine these in other ways.  This is just the partition scheme we used in our paper.

## Dimensions
Please see **app/models/rebuffel_open_nmt_record.rb** for code which creates this data.  If you wanted to change the data for each input sample, this is where you would do it, either by editing this file or creating your own similar class which is used in the rake script.

Notice how the class names follow the dimensions highlighted in our paper.  The UML diagram shows these relationships.

WARNING:  There are some issues with the play-by-play statistics.  Sometimes, they do not line up with what is reported in the box score.  I am working on scripts to automatically resolve these, although early investigation suggests there is only about 1 mistake every other game.  A mistake is commonly just one basket being attributed to the wrong player.  You can use the play-by-play, there is a lot of data there, but there are discrepancies.  Given this is such a large dataset, with original data entry likely by humans, it will not be 100% perfect.  My current plan for this is to take the game data, game period data, and play-by-play, then resolve discrepancies automatically where 2/3 of the sources agree on a correct answer, and the error can be resolved a net-zero effect (same team totals, points etc).

## Playoff / Preseason Games
Whilst some of these games are in the original Rotowire dataset, they are not yet included here.  The database is designed in such a way that they can be added later.  There are several reasons for not including them yet.  Firstly, it takes time to import this stuff.  Secondly, just doing regular season games makes the machine learning problem simpler (and it is still very, very difficult).  Finally, preseason games are played in all kinds of places, even against teams from different leagues.

## A Note on Generated Files
Some functions in Ruby such as sort_by are not deterministic beyond their given arguments.  This means that items which are of equal value when sorted are not always presented in the same order (just together).  The code has also been changed slightly to make it simpler (it used to be several different functions doing similar things).  I only mention this here so you know that the dataset generated is not the exact one used in the paper.  This is no bad thing, running on the exact same dataset over and over again is a bad idea.

## This is a work in progress
This is code from an academic research project, trying to get us closer to a sensible data solution in this domain.  It is not finished, it is not a commercial product.  I am happy to answer questions if you are doing research, but please have reasonable expectations.

## UML DIagram
Some attributes are missing for this and it needs a general update and tidy, but it is mostly right.  You can find all attributes by looking at the SQL tables.  Rails Sequel naming conventions have been followed.
![UML Diagram](https://raw.githubusercontent.com/nlgcat/sport_sett_basketball/master/class_diagram.png)


