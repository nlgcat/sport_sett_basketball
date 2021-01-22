cd ./exported_files
cat D1_2014_data.txt D1_2015_data.txt D1_2016_data.txt > D1_training_data.txt
cat D1_2014_text.txt D1_2015_text.txt D1_2016_text.txt > D1_training_text.txt
cp D1_2017_data.txt D1_valid_data.txt
cp D1_2017_text.txt D1_valid_text.txt
cp D1_2018_data.txt D1_test_data.txt
cp D1_2018_text.txt D1_test_text.txt
