all: 01/answer 02/answer 03/answer 04/answer

01/answer: 01/process.rb 01/input
	ruby 01/process.rb > $@

02/answer: 02/process.rb 02/input-test 02/input
	ruby 02/process.rb 02/input-test-description 02/input-test | grep -E '1985'
	ruby 02/process.rb 02/input-description 02/input-test | grep -E '5DB3'
	ruby 02/process.rb 02/input-description 02/input > $@

03/answer: 03/process.rb
	ruby 03/process.rb 03/input

04/answer: 04/sum_sectors.rb
	ruby 04/sum_sectors.rb 04/input-test | grep -E '1514'
	ruby 04/sum_sectors.rb 04/input > $@
